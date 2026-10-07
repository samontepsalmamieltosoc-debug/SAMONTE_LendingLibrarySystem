<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .summary { display: flex; gap: 12px; flex-wrap: wrap; margin: 10px 0 6px; }
        .stat { display: flex; align-items: center; gap: 10px; padding: 10px 16px; border-radius: 14px; background: var(--surface-2); border: 1px solid var(--line); }
        .stat b { font-size: 20px; font-variant-numeric: tabular-nums; }
        .stat span { color: var(--muted); font-size: 12.5px; font-weight: 600; text-transform: uppercase; letter-spacing: .06em; }
        .person { display: flex; align-items: center; gap: 12px; }
        .person i {
            width: 34px; height: 34px; border-radius: 50%; display: grid; place-items: center; flex: none;
            font-style: normal; font-weight: 700; font-size: 13px; color: #fff;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>User Account Management</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true"></asp:Label>

    <div class="card">
        <div class="card-head">
            <div>
                <h3>Registered Borrowers</h3>
                <p class="card-sub">Deactivate an account to block sign-in; reactivate any time.</p>
            </div>
        </div>
        <div class="summary" id="userSummary"></div>
        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CssClass="table"
            DataKeyNames="BorrowerID" OnRowCommand="gvUsers_RowCommand" EmptyDataText="No registered users found.">
            <Columns>
                <asp:BoundField DataField="BorrowerID" HeaderText="ID" />
                <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                <asp:BoundField DataField="Email" HeaderText="Email / Username" />
                <asp:BoundField DataField="ContactNo" HeaderText="Contact No" />
                <asp:BoundField DataField="AccountStatus" HeaderText="Status" />

                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnToggle" runat="server"
                            CommandName="ToggleStatus"
                            CommandArgument='<%# Container.DataItemIndex %>'
                            Text='<%# Eval("AccountStatus").ToString() == "Active" ? "Deactivate" : "Activate" %>'
                            CssClass='<%# (Eval("AccountStatus").ToString() == "Active" ? "btn-action-deactivate" : "btn-action-activate") + " btn-sm" %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <script>
    (function () {
        var tbl = document.querySelector('[id$="gvUsers"]');
        if (!tbl) return;
        var ths = Array.prototype.slice.call(tbl.querySelectorAll('th')).map(function (t) { return t.textContent.trim(); });
        var iName = ths.indexOf('Full Name'), iStatus = ths.indexOf('Status');
        var palette = ['#6366f1', '#0ea5e9', '#10b981', '#f59e0b', '#ec4899', '#8b5cf6', '#14b8a6', '#ef4444'];
        var active = 0, inactive = 0;

        Array.prototype.slice.call(tbl.querySelectorAll('tr')).forEach(function (r) {
            if (!r.querySelector('td')) return;
            if (iStatus > -1) { if (r.children[iStatus].textContent.trim() === 'Active') active++; else inactive++; }
            if (iName < 0) return;
            var td = r.children[iName], name = td.textContent.trim(), sum = 0;
            for (var i = 0; i < name.length; i++) sum += name.charCodeAt(i);
            var initials = name.split(/\s+/).slice(0, 2).map(function (w) { return w.charAt(0).toUpperCase(); }).join('');
            td.innerHTML = '<div class="person"><i style="background:' + palette[sum % palette.length] + '"></i><span></span></div>';
            td.querySelector('i').textContent = initials;
            td.querySelector('span').textContent = name;
        });

        var rows = active + inactive;
        if (rows) document.getElementById('userSummary').innerHTML =
            '<div class="stat"><b>' + rows + '</b><span>Total</span></div>' +
            '<div class="stat"><b style="color:var(--success)">' + active + '</b><span>Active</span></div>' +
            '<div class="stat"><b style="color:var(--danger)">' + inactive + '</b><span>Inactive</span></div>';
    })();
    </script>
</asp:Content>
