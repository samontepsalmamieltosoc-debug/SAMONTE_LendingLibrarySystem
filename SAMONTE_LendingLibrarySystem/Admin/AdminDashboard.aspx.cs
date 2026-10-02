using System;
using System.Data;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardAnalytics();
            }
        }

        private void LoadDashboardAnalytics()
        {
            DataSet ds = DbHelper.ExecuteSPDataSet("sp_GetDashboardAnalytics");

            if (ds != null && ds.Tables.Count >= 4)
            {
                // Table 0: Key Metrics
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow r = ds.Tables[0].Rows[0];
                    lblTotalTools.Text = r["TotalTools"].ToString();
                    lblActiveBorrows.Text = r["ActiveBorrows"].ToString();
                    lblOverdueLoans.Text = r["OverdueLoans"].ToString();
                    lblPendingReservations.Text = r["PendingReservations"].ToString();
                    lblUnpaidFines.Text = string.Format("₱{0:N2}", r["UnpaidFines"]);
                    lblCollectedFines.Text = string.Format("₱{0:N2}", r["CollectedFines"]);
                    lblDamagedItems.Text = r["DamagedItems"].ToString();
                }

                // Table 1: Popular Tools
                gvPopularTools.DataSource = ds.Tables[1];
                gvPopularTools.DataBind();

                // Table 2: Overdue Watchlist
                gvOverdueWatchlist.DataSource = ds.Tables[2];
                gvOverdueWatchlist.DataBind();

                // Table 3: Recent Activity Feed
                gvRecentTransactions.DataSource = ds.Tables[3];
                gvRecentTransactions.DataBind();
            }
        }
    }
}