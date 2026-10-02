using System;
using System.Data;
using System.Data.SqlClient;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Modules
{
    public class QueueManager
    {
        public static bool JoinWaitlistQueue(int toolId, int borrowerId)
        {
            string sql = @"
                DECLARE @NextPos INT;
                SELECT @NextPos = ISNULL(MAX(QueuePosition), 0) + 1 
                FROM Reservations 
                WHERE ToolID = @ToolID AND ReservationStatus = 'Pending';

                INSERT INTO Reservations (ToolID, BorrowerID, QueuePosition, ReservationStatus)
                VALUES (@ToolID, @BorrowerID, @NextPos, 'Pending');";

            SqlParameter[] p = {
                new SqlParameter("@ToolID", toolId),
                new SqlParameter("@BorrowerID", borrowerId)
            };

            return DbHelper.ExecuteNonQuery(sql, p) > 0;
        }

        public static void CheckAndNotifyNextInQueue(int toolId)
        {
            string queueQuery = @"
                SELECT TOP 1 ReservationID 
                FROM Reservations 
                WHERE ToolID = @ToolID AND ReservationStatus = 'Pending' 
                ORDER BY QueuePosition ASC";

            object resId = DbHelper.ExecuteScalar(queueQuery, new SqlParameter[] { new SqlParameter("@ToolID", toolId) });

            if (resId != null)
            {
                string notifySql = "UPDATE Reservations SET ReservationStatus = 'Notified' WHERE ReservationID = @ResID";
                DbHelper.ExecuteNonQuery(notifySql, new SqlParameter[] { new SqlParameter("@ResID", Convert.ToInt32(resId)) });
            }
        }
    }
}