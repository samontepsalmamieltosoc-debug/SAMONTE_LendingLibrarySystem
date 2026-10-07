<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.SignUp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Create Account - Lending Library System</title>
    <style>
        :root {
            --bg: #f3f4fb; --surface: #ffffff; --surface-2: #f6f7fd; --text: #1e1b4b; --muted: #6b7194; --line: #e3e6f5;
            --primary: #4f46e5; --primary-2: #7c3aed; --danger: #dc2626; --success: #059669; --warn: #d97706;
        }
        @media (prefers-color-scheme: dark) {
            :root { --bg: #0b0d1c; --surface: #141733; --surface-2: #1b1f42; --text: #e8eaff; --muted: #9aa0cf; --line: #272c58; --primary: #818cf8; --primary-2: #a78bfa; --danger: #f87171; --success: #34d399; --warn: #fbbf24; }
        }
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: 'Segoe UI Variable', 'Segoe UI', system-ui, -apple-system, Roboto, sans-serif; background: var(--bg); color: var(--text); -webkit-font-smoothing: antialiased; }
        .shell { display: grid; grid-template-columns: 1fr 1.05fr; min-height: 100vh; }

        .brand-panel {
            position: relative; overflow: hidden; color: #fff; display: flex; flex-direction: column; justify-content: center; padding: 60px;
            background: linear-gradient(135deg, #be185d -20%, #6d28d9 45%, #3730a3 100%); background-size: 160% 160%; animation: shift 14s ease-in-out infinite;
        }
        @keyframes shift { 50% { background-position: 100% 100%; } }
        .blob { position: absolute; border-radius: 50%; background: rgba(255,255,255,.1); animation: drift 11s ease-in-out infinite; }
        .b1 { width: 360px; height: 360px; left: -120px; top: -110px; }
        .b2 { width: 200px; height: 200px; right: -60px; bottom: 100px; animation-duration: 15s; animation-direction: reverse; background: rgba(255,255,255,.07); }
        @keyframes drift { 50% { transform: translate(22px, 18px) scale(1.07); } }
        .ico { width: 24px; height: 24px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; flex: none; }
        .logo { width: 62px; height: 62px; border-radius: 19px; display: grid; place-items: center; background: rgba(255,255,255,.2); border: 1px solid rgba(255,255,255,.35); margin-bottom: 26px; animation: bob 5s ease-in-out infinite; position: relative; z-index: 1; }
        .logo .ico { width: 32px; height: 32px; }
        @keyframes bob { 50% { transform: translateY(-5px) rotate(-5deg); } }
        .brand-panel h1 { font-size: 38px; line-height: 1.1; margin: 0 0 14px; letter-spacing: -.02em; position: relative; z-index: 1; }
        .brand-panel p { font-size: 17px; opacity: .88; max-width: 430px; margin: 0 0 28px; line-height: 1.55; position: relative; z-index: 1; }
        .steps { display: grid; gap: 14px; position: relative; z-index: 1; max-width: 430px; counter-reset: s; }
        .step { display: flex; align-items: center; gap: 14px; padding: 13px 16px; border-radius: 16px; background: rgba(255,255,255,.12); border: 1px solid rgba(255,255,255,.2); font-weight: 600; font-size: 15px; animation: rise .6s ease both; }
        .step:nth-child(2) { animation-delay: .12s; } .step:nth-child(3) { animation-delay: .24s; }
        .step::before { counter-increment: s; content: counter(s); width: 30px; height: 30px; border-radius: 50%; display: grid; place-items: center; background: #fff; color: #6d28d9; font-weight: 800; flex: none; }
        @keyframes rise { from { opacity: 0; transform: translateY(14px); } }

        .form-panel { display: grid; place-items: center; padding: 40px 24px; }
        .signup-card { width: 100%; max-width: 430px; animation: rise .55s ease both; }
        .signup-card h2 { font-size: 30px; margin: 0 0 6px; letter-spacing: -.02em; }
        .signup-card .sub { color: var(--muted); margin: 0 0 24px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 7px; font-weight: 600; font-size: 12.5px; color: var(--muted); text-transform: uppercase; letter-spacing: .06em; }
        .field { position: relative; }
        .field > .ico { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); width: 18px; height: 18px; color: var(--muted); pointer-events: none; transition: color .2s; }
        .field:focus-within > .ico { color: var(--primary); }
        .form-control { width: 100%; padding: 12px 14px 12px 44px; border: 1.5px solid var(--line); border-radius: 14px; font: inherit; font-size: 15px; background: var(--surface); color: var(--text); transition: border-color .2s, box-shadow .2s; }
        .form-control:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px color-mix(in srgb, var(--primary) 22%, transparent); }
        .two { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

        .meter { display: flex; gap: 5px; margin-top: 8px; }
        .meter i { flex: 1; height: 5px; border-radius: 999px; background: var(--line); transition: background .25s; }
        .hint { display: block; margin-top: 6px; font-size: 12px; color: var(--muted); min-height: 16px; }
        .hint.ok { color: var(--success); } .hint.bad { color: var(--danger); }

        .btn-register {
            width: 100%; padding: 14px; margin-top: 8px; border: 0; border-radius: 14px; cursor: pointer; color: #fff; font: inherit; font-size: 16px; font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--primary-2)); box-shadow: 0 10px 24px color-mix(in srgb, var(--primary) 40%, transparent); transition: transform .15s, filter .2s;
        }
        .btn-register:hover { transform: translateY(-2px); filter: brightness(1.07); }

        span[id$="lblMsg"] { display: block; }
        span[id$="lblMsg"]:not(:empty) {
            margin-bottom: 18px; padding: 12px 16px; border-radius: 12px; font-size: 14px; font-weight: 700;
            background: color-mix(in srgb, currentColor 11%, var(--surface)); border: 1px solid color-mix(in srgb, currentColor 35%, transparent);
        }

        .alt { text-align: center; margin-top: 24px; color: var(--muted); font-size: 14px; }
        .alt a { color: var(--primary); font-weight: 700; text-decoration: none; }
        .alt a:hover { text-decoration: underline; }

        @media (max-width: 880px) {
            .shell { grid-template-columns: 1fr; }
            .brand-panel { padding: 34px 26px; } .brand-panel h1 { font-size: 30px; } .steps { display: none; } .brand-panel p { margin-bottom: 0; }
            .two { grid-template-columns: 1fr; }
        }
        @media (prefers-reduced-motion: reduce) { * { animation: none !important; transition: none !important; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="shell">
            <section class="brand-panel">
                <span class="blob b1"></span><span class="blob b2"></span>
                <div class="logo"><svg class="ico"><use href="#i-tool" /></svg></div>
                <h1>Join your neighborhood tool library.</h1>
                <p>Create a free borrower account in under a minute and start borrowing.</p>
                <div class="steps">
                    <div class="step">Create your account</div>
                    <div class="step">Browse and reserve a tool</div>
                    <div class="step">Pick it up, use it, return it</div>
                </div>
            </section>

            <section class="form-panel">
                <div class="signup-card">
                    <h2>Create Account</h2>
                    <p class="sub">It only takes a minute</p>

                    <asp:Label ID="lblMsg" runat="server" Font-Bold="true"></asp:Label>

                    <div class="form-group">
                        <label>Full Name:</label>
                        <div class="field"><svg class="ico"><use href="#i-user" /></svg>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" Required="true"></asp:TextBox></div>
                    </div>

                    <div class="two">
                        <div class="form-group">
                            <label>Username:</label>
                            <div class="field"><svg class="ico"><use href="#i-at" /></svg>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Required="true"></asp:TextBox></div>
                        </div>
                        <div class="form-group">
                            <label>Email Address:</label>
                            <div class="field"><svg class="ico"><use href="#i-mail" /></svg>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" Required="true"></asp:TextBox></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Password:</label>
                        <div class="field"><svg class="ico"><use href="#i-lock" /></svg>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" Required="true"></asp:TextBox></div>
                        <div class="meter" id="meter"><i></i><i></i><i></i><i></i></div>
                        <small class="hint" id="strengthHint"></small>
                    </div>

                    <div class="form-group">
                        <label>Confirm Password:</label>
                        <div class="field"><svg class="ico"><use href="#i-lock" /></svg>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" Required="true"></asp:TextBox></div>
                        <small class="hint" id="matchHint"></small>
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" CssClass="btn-register" />

                    <div class="alt">Already have an account? <a href="Login.aspx">Sign In</a></div>
                </div>
            </section>
        </div>

        <svg width="0" height="0" style="position:absolute" aria-hidden="true">
            <defs>
                <symbol id="i-tool" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></symbol>
                <symbol id="i-user" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></symbol>
                <symbol id="i-at" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-3.92 7.94"/></symbol>
                <symbol id="i-mail" viewBox="0 0 24 24"><path d="M4 4h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2z"/><path d="M22 6l-10 7L2 6"/></symbol>
                <symbol id="i-lock" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></symbol>
            </defs>
        </svg>
    </form>

    <script>
    (function () {
        var $ = function (id) { return document.querySelector('[id$="' + id + '"]'); };
        var pw = $('txtPassword'), cf = $('txtConfirmPassword');
        var bars = document.querySelectorAll('#meter i'), sh = document.getElementById('strengthHint'), mh = document.getElementById('matchHint');
        var COLORS = ['#ef4444', '#f59e0b', '#84cc16', '#10b981'], LABELS = ['Too weak', 'Could be stronger', 'Good', 'Strong'];

        function strength(v) {
            var s = 0;
            if (v.length >= 8) s++;
            if (/[a-z]/.test(v) && /[A-Z]/.test(v)) s++;
            if (/\d/.test(v)) s++;
            if (/[^A-Za-z0-9]/.test(v) || v.length >= 12) s++;
            return v ? Math.max(s, 1) : 0;
        }
        function paint() {
            var s = strength(pw.value);
            Array.prototype.forEach.call(bars, function (b, i) { b.style.background = i < s ? COLORS[s - 1] : ''; });
            sh.textContent = s ? LABELS[s - 1] : '';
            if (cf.value) {
                var ok = cf.value === pw.value;
                mh.className = 'hint ' + (ok ? 'ok' : 'bad'); mh.textContent = ok ? 'Passwords match.' : 'Passwords do not match yet.';
            } else { mh.className = 'hint'; mh.textContent = ''; }
        }
        pw.addEventListener('input', paint); cf.addEventListener('input', paint);
    })();
    </script>
</body>
</html>
