<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Unauthorized.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Unauthorized" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Access Denied - Lending Library System</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); text-align: center; max-width: 450px; }
        h1 { color: #ef4444; margin-top: 0; font-size: 32px; }
        p { color: #475569; font-size: 16px; margin-bottom: 25px; line-height: 1.5; }
        .btn-link { display: inline-block; padding: 10px 20px; background-color: #2563eb; color: white; text-decoration: none; border-radius: 4px; font-weight: 600; }
        .btn-link:hover { background-color: #1d4ed8; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">
            <h1>403 - Access Denied</h1>
            <p>You do not have permission to access this page or resource. Please log in with an authorized account.</p>
            <a href="Login.aspx" class="btn-link">Return to Login</a>
        </div>
    </form>
</body>
</html>