using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Modules
{
    /// <summary>
    /// The admin's check of a tool after it comes back. Until the admin decides, BorrowTransactions.ConditionOnReturn stays NULL;
    /// a 'Damaged' decision is what makes the loan selectable on the Damaged Items page (see GetDamagedAwaitingFine).
    /// </summary>
    public class ReturnAssessment
    {
        public const string Good = "Good";
        public const string Damaged = "Damaged";

        public static DataTable GetReturnedLoans()
        {
            // A loan that already has a fine is shown as Damaged even if ConditionOnReturn was never set (fines come from damage).
            string sql = @"
                SELECT bt.TransactionID, bt.ToolID, b.FullName AS BorrowerName, t.ToolName,
                       ISNULL(c.CategoryName, '') AS CategoryName,
                       bt.BorrowDate, bt.ExpectedReturnDate, bt.ActualReturnDate,
                       bt.ReturnImagePath, t.ImageURL,
                       CASE WHEN f.FineID IS NULL THEN 0 ELSE 1 END AS HasFine,
                       CASE WHEN f.FineID IS NULL THEN bt.ConditionOnReturn ELSE 'Damaged' END AS AssessedCondition
                FROM BorrowTransactions bt
                JOIN Borrowers b ON bt.BorrowerID = b.BorrowerID
                JOIN Tools t ON bt.ToolID = t.ToolID
                LEFT JOIN Categories c ON t.CategoryID = c.CategoryID
                OUTER APPLY (SELECT TOP 1 FineID FROM Fines WHERE TransactionID = bt.TransactionID) f
                WHERE bt.TransactionStatus = 'Returned'
                ORDER BY bt.ActualReturnDate DESC";

            return DbHelper.ExecuteQuery(sql);
        }

        /// <summary>Records the admin's decision. Returns false if the loan isn't a returned one or already has a fine (the decision is then locked).</summary>
        public static bool Assess(int transactionId, string condition)
        {
            if (condition != Good && condition != Damaged) return false;

            string sql = @"
                UPDATE BorrowTransactions
                SET ConditionOnReturn = @Condition
                WHERE TransactionID = @TxID
                  AND TransactionStatus = 'Returned'
                  AND NOT EXISTS (SELECT 1 FROM Fines WHERE TransactionID = @TxID)";

            SqlParameter[] p = {
                new SqlParameter("@Condition", condition),
                new SqlParameter("@TxID", transactionId)
            };

            return DbHelper.ExecuteNonQuery(sql, p) > 0;
        }

        /// <summary>Returned loans the admin marked Damaged that don't have a fine yet. Same rule as sp_GetTransactionsForFines, with the item details.</summary>
        public static DataTable GetDamagedAwaitingFine()
        {
            string sql = @"
                SELECT bt.TransactionID, bt.ToolID, t.ToolName,
                       ISNULL(c.CategoryName, '') AS CategoryName,
                       b.FullName AS BorrowerName,
                       bt.BorrowDate, bt.ExpectedReturnDate, bt.ActualReturnDate,
                       bt.ReturnImagePath, t.ImageURL
                FROM BorrowTransactions bt
                JOIN Borrowers b ON bt.BorrowerID = b.BorrowerID
                JOIN Tools t ON bt.ToolID = t.ToolID
                LEFT JOIN Categories c ON t.CategoryID = c.CategoryID
                WHERE bt.ConditionOnReturn = 'Damaged'
                  AND NOT EXISTS (SELECT 1 FROM Fines WHERE TransactionID = bt.TransactionID)
                ORDER BY bt.TransactionID DESC";

            return DbHelper.ExecuteQuery(sql);
        }

        /// <summary>Turns a stored image path ("~/Uploads/x.jpg", "Uploads/x.jpg" or a full URL) into something an img tag can use; "" if none.</summary>
        public static string ResolveImage(object path)
        {
            string p = Convert.ToString(path);
            if (string.IsNullOrWhiteSpace(p)) return "";

            p = p.Trim();
            return p.StartsWith("~/") ? VirtualPathUtility.ToAbsolute(p) : p;
        }
    }
}
