using System;
using System.Data;
using System.Data.SqlClient;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem
{
    public partial class SignUp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            if (password != confirmPassword)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Passwords do not match!";
                return;
            }

            // Check if username or email already exists
            SqlParameter[] checkParams = {
                new SqlParameter("@Username", username),
                new SqlParameter("@Email", email)
            };

            object countResult = DbHelper.ExecuteSPScalar("sp_CheckUsernameOrEmailExists", checkParams);
            int count = (countResult != null && countResult != DBNull.Value) ? Convert.ToInt32(countResult) : 0;

            if (count > 0)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Username or Email address is already taken.";
                return;
            }

            // Insert new user
            SqlParameter[] insertParams = {
                new SqlParameter("@FullName", fullName),
                new SqlParameter("@Username", username),
                new SqlParameter("@Email", email),
                new SqlParameter("@Password", password)
            };

            if (DbHelper.ExecuteSPNonQuery("sp_RegisterBorrower", insertParams) > 0)
            {
                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Registration successful! Redirecting to login...";
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
            else
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Error registering account. Please try again.";
            }
        }
    }
}