using System;
using SAMONTE_LendingLibrarySystem.Modules;

namespace SAMONTE_LendingLibrarySystem.Admin
{
    public partial class ReturnedItems : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReturnedItems();
            }
        }

        private void LoadReturnedItems()
        {
            gvReturnedItems.DataSource = ReturnAssessment.GetReturnedLoans();
            gvReturnedItems.DataBind();
        }

        protected void btnMarkGood_Click(object sender, EventArgs e)
        {
            SaveAssessment(ReturnAssessment.Good);
        }

        protected void btnMarkDamaged_Click(object sender, EventArgs e)
        {
            SaveAssessment(ReturnAssessment.Damaged);
        }

        private void SaveAssessment(string condition)
        {
            int transactionId;
            if (!int.TryParse(hfTxId.Value, out transactionId))
            {
                ShowMessage("We couldn't tell which return you meant. Please open the item and try again.", System.Drawing.Color.Red);
            }
            else
            {
                try
                {
                    if (!ReturnAssessment.Assess(transactionId, condition))
                    {
                        ShowMessage("Transaction #" + transactionId + " couldn't be updated. It may already have a fine issued, or it isn't a returned loan.", System.Drawing.Color.Red);
                    }
                    else if (condition == ReturnAssessment.Damaged)
                    {
                        ShowMessage("Transaction #" + transactionId + " marked as Damaged. It can now be selected on the Damaged Items page to assess a fine.", System.Drawing.Color.DarkOrange);
                    }
                    else
                    {
                        ShowMessage("Transaction #" + transactionId + " marked as Good.", System.Drawing.Color.Green);
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Failed to save the assessment: " + ex.Message, System.Drawing.Color.Red);
                }
            }

            hfTxId.Value = "";
            LoadReturnedItems();
        }

        protected bool IsAssessed(object condition)
        {
            return !string.IsNullOrEmpty(Convert.ToString(condition));
        }

        protected string AssessmentBadge(object condition)
        {
            string c = Convert.ToString(condition);
            if (c == ReturnAssessment.Damaged) return "<span class=\"badge badge-danger\">Damaged</span>";
            if (c == ReturnAssessment.Good) return "<span class=\"badge badge-success\">Good</span>";
            return "";
        }

        protected string ResolveImage(object path)
        {
            return ReturnAssessment.ResolveImage(path);
        }

        private void ShowMessage(string message, System.Drawing.Color color)
        {
            lblMsg.ForeColor = color;
            lblMsg.Text = message;
        }
    }
}
