using System;
using System.Data;
using System.Data.SqlClient;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            SqlParameter[] parameters = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Password", password)
            };

            DataTable dt = DbHelper.ExecuteSPDataTable("sp_AuthenticateUser", parameters);

            if (dt != null && dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];

                Session["UserID"] = row["UserID"].ToString();
                Session["FullName"] = row["FullName"].ToString();
                Session["UserRole"] = row["Role"].ToString();

                string role = row["Role"].ToString();

                if (role == "Admin")
                {
                    Response.Redirect("~/Admin/AdminDashboard.aspx");
                }
                else if (role == "User")
                {
                    Response.Redirect("~/User/BrowseTools.aspx");
                }
                else
                {
                    lblError.Text = "Unrecognized user role.";
                }
            }
            else
            {
                lblError.Text = "Invalid username or password.";
            }
        }
    }
}