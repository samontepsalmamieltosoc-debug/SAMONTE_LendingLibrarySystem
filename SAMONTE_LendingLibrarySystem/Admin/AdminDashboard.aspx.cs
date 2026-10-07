using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Script.Serialization;
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
                var data = new Dictionary<string, object>();

                // Table 0: Key Metrics
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow r = ds.Tables[0].Rows[0];
                    data["metrics"] = new
                    {
                        totalTools = Convert.ToInt32(r["TotalTools"]),
                        activeBorrows = Convert.ToInt32(r["ActiveBorrows"]),
                        overdueLoans = Convert.ToInt32(r["OverdueLoans"]),
                        pendingReservations = Convert.ToInt32(r["PendingReservations"]),
                        unpaidFines = Convert.ToDecimal(r["UnpaidFines"]),
                        collectedFines = Convert.ToDecimal(r["CollectedFines"]),
                        damagedItems = Convert.ToInt32(r["DamagedItems"])
                    };
                }

                // Table 1: Popular Tools
                var popular = new List<object>();
                foreach (DataRow r in ds.Tables[1].Rows)
                {
                    popular.Add(new
                    {
                        name = Convert.ToString(r["ToolName"]),
                        category = Convert.ToString(r["CategoryName"]),
                        borrows = Convert.ToInt32(r["TimesBorrowed"])
                    });
                }
                data["popular"] = popular;

                // Table 2: Overdue Watchlist
                var overdue = new List<object>();
                foreach (DataRow r in ds.Tables[2].Rows)
                {
                    overdue.Add(new
                    {
                        borrower = Convert.ToString(r["Borrower"]),
                        tool = Convert.ToString(r["ToolName"]),
                        days = Convert.ToInt32(r["DaysOverdue"])
                    });
                }
                data["overdue"] = overdue;

                // The charts are drawn client-side from this block. "<" is escaped so a tool name can never close the script tag.
                string json = new JavaScriptSerializer().Serialize(data).Replace("<", "\\u003c");
                litDashData.Text = "<script id=\"dashData\" type=\"application/json\">" + json + "</script>";

                // Table 3: Recent Activity Feed
                gvRecentTransactions.DataSource = ds.Tables[3];
                gvRecentTransactions.DataBind();
            }
        }
    }
}
