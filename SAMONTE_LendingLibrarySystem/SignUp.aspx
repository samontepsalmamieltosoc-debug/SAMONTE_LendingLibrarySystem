<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.SignUp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Account - Lending Library System</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f1f5f9; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .signup-card { background: #ffffff; padding: 35px 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); width: 100%; max-width: 400px; text-align: center; }
        .signup-card h2 { margin-bottom: 20px; color: #1e293b; }
        .form-group { margin-bottom: 15px; text-align: left; }
        .form-group label { display: block; font-weight: 600; margin-bottom: 5px; color: #475569; font-size: 14px; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; font-size: 14px; }
        .btn-register { width: 100%; background-color: #16a34a; color: white; border: none; padding: 12px; font-size: 16px; font-weight: bold; border-radius: 6px; cursor: pointer; transition: background-color 0.2s; margin-top: 10px; }
        .btn-register:hover { background-color: #15803d; }
        .login-link { margin-top: 15px; display: block; color: #2563eb; text-decoration: none; font-size: 14px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="signup-card">
            <h2>Create Account</h2>

            <asp:Label ID="lblMsg" runat="server" Font-Bold="true" Style="display:block; margin-bottom:15px;"></asp:Label>

            <div class="form-group">
                <label>Full Name:</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Username:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Email Address:</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" Required="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" Required="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Confirm Password:</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" Required="true"></asp:TextBox>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" CssClass="btn-register" />

            <a href="Login.aspx" class="login-link">Already have an account? Sign In</a>
        </div>
    </form>
</body>
</html>