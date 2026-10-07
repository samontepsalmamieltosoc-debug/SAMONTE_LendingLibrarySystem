using System;
using System.Data;
using System.Data.SqlClient;
using SAMONTE_LendingLibrarySystem.Helpers;
using SAMONTE_LendingLibrarySystem.Modules;

namespace SAMONTE_LendingLibrarySystem.User
{
    public partial class RequestReservation : System.Web.UI.Page
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
                try
                {
                    DataRow tool = LoadAndBindTool();
                    if (tool != null) CheckEligibility(tool);
                }
                catch (Exception ex)
                {
                    ShowNotFound("Error loading tool: " + ex.Message);
                }
            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            try
            {
                // Re-validate from scratch: stock, condition or an earlier request may have changed since the page loaded
                DataRow tool = LoadAndBindTool();
                if (tool == null || !CheckEligibility(tool)) return;

                int toolId = Convert.ToInt32(tool["ToolID"]);
                if (!QueueManager.JoinWaitlistQueue(toolId, BorrowerId))
                {
                    ShowMessage("We couldn't submit your reservation. Please try again.", false);
                    return;
                }

                pnlRequest.Visible = false;
                pnlDone.Visible = true;
                litDone.Text = "Your request for " + Convert.ToString(tool["ToolName"]) +
                               " is now waiting for administrator approval. You can follow its status under My Borrow History.";
            }
            catch (Exception ex)
            {
                ShowMessage("Failed to submit reservation: " + ex.Message, false);
            }
        }

        private int BorrowerId
        {
            get { return Convert.ToInt32(Session["UserID"]); }
        }

        private int RequestedToolId
        {
            get
            {
                int id;
                return int.TryParse(Request.QueryString["ToolID"], out id) ? id : 0;
            }
        }

        private DataRow GetTool(int toolId)
        {
            string sql = @"
                SELECT t.ToolID, t.ToolName,
                       ISNULL(c.CategoryName, '') AS CategoryName,
                       ISNULL(t.ConditionStatus, '') AS ConditionStatus,
                       ISNULL(t.AvailableQty, 0) AS AvailableQty
                FROM Tools t
                LEFT JOIN Categories c ON t.CategoryID = c.CategoryID
                WHERE t.ToolID = @ToolID";

            DataTable dt = DbHelper.ExecuteQuery(sql, new SqlParameter[] { new SqlParameter("@ToolID", toolId) });
            return dt.Rows.Count > 0 ? dt.Rows[0] : null;
        }

        /// <summary>Loads the requested tool into the page. Returns null (and shows the not-found state) if it doesn't exist.</summary>
        private DataRow LoadAndBindTool()
        {
            DataRow tool = GetTool(RequestedToolId);
            if (tool == null)
            {
                ShowNotFound("That tool could not be found. Please pick one from the catalog.");
                return null;
            }

            string name = Convert.ToString(tool["ToolName"]);
            string category = Convert.ToString(tool["CategoryName"]);
            string condition = Convert.ToString(tool["ConditionStatus"]);

            litInitial.Text = name.Length > 0 ? name.Substring(0, 1).ToUpper() : "?";
            litToolName.Text = name;
            litCategory.Text = category.Length > 0 ? category : "Uncategorized";
            litStock.Text = Convert.ToString(tool["AvailableQty"]);
            litRequester.Text = Convert.ToString(Session["FullName"]);

            lblCondition.Text = condition.Length > 0 ? condition : "Unknown";
            lblCondition.CssClass = condition == "Good" ? "badge badge-success" : "badge badge-danger";

            // Same hue the catalog derives from the category name, so the tile matches the card the user clicked
            toolHead.Attributes["style"] = "--h:" + CategoryHue(category) + ";";

            return tool;
        }

        /// <summary>Shows why the tool can't be reserved (and hides the confirm button). Returns true if the user may proceed.</summary>
        private bool CheckEligibility(DataRow tool)
        {
            string reason = GetBlockReason(tool);
            if (reason == null) return true;

            btnConfirm.Visible = false;
            ShowMessage(reason, false);
            return false;
        }

        private string GetBlockReason(DataRow tool)
        {
            string name = Convert.ToString(tool["ToolName"]);
            string condition = Convert.ToString(tool["ConditionStatus"]);
            int toolId = Convert.ToInt32(tool["ToolID"]);

            // Same rule the catalog uses to enable the Reserve button
            if (condition != "Good")
                return "This tool is currently marked as " + (condition.Length > 0 ? condition : "unavailable") + " and can't be reserved.";
            if (Convert.ToInt32(tool["AvailableQty"]) <= 0)
                return "This tool is out of stock right now. Please check back later.";

            // Reservations.BorrowerID is a foreign key to Borrowers, so make sure this account has a borrower record
            DataTable borrower = DbHelper.ExecuteQuery(
                "SELECT AccountStatus FROM Borrowers WHERE BorrowerID = @BorrowerID",
                new SqlParameter[] { new SqlParameter("@BorrowerID", BorrowerId) });

            if (borrower.Rows.Count == 0)
                return "Your account isn't registered as a borrower yet, so it can't make reservations. Please contact an administrator.";
            if (string.Equals(Convert.ToString(borrower.Rows[0]["AccountStatus"]), "Inactive", StringComparison.OrdinalIgnoreCase))
                return "Your account is inactive, so it can't make reservations. Please contact an administrator.";

            object open = DbHelper.ExecuteScalar(
                @"SELECT COUNT(*) FROM Reservations
                  WHERE ToolID = @ToolID AND BorrowerID = @BorrowerID AND ReservationStatus IN ('Pending', 'Notified')",
                new SqlParameter[] { new SqlParameter("@ToolID", toolId), new SqlParameter("@BorrowerID", BorrowerId) });

            if (Convert.ToInt32(open) > 0)
                return "You already have an open reservation for " + name + ". You can check its status under My Borrow History.";

            return null;
        }

        private static int CategoryHue(string category)
        {
            int hue = 0;
            foreach (char ch in category) hue = (hue * 31 + ch) % 360;
            return hue;
        }

        private void ShowNotFound(string message)
        {
            pnlRequest.Visible = false;
            pnlNotFound.Visible = true;
            ShowMessage(message, false);
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMsg.Text = message;
            lblMsg.Visible = true;
            lblMsg.CssClass = isSuccess ? "msg-success" : "msg-error";
        }
    }
}
