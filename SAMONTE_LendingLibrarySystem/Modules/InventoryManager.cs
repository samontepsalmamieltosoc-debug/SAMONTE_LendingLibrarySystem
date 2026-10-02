using System;
using System.Data;
using System.Data.SqlClient;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Modules
{
    public class InventoryManager
    {
        public static bool AddNewTool(string name, int categoryId, string condition, int qty, string imageUrl = null)
        {
            string query = @"INSERT INTO Tools (ToolName, CategoryID, ConditionStatus, TotalQty, AvailableQty, ImageURL) 
                            VALUES (@Name, @CatID, @Condition, @Qty, @Qty, @Img)";

            SqlParameter[] p = {
                new SqlParameter("@Name", name),
                new SqlParameter("@CatID", categoryId),
                new SqlParameter("@Condition", condition),
                new SqlParameter("@Qty", qty),
                new SqlParameter("@Img", (object)imageUrl ?? DBNull.Value)
            };

            return DbHelper.ExecuteNonQuery(query, p) > 0;
        }
    }
}