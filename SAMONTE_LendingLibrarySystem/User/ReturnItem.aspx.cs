using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.User
{
    public partial class ReturnItem : System.Web.UI.Page
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
                LoadActiveBorrows();
            }
        }

        private void LoadActiveBorrows()
        {
            try
            {
                int borrowerId = Convert.ToInt32(Session["UserID"]);
                SqlParameter[] p = { new SqlParameter("@BorrowerID", borrowerId) };

                DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetActiveBorrowsByBorrower", p);

                gvActiveBorrows.DataSource = dt;
                gvActiveBorrows.DataBind();
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading borrowed items: " + ex.Message, false);
            }
        }

        protected void gvActiveBorrows_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ReturnTool")
            {
                try
                {
                    int rowIndex = Convert.ToInt32(e.CommandArgument);
                    int transactionId = Convert.ToInt32(gvActiveBorrows.DataKeys[rowIndex]["TransactionID"]);
                    int toolId = Convert.ToInt32(gvActiveBorrows.DataKeys[rowIndex]["ToolID"]);

                    SqlParameter[] p = {
                        new SqlParameter("@TransactionID", transactionId),
                        new SqlParameter("@ToolID", toolId)
                    };

                    DbHelper.ExecuteSPNonQuery("sp_ReturnTool", p);

                    ShowMessage("Tool returned successfully!", true);
                    LoadActiveBorrows();
                }
                catch (Exception ex)
                {
                    ShowMessage("Failed to return tool: " + ex.Message, false);
                }
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMsg.Text = message;
            lblMsg.Visible = true;
            lblMsg.CssClass = isSuccess ? "msg-box msg-success" : "msg-box msg-error";
        }
    }
}