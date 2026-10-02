<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Login - Community Lending Library System</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f1f5f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 35px 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 100%; max-width: 380px; }
        .login-card h2 { margin-top: 0; color: #1e293b; text-align: center; margin-bottom: 25px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #475569; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
        .btn-login { width: 100%; padding: 10px; background-color: #2563eb; color: white; border: none; border-radius: 4px; font-size: 16px; font-weight: 600; cursor: pointer; margin-top: 10px; }
        .btn-login:hover { background-color: #1d4ed8; }
        .error-msg { color: #dc2626; font-size: 14px; margin-top: 12px; text-align: center; display: block; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">
            <h2>Lending Library Login</h2>
            
            <div class="form-group">
                <label>Username:</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" Required="true"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <asp:Label ID="lblError" runat="server" CssClass="error-msg"></asp:Label>

            <a href="SignUp.aspx" style="display:block; text-align:center; margin-top:16px; color:#2563eb; text-decoration:none; font-size:14px;">
    Don't have an account? Sign Up
</a>
        </div>
    </form>
</body>
</html>