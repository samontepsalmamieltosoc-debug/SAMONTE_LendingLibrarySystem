<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Login - Community Lending Library System</title>
    <style>
        :root {
            --bg: #f3f4fb; --surface: #ffffff; --surface-2: #f6f7fd; --text: #1e1b4b; --muted: #6b7194; --line: #e3e6f5;
            --primary: #4f46e5; --primary-2: #7c3aed; --danger: #dc2626;
        }
        @media (prefers-color-scheme: dark) {
            :root { --bg: #0b0d1c; --surface: #141733; --surface-2: #1b1f42; --text: #e8eaff; --muted: #9aa0cf; --line: #272c58; --primary: #818cf8; --primary-2: #a78bfa; --danger: #f87171; }
        }
        * { box-sizing: border-box; }
        body { margin: 0; min-height: 100vh; font-family: 'Segoe UI Variable', 'Segoe UI', system-ui, -apple-system, Roboto, sans-serif; background: var(--bg); color: var(--text); -webkit-font-smoothing: antialiased; }
        .shell { display: grid; grid-template-columns: 1.05fr 1fr; min-height: 100vh; }

        /* Brand panel */
        .brand-panel {
            position: relative; overflow: hidden; color: #fff; display: flex; flex-direction: column; justify-content: center; padding: 60px;
            background: linear-gradient(135deg, #3730a3 0%, #6d28d9 55%, #be185d 120%); background-size: 160% 160%; animation: shift 14s ease-in-out infinite;
        }
        @keyframes shift { 50% { background-position: 100% 100%; } }
        .blob { position: absolute; border-radius: 50%; background: rgba(255,255,255,.1); animation: drift 11s ease-in-out infinite; }
        .b1 { width: 380px; height: 380px; right: -120px; top: -120px; }
        .b2 { width: 220px; height: 220px; left: -70px; bottom: 90px; animation-duration: 15s; animation-direction: reverse; background: rgba(255,255,255,.07); }
        .b3 { width: 120px; height: 120px; right: 90px; bottom: -40px; animation-duration: 9s; }
        @keyframes drift { 50% { transform: translate(-22px, 18px) scale(1.07); } }
        .logo { width: 62px; height: 62px; border-radius: 19px; display: grid; place-items: center; background: rgba(255,255,255,.2); border: 1px solid rgba(255,255,255,.35); backdrop-filter: blur(6px); margin-bottom: 26px; animation: bob 5s ease-in-out infinite; position: relative; z-index: 1; }
        @keyframes bob { 50% { transform: translateY(-5px) rotate(-5deg); } }
        .ico { width: 24px; height: 24px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; flex: none; }
        .logo .ico { width: 32px; height: 32px; }
        .brand-panel h1 { font-size: 40px; line-height: 1.1; margin: 0 0 14px; letter-spacing: -.02em; position: relative; z-index: 1; }
        .brand-panel p { font-size: 17px; opacity: .88; max-width: 440px; margin: 0 0 32px; line-height: 1.55; position: relative; z-index: 1; }
        .perks { display: grid; gap: 14px; position: relative; z-index: 1; }
        .perk { display: flex; align-items: center; gap: 14px; padding: 13px 16px; border-radius: 16px; max-width: 440px; background: rgba(255,255,255,.12); border: 1px solid rgba(255,255,255,.2); backdrop-filter: blur(6px); font-weight: 600; font-size: 15px; animation: rise .6s ease both; }
        .perk:nth-child(2) { animation-delay: .12s; } .perk:nth-child(3) { animation-delay: .24s; }
        .perk .ico { width: 22px; height: 22px; }
        @keyframes rise { from { opacity: 0; transform: translateY(14px); } }

        /* Form panel */
        .form-panel { display: grid; place-items: center; padding: 40px 24px; }
        .login-card { width: 100%; max-width: 410px; animation: rise .55s ease both; }
        .login-card h2 { font-size: 30px; margin: 0 0 6px; letter-spacing: -.02em; }
        .login-card .sub { color: var(--muted); margin: 0 0 28px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 7px; font-weight: 600; font-size: 12.5px; color: var(--muted); text-transform: uppercase; letter-spacing: .06em; }
        .field { position: relative; }
        .field > .ico { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); width: 18px; height: 18px; color: var(--muted); pointer-events: none; transition: color .2s; }
        .field:focus-within > .ico { color: var(--primary); }
        .form-control { width: 100%; padding: 13px 14px 13px 44px; border: 1.5px solid var(--line); border-radius: 14px; font: inherit; font-size: 15px; background: var(--surface); color: var(--text); transition: border-color .2s, box-shadow .2s; }
        .form-control:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 4px color-mix(in srgb, var(--primary) 22%, transparent); }
        .field .toggle { position: absolute; right: 8px; top: 50%; transform: translateY(-50%); border: 0; background: color-mix(in srgb, var(--primary) 12%, transparent); color: var(--primary); font: inherit; font-size: 12px; font-weight: 700; padding: 6px 11px; border-radius: 9px; cursor: pointer; }
        .field.has-toggle .form-control { padding-right: 76px; }
        .caps { display: none; margin-top: 7px; font-size: 12.5px; font-weight: 600; color: #d97706; }
        .caps.on { display: block; }

        .btn-login {
            width: 100%; padding: 14px; margin-top: 6px; border: 0; border-radius: 14px; cursor: pointer; color: #fff; font: inherit; font-size: 16px; font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--primary-2)); box-shadow: 0 10px 24px color-mix(in srgb, var(--primary) 40%, transparent);
            transition: transform .15s, filter .2s;
        }
        .btn-login:hover { transform: translateY(-2px); filter: brightness(1.07); }
        .btn-login:active { transform: translateY(0); }
        .btn-login.loading { opacity: .75; cursor: progress; background-image: linear-gradient(110deg, var(--primary) 30%, var(--primary-2) 50%, var(--primary) 70%); background-size: 200% 100%; animation: sheen 1s linear infinite; }
        @keyframes sheen { to { background-position: -200% 0; } }

        .error-msg { display: block; }
        .error-msg:not(:empty) {
            margin-top: 16px; padding: 12px 16px; border-radius: 12px; font-size: 14px; font-weight: 600; color: var(--danger);
            background: color-mix(in srgb, var(--danger) 11%, var(--surface)); border: 1px solid color-mix(in srgb, var(--danger) 35%, transparent);
            animation: shake .45s ease both;
        }
        @keyframes shake { 20%, 60% { transform: translateX(-6px); } 40%, 80% { transform: translateX(6px); } }

        .alt { text-align: center; margin-top: 26px; color: var(--muted); font-size: 14px; }
        .alt a { color: var(--primary); font-weight: 700; text-decoration: none; }
        .alt a:hover { text-decoration: underline; }

        @media (max-width: 880px) {
            .shell { grid-template-columns: 1fr; }
            .brand-panel { padding: 34px 26px; }
            .brand-panel h1 { font-size: 30px; } .perks { display: none; } .brand-panel p { margin-bottom: 0; }
        }
        @media (prefers-reduced-motion: reduce) { * { animation: none !important; transition: none !important; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="shell">
            <section class="brand-panel">
                <span class="blob b1"></span><span class="blob b2"></span><span class="blob b3"></span>
                <div class="logo"><svg class="ico"><use href="#i-tool" /></svg></div>
                <h1>Borrow more.<br />Buy less.</h1>
                <p>Your community's shared tool shelf. Reserve what you need, return it when you're done, and keep it moving for the next neighbor.</p>
                <div class="perks">
                    <div class="perk"><svg class="ico"><use href="#i-box" /></svg>Browse a catalog of tools ready to borrow</div>
                    <div class="perk"><svg class="ico"><use href="#i-clock" /></svg>Track due dates and your borrowing history</div>
                    <div class="perk"><svg class="ico"><use href="#i-shield" /></svg>Fair, transparent fines. No surprises</div>
                </div>
            </section>

            <section class="form-panel">
                <div class="login-card">
                    <h2>Welcome back</h2>
                    <p class="sub">Sign in to the Lending Library</p>

                    <div class="form-group">
                        <label>Username:</label>
                        <div class="field">
                            <svg class="ico"><use href="#i-user" /></svg>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Required="true" autocomplete="username"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Password:</label>
                        <div class="field has-toggle">
                            <svg class="ico"><use href="#i-lock" /></svg>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" Required="true" autocomplete="current-password"></asp:TextBox>
                            <button type="button" class="toggle" id="pwToggle">Show</button>
                        </div>
                        <div class="caps" id="capsWarn">Caps Lock is on</div>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-login" OnClick="btnLogin_Click" />

                    <asp:Label ID="lblError" runat="server" CssClass="error-msg"></asp:Label>

                    <div class="alt">Don't have an account? <a href="SignUp.aspx">Sign Up</a></div>
                </div>
            </section>
        </div>

        <svg width="0" height="0" style="position:absolute" aria-hidden="true">
            <defs>
                <symbol id="i-tool" viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></symbol>
                <symbol id="i-box" viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><path d="M3.27 6.96 12 12.01l8.73-5.05M12 22.08V12"/></symbol>
                <symbol id="i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></symbol>
                <symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M9 12l2 2 4-4"/></symbol>
                <symbol id="i-user" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></symbol>
                <symbol id="i-lock" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></symbol>
            </defs>
        </svg>
    </form>

    <script>
    (function () {
        var $ = function (id) { return document.querySelector('[id$="' + id + '"]'); };
        var pw = $('txtPassword'), user = $('txtUsername'), btn = $('btnLogin');

        document.getElementById('pwToggle').addEventListener('click', function () {
            var show = pw.type === 'password'; pw.type = show ? 'text' : 'password'; this.textContent = show ? 'Hide' : 'Show';
        });

        var caps = document.getElementById('capsWarn');
        pw.addEventListener('keyup', function (e) { caps.classList.toggle('on', !!(e.getModifierState && e.getModifierState('CapsLock'))); });
        pw.addEventListener('blur', function () { caps.classList.remove('on'); });

        /* Visual feedback only: the button stays enabled so the server-side click event still fires. */
        document.getElementById('form1').addEventListener('submit', function () {
            if (user.value && pw.value) btn.classList.add('loading');
        });

        user.focus();
    })();
    </script>
</body>
</html>
