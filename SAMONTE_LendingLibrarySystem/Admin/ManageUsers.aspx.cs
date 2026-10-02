using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetUsers");
            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                int borrowerId = Convert.ToInt32(gvUsers.DataKeys[index].Value);
                string currentStatus = gvUsers.Rows[index].Cells[4].Text.Trim();

                string newStatus = (currentStatus == "Active") ? "Inactive" : "Active";

                SqlParameter[] p = {
                    new SqlParameter("@BorrowerID", borrowerId),
                    new SqlParameter("@Status", newStatus)
                };

                if (DbHelper.ExecuteSPNonQuery("sp_UpdateUserStatus", p) > 0)
                {
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                    lblMsg.Text = $"User account status successfully updated to {newStatus}.";
                    LoadUsers();
                }
            }
        }
    }
}