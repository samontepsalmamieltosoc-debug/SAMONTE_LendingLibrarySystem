using System;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using SAMONTE_LendingLibrarySystem.Helpers;

namespace SAMONTE_LendingLibrarySystem.User
{
    public partial class Profile : System.Web.UI.Page
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
                LoadUserData();
            }
        }

        private void LoadUserData()
        {
            int borrowerId = Convert.ToInt32(Session["UserID"]);
            SqlParameter[] p = { new SqlParameter("@BorrowerID", borrowerId) };
            DataTable dt = DbHelper.ExecuteSPDataTable("sp_GetUserProfile", p);

            if (dt.Rows.Count > 0)
            {
                txtFullName.Text = dt.Rows[0]["FullName"].ToString();
                txtEmail.Text = dt.Rows[0]["Email"].ToString();
                txtContactNo.Text = dt.Rows[0]["ContactNo"].ToString();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int borrowerId = Convert.ToInt32(Session["UserID"]);
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string contactNo = txtContactNo.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email))
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Full Name and Email Address cannot be empty.";
                return;
            }

            if (!string.IsNullOrEmpty(contactNo))
            {
                if (contactNo.Length != 11 || !contactNo.StartsWith("09") || !Regex.IsMatch(contactNo, @"^\d{11}$"))
                {
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                    lblMsg.Text = "Contact number must be exactly 11 digits starting with '09' (e.g., 09123456789).";
                    return;
                }
            }

            SqlParameter[] p = {
                new SqlParameter("@BorrowerID", borrowerId),
                new SqlParameter("@FullName", fullName),
                new SqlParameter("@Email", email),
                new SqlParameter("@Contact", contactNo),
                new SqlParameter("@Password", string.IsNullOrEmpty(password) ? (object)DBNull.Value : password)
            };

            if (DbHelper.ExecuteSPNonQuery("sp_UpdateUserProfile", p) > 0)
            {
                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Profile updated successfully!";
                txtPassword.Text = "";
            }
            else
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Error updating profile.";
            }
        }
    }
}