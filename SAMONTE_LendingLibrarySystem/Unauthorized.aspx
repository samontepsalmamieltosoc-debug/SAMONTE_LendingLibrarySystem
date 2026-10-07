<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Unauthorized.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Unauthorized" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Access Denied - Lending Library System</title>
    <style>
        :root { --bg: #f3f4fb; --surface: #ffffff; --text: #1e1b4b; --muted: #6b7194; --line: #e3e6f5; --primary: #4f46e5; --primary-2: #7c3aed; --danger: #dc2626; }
        @media (prefers-color-scheme: dark) {
            :root { --bg: #0b0d1c; --surface: #141733; --text: #e8eaff; --muted: #9aa0cf; --line: #272c58; --primary: #818cf8; --primary-2: #a78bfa; --danger: #f87171; }
        }
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh; display: grid; place-items: center; padding: 24px; overflow: hidden; position: relative;
            font-family: 'Segoe UI Variable', 'Segoe UI', system-ui, -apple-system, Roboto, sans-serif; background: var(--bg); color: var(--text);
        }
        body::before, body::after { content: ""; position: absolute; border-radius: 50%; filter: blur(60px); opacity: .5; animation: drift 12s ease-in-out infinite; }
        body::before { width: 380px; height: 380px; background: #f87171; left: -100px; top: -100px; }
        body::after { width: 340px; height: 340px; background: #818cf8; right: -90px; bottom: -90px; animation-direction: reverse; }
        @keyframes drift { 50% { transform: translate(30px, 24px) scale(1.1); } }
        .card {
            position: relative; z-index: 1; width: 100%; max-width: 460px; text-align: center; padding: 44px 38px; border-radius: 26px;
            background: var(--surface); border: 1px solid var(--line); box-shadow: 0 24px 60px rgba(30,27,75,.18); animation: pop .5s cubic-bezier(.2,1.3,.4,1) both;
        }
        @keyframes pop { from { opacity: 0; transform: scale(.92) translateY(14px); } }
        .shield { width: 84px; height: 84px; margin: 0 auto 20px; border-radius: 26px; display: grid; place-items: center; color: #fff; background: linear-gradient(135deg, #f87171, #dc2626); box-shadow: 0 14px 30px rgba(220,38,38,.38); animation: wobble 3.2s ease-in-out infinite; }
        @keyframes wobble { 0%, 100% { transform: rotate(0); } 10% { transform: rotate(-7deg); } 20% { transform: rotate(6deg); } 30% { transform: rotate(0); } }
        .shield svg { width: 42px; height: 42px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
        .code { font-size: 14px; font-weight: 800; letter-spacing: .2em; color: var(--danger); margin-bottom: 6px; }
        h1 { margin: 0 0 12px; font-size: 30px; letter-spacing: -.02em; }
        p { color: var(--muted); font-size: 16px; margin: 0 0 28px; line-height: 1.55; }
        .btn-link { display: inline-block; padding: 13px 26px; border-radius: 14px; color: #fff; text-decoration: none; font-weight: 700; background: linear-gradient(135deg, var(--primary), var(--primary-2)); box-shadow: 0 10px 24px color-mix(in srgb, var(--primary) 40%, transparent); transition: transform .15s, filter .2s; }
        .btn-link:hover { transform: translateY(-2px); filter: brightness(1.07); }
        @media (prefers-reduced-motion: reduce) { * { animation: none !important; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">
            <div class="shield"><svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M9.5 9.5l5 5M14.5 9.5l-5 5"/></svg></div>
            <div class="code">403</div>
            <h1>Access Denied</h1>
            <p>You do not have permission to access this page or resource. Please log in with an authorized account.</p>
            <a href="Login.aspx" class="btn-link">Return to Login</a>
        </div>
    </form>
</body>
</html>
