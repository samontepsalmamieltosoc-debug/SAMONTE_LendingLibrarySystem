using System;
using System.Data;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Modules
{
    public class ReportingEngine
    {
        public static DataTable GetOverdueLoans()
        {
            string query = @"
                SELECT bt.TransactionID, b.FullName, b.ContactNo, t.ToolName, bt.BorrowDate, bt.ExpectedReturnDate
                FROM BorrowTransactions bt
                INNER JOIN Borrowers b ON bt.BorrowerID = b.BorrowerID
                INNER JOIN Tools t ON bt.ToolID = t.ToolID
                WHERE bt.TransactionStatus = 'Active' AND bt.ExpectedReturnDate < GETDATE()";

            return DbHelper.ExecuteQuery(query);
        }
    }
}