using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using SAMONTE_LendingLibrarySystem.Helpers;
using SAMONTE_LendingLibrarySystem.Modules;

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

        // Returned loans the admin marked Damaged on the Returned Items page that don't have a fine yet
        private void LoadTransactionsDropdown()
        {
            DataTable dt = ReturnAssessment.GetDamagedAwaitingFine();

            ddlTransactions.Items.Clear();
            ddlTransactions.Items.Add(new ListItem(dt.Rows.Count > 0 ? "-- Select Transaction --" : "-- No damaged items waiting --", ""));
            foreach (DataRow r in dt.Rows)
            {
                string text = string.Format("Tx #{0} - {1} (Item #{2}) - {3}", r["TransactionID"], r["ToolName"], r["ToolID"], r["BorrowerName"]);
                ddlTransactions.Items.Add(new ListItem(text, Convert.ToString(r["TransactionID"])));
            }

            pnlNoDamaged.Visible = dt.Rows.Count == 0;
            pnlItem.Visible = false;
        }

        protected void ddlTransactions_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowSelectedItem();
        }

        // Shows exactly which item the fine will be issued for
        private void ShowSelectedItem()
        {
            DataRow item = null;
            int transactionId;
            if (int.TryParse(ddlTransactions.SelectedValue, out transactionId))
            {
                DataRow[] rows = ReturnAssessment.GetDamagedAwaitingFine().Select("TransactionID = " + transactionId);
                if (rows.Length > 0) item = rows[0];
            }

            if (item == null)
            {
                pnlItem.Visible = false;
                return;
            }

            string name = Convert.ToString(item["ToolName"]);
            string category = Convert.ToString(item["CategoryName"]);
            string photo = ReturnAssessment.ResolveImage(item["ReturnImagePath"]);
            if (photo.Length == 0) photo = ReturnAssessment.ResolveImage(item["ImageURL"]);

            imgItem.ImageUrl = photo;
            imgItem.AlternateText = "Photo of " + name;
            imgItem.Visible = photo.Length > 0;
            itemTile.Visible = photo.Length == 0;

            litItemInitial.Text = name.Length > 0 ? name.Substring(0, 1).ToUpper() : "?";
            litItemName.Text = name;
            litItemCategory.Text = category.Length > 0 ? category : "Uncategorized";
            litItemId.Text = "#" + item["ToolID"];
            litItemTx.Text = "#" + item["TransactionID"];
            litItemBorrower.Text = Convert.ToString(item["BorrowerName"]);
            litItemBorrowed.Text = FormatDate(item["BorrowDate"], "yyyy-MM-dd");
            litItemDue.Text = FormatDate(item["ExpectedReturnDate"], "yyyy-MM-dd");
            litItemReturned.Text = FormatDate(item["ActualReturnDate"], "yyyy-MM-dd HH:mm");
            pnlItem.Visible = true;
        }

        private static string FormatDate(object value, string format)
        {
            return value == null || value == DBNull.Value ? "-" : Convert.ToDateTime(value).ToString(format);
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

            // sp_AssessFine doesn't check this itself, so make sure the loan is still marked Damaged and hasn't been fined in the meantime
            if (ReturnAssessment.GetDamagedAwaitingFine().Select("TransactionID = " + transactionId).Length == 0)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "That transaction is no longer waiting for a fine. The list has been refreshed.";
                LoadTransactionsDropdown();
                return;
            }

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