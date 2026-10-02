using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.Admin
{
    public partial class ManageDamagedItems : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTransactionsDropdown();
                LoadFinesGrid();
            }
        }

        private void LoadTransactionsDropdown()
        {
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetTransactionsForFines");
            ddlTransactions.DataSource = dt;
            ddlTransactions.DataTextField = "DisplayText";
            ddlTransactions.DataValueField = "TransactionID";
            ddlTransactions.DataBind();

            ddlTransactions.Items.Insert(0, new ListItem("-- Select Transaction --", ""));
        }

        private void LoadFinesGrid()
        {
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetFines");
            gvFines.DataSource = dt;
            gvFines.DataBind();
        }

        protected void btnAssessFine_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlTransactions.SelectedValue))
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Please select a transaction.";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtDamageNotes.Text))
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Please provide damage details.";
                return;
            }

            if (!decimal.TryParse(txtFineAmount.Text.Trim(), out decimal fineAmount) || fineAmount <= 0)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Please enter a valid fine amount greater than zero.";
                return;
            }

            int transactionId = Convert.ToInt32(ddlTransactions.SelectedValue);

            SqlParameter[] p = {
                new SqlParameter("@TxID", transactionId),
                new SqlParameter("@DamageNotes", txtDamageNotes.Text.Trim()),
                new SqlParameter("@FineAmount", fineAmount)
            };

            DbHelper.ExecuteSPNonQuery("sp_AssessFine", p);

            lblMsg.ForeColor = System.Drawing.Color.Green;
            lblMsg.Text = "Fine assessed successfully and tool flagged as damaged!";
            txtDamageNotes.Text = "";
            txtFineAmount.Text = "";

            // Reload dropdown to strip out the newly fined transaction
            LoadTransactionsDropdown();
            LoadFinesGrid();
        }

        protected void gvFines_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "MarkAsPaid")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                int fineId = Convert.ToInt32(gvFines.DataKeys[index].Value);

                SqlParameter[] p = { new SqlParameter("@FineID", fineId) };

                if (DbHelper.ExecuteSPNonQuery("sp_MarkFineAsPaid", p) > 0)
                {
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                    lblMsg.Text = "Payment recorded successfully!";
                    LoadFinesGrid();
                }
            }
        }
    }
}