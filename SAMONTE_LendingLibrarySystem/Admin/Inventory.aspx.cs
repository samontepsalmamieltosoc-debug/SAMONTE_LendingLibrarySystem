using System;
using System.Data;
using System.Data.SqlClient;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Admin
{
    public partial class Inventory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadInventory();
            }
        }

        private void LoadInventory()
        {
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetInventory");
            gvTools.DataSource = dt;
            gvTools.DataBind();
        }

        protected void btnAddTool_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtToolName.Text) ||
                string.IsNullOrWhiteSpace(txtCategory.Text) ||
                !int.TryParse(txtQty.Text.Trim(), out int qty) || qty <= 0)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Please provide a valid tool name, category, and quantity greater than zero.";
                return;
            }

            SqlParameter[] p = {
                new SqlParameter("@Name", txtToolName.Text.Trim()),
                new SqlParameter("@Category", txtCategory.Text.Trim()),
                new SqlParameter("@Qty", qty)
            };

            DbHelper.ExecuteSPNonQuery("sp_AddTool", p);

            lblMsg.ForeColor = System.Drawing.Color.Green;
            lblMsg.Text = "Tool added successfully!";
            txtToolName.Text = "";
            txtCategory.Text = "";
            txtQty.Text = "";
            LoadInventory();
        }
    }
}