using System;
using System.Data;
using System.Data.SqlClient;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.User
{
    public partial class MyFines : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserFines();
            }
        }

        private void LoadUserFines()
        {
            int borrowerId = Convert.ToInt32(Session["UserID"]);

            // Fetch fine records via Stored Procedure
            SqlParameter[] queryParams = { new SqlParameter("@BorrowerID", borrowerId) };
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetUserFines", queryParams);

            gvUserFines.DataSource = dt;
            gvUserFines.DataBind();

            // Fetch total unpaid balance via Stored Procedure
            SqlParameter[] totalParams = { new SqlParameter("@BorrowerID", borrowerId) };
            object totalResult = DbHelper.ExecuteSPScalar("sp_GetUserTotalUnpaidFine", totalParams);

            if (totalResult != DBNull.Value && totalResult != null)
            {
                decimal totalUnpaid = Convert.ToDecimal(totalResult);
                lblTotalUnpaid.Text = string.Format("₱{0:N2}", totalUnpaid);
            }
            else
            {
                lblTotalUnpaid.Text = "₱0.00";
            }
        }
    }
}