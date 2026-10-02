using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Admin
{
    public partial class ManageRequests : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RefreshAllData();
            }
        }

        private void RefreshAllData()
        {
            LoadPendingRequests();
            LoadMasterQueue();
        }

        private void LoadPendingRequests()
        {
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetPendingRequests");
            gvPendingRequests.DataSource = dt;
            gvPendingRequests.DataBind();
        }

        private void LoadMasterQueue()
        {
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetMasterQueue");
            gvAllQueue.DataSource = dt;
            gvAllQueue.DataBind();
        }

        protected void gvPendingRequests_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ApproveRequest" || e.CommandName == "RejectRequest")
            {
                int index = Convert.ToInt32(e.CommandArgument);

                int reservationId = Convert.ToInt32(gvPendingRequests.DataKeys[index].Values["ReservationID"]);
                int toolId = Convert.ToInt32(gvPendingRequests.DataKeys[index].Values["ToolID"]);
                int borrowerId = Convert.ToInt32(gvPendingRequests.DataKeys[index].Values["BorrowerID"]);

                if (e.CommandName == "ApproveRequest")
                {
                    try
                    {
                        SqlParameter[] p = {
                            new SqlParameter("@ReservationID", reservationId),
                            new SqlParameter("@ToolID", toolId),
                            new SqlParameter("@BorrowerID", borrowerId)
                        };

                        DbHelper.ExecuteSPNonQuery("sp_ApproveAndIssueLoan", p);

                        lblMsg.ForeColor = System.Drawing.Color.Green;
                        lblMsg.Text = "Request accepted successfully! Active loan generated and stock updated.";
                    }
                    catch (Exception ex)
                    {
                        lblMsg.ForeColor = System.Drawing.Color.Red;
                        lblMsg.Text = "Cannot accept request: " + ex.Message;
                    }
                }
                else if (e.CommandName == "RejectRequest")
                {
                    SqlParameter[] p = { new SqlParameter("@ReservationID", reservationId) };
                    DbHelper.ExecuteSPNonQuery("sp_RejectReservation", p);

                    lblMsg.ForeColor = System.Drawing.Color.DarkOrange;
                    lblMsg.Text = "Reservation request rejected.";
                }

                RefreshAllData();
            }
        }
    }
}