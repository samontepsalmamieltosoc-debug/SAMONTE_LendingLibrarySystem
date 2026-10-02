using System;
using System.Data;
using System.Data.SqlClient;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Modules
{
    public class LoanEngine
    {
        public static bool IssueLoan(int toolId, int borrowerId, int daysToBorrow)
        {
            string checkQty = "SELECT AvailableQty FROM Tools WHERE ToolID = @ToolID";
            object result = DbHelper.ExecuteScalar(checkQty, new SqlParameter[] { new SqlParameter("@ToolID", toolId) });

            if (result == null || Convert.ToInt32(result) <= 0)
            {
                return false;
            }

            string sql = @"
                BEGIN TRANSACTION;
                    INSERT INTO BorrowTransactions (ToolID, BorrowerID, ExpectedReturnDate, TransactionStatus)
                    VALUES (@ToolID, @BorrowerID, DATEADD(day, @Days, GETDATE()), 'Active');

                    UPDATE Tools 
                    SET AvailableQty = AvailableQty - 1 
                    WHERE ToolID = @ToolID;
                COMMIT;";

            SqlParameter[] p = {
                new SqlParameter("@ToolID", toolId),
                new SqlParameter("@BorrowerID", borrowerId),
                new SqlParameter("@Days", daysToBorrow)
            };

            return DbHelper.ExecuteNonQuery(sql, p) > 0;
        }

        public static void ProcessReturn(int transactionId, int toolId, string returnCondition)
        {
            string returnSql = @"
                BEGIN TRANSACTION;
                    UPDATE BorrowTransactions 
                    SET ActualReturnDate = GETDATE(), 
                        TransactionStatus = 'Returned', 
                        ConditionOnReturn = @Condition 
                    WHERE TransactionID = @TxID;

                    UPDATE Tools 
                    SET AvailableQty = AvailableQty + 1,
                        ConditionStatus = @Condition
                    WHERE ToolID = @ToolID;
                COMMIT;";

            SqlParameter[] p1 = {
                new SqlParameter("@TxID", transactionId),
                new SqlParameter("@ToolID", toolId),
                new SqlParameter("@Condition", returnCondition)
            };
            DbHelper.ExecuteNonQuery(returnSql, p1);

            QueueManager.CheckAndNotifyNextInQueue(toolId);
        }
    }
}