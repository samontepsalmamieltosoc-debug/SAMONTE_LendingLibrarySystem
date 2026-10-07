<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-layout { display: grid; grid-template-columns: 300px 1fr; gap: 22px; align-items: start; max-width: 980px; }
        .profile-layout > .card { margin-bottom: 0; }
        .id-card { text-align: center; position: relative; overflow: hidden; padding-top: 0; }
        .id-banner { height: 92px; margin: 0 -24px; background: linear-gradient(120deg, #0f766e, #0d9488 50%, #0284c7); position: relative; overflow: hidden; }
        .id-banner::before { content: ""; position: absolute; width: 160px; height: 160px; border-radius: 50%; right: -40px; top: -70px; background: rgba(255,255,255,.14); }
        .big-avatar {
            width: 92px; height: 92px; border-radius: 50%; margin: -46px auto 12px; position: relative; display: grid; place-items: center;
            font-size: 36px; font-weight: 800; color: #fff; background: linear-gradient(135deg, #f59e0b, #ef4444);
            border: 5px solid var(--surface); box-shadow: 0 10px 24px rgba(239,68,68,.35);
        }
        .id-card h3 { margin: 0; font-size: 20px; }
        .id-card .mail { color: var(--muted); font-size: 13.5px; margin-top: 4px; word-break: break-all; }
        .id-meta { margin-top: 18px; display: grid; gap: 10px; text-align: left; }
        .id-meta div { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 12px; background: var(--surface-2); font-size: 13.5px; color: var(--muted); }
        .id-meta b { color: var(--text); margin-left: auto; }

        .hint { display: block; margin-top: 6px; font-size: 12px; color: var(--muted); transition: color .2s; }
        .hint.ok { color: var(--success); }
        .hint.bad { color: var(--danger); }
        .pw-wrap { position: relative; }
        .pw-wrap .form-control { padding-right: 70px; }
        .pw-toggle { position: absolute; right: 8px; top: 50%; transform: translateY(-50%); border: 0; background: var(--primary-soft); color: var(--primary); font: inherit; font-size: 12px; font-weight: 700; padding: 5px 10px; border-radius: 8px; cursor: pointer; }
        .save-btn { padding: 12px 22px; }

        @media (max-width: 860px) { .profile-layout { grid-template-columns: 1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Account Profile</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true"></asp:Label>

    <div class="profile-layout">
        <div class="card id-card">
            <div class="id-banner"></div>
            <div class="big-avatar" id="bigAvatar">U</div>
            <h3 id="idName">Borrower</h3>
            <div class="mail" id="idMail"></div>
            <div class="id-meta">
                <div>Account type <b>Borrower</b></div>
                <div>Contact <b id="idPhone">-</b></div>
            </div>
        </div>

        <div class="card">
            <div class="card-head">
                <div>
                    <h3>Update Profile Information</h3>
                    <p class="card-sub">Keep your details current so the library can reach you.</p>
                </div>
            </div>

            <div class="form-group">
                <label>Full Name:</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Email Address:</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" Enabled="true"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Contact Number:</label>
                <asp:TextBox ID="txtContactNo" runat="server" CssClass="form-control"
                    MaxLength="11"
                    onkeypress="return event.charCode >= 48 && event.charCode <= 57"
                    Placeholder="09123456789"></asp:TextBox>
                <small class="hint" id="phoneHint">Must be 11 digits starting with 09 (e.g., 09123456789)</small>
            </div>

            <div class="form-group">
                <label>New Password (leave blank to keep current):</label>
                <div class="pw-wrap">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    <button type="button" class="pw-toggle" id="pwToggle">Show</button>
                </div>
            </div>

            <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" OnClick="btnUpdate_Click" CssClass="btn save-btn" />
        </div>
    </div>

    <script>
    (function () {
        var $ = function (id) { return document.querySelector('[id$="' + id + '"]'); };
        var name = $('txtFullName'), mail = $('txtEmail'), phone = $('txtContactNo'), pw = $('txtPassword');

        function paintIdentity() {
            var n = name.value.trim() || 'Borrower';
            document.getElementById('idName').textContent = n;
            document.getElementById('bigAvatar').textContent = n.split(/\s+/).slice(0, 2).map(function (w) { return w.charAt(0).toUpperCase(); }).join('');
            document.getElementById('idMail').textContent = mail.value.trim();
            document.getElementById('idPhone').textContent = phone.value.trim() || '-';
        }
        function checkPhone() {
            var h = document.getElementById('phoneHint'), v = phone.value;
            h.className = 'hint';
            if (!v) return;
            if (/^09\d{9}$/.test(v)) { h.classList.add('ok'); h.textContent = 'Looks good.'; }
            else { h.classList.add('bad'); h.textContent = 'Must be 11 digits starting with 09 (' + v.length + '/11 so far).'; }
        }
        [name, mail, phone].forEach(function (el) { el.addEventListener('input', paintIdentity); });
        phone.addEventListener('input', checkPhone);
        paintIdentity(); checkPhone();

        document.getElementById('pwToggle').addEventListener('click', function () {
            var show = pw.type === 'password'; pw.type = show ? 'text' : 'password'; this.textContent = show ? 'Hide' : 'Show';
        });
    })();
    </script>
</asp:Content>
