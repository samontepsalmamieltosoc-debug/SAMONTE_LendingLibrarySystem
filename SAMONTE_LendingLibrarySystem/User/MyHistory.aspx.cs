using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.User
{
    public partial class MyHistory : System.Web.UI.Page
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
                LoadUserData();
            }
        }

        private void LoadUserData()
        {
            int borrowerId = Convert.ToInt32(Session["UserID"]);

            SqlParameter[] p1 = { new SqlParameter("@BorrowerID", borrowerId) };
            DataTable dtBorrows = DbHelper.ExecuteSPDataTable("sp_GetUserBorrowHistory", p1);
            gvMyBorrows.DataSource = dtBorrows;
            gvMyBorrows.DataBind();

            SqlParameter[] p2 = { new SqlParameter("@BorrowerID", borrowerId) };
            DataTable dtRes = DbHelper.ExecuteSPDataTable("sp_GetUserReservationHistory", p2);
            gvMyReservations.DataSource = dtRes;
            gvMyReservations.DataBind();
        }

        protected void gvMyBorrows_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                Label lblStatus = (Label)e.Row.FindControl("lblOverdueStatus");

                object actualReturnObj = rowView["ActualReturnDate"];
                object expectedReturnObj = rowView["ExpectedReturnDate"];

                // Check if the item has not been returned yet
                if (actualReturnObj == DBNull.Value || actualReturnObj == null)
                {
                    if (expectedReturnObj != DBNull.Value)
                    {
                        DateTime expectedReturn = Convert.ToDateTime(expectedReturnObj);

                        if (DateTime.Now.Date > expectedReturn.Date)
                        {
                            int daysOverdue = (DateTime.Now.Date - expectedReturn.Date).Days;
                            lblStatus.Text = $"⚠️️ Overdue ({daysOverdue} {(daysOverdue == 1 ? "day" : "days")})";
                            lblStatus.CssClass = "badge-overdue";
                        }
                        else
                        {
                            lblStatus.Text = "Active / On Time";
                            lblStatus.CssClass = "badge-ontime";
                        }
                    }
                }
                else
                {
                    lblStatus.Text = "Returned";
                    lblStatus.CssClass = "badge-returned";
                }
            }
        }
    }
}