<%@ Page Title="My Borrow History" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MyHistory.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.MyHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .tiles { display: grid; grid-template-columns: repeat(auto-fit, minmax(190px, 1fr)); gap: 18px; margin-bottom: 22px; }
        .tile {
            --c: var(--primary); position: relative; overflow: hidden; padding: 18px 20px; border-radius: var(--radius);
            background: var(--surface); border: 1px solid var(--line); box-shadow: var(--shadow); transition: transform .25s, box-shadow .25s;
        }
        .tile:hover { transform: translateY(-4px); box-shadow: 0 14px 30px color-mix(in srgb, var(--c) 26%, transparent); }
        .tile::after { content: ""; position: absolute; right: -26px; bottom: -26px; width: 90px; height: 90px; border-radius: 50%; background: color-mix(in srgb, var(--c) 14%, transparent); }
        .tile .t-ico { width: 40px; height: 40px; border-radius: 13px; display: grid; place-items: center; color: #fff; margin-bottom: 12px; background: linear-gradient(135deg, var(--c), color-mix(in srgb, var(--c) 55%, #fff)); }
        .tile span { display: block; color: var(--muted); font-size: 12px; font-weight: 700; letter-spacing: .07em; text-transform: uppercase; }
        .tile b { font-size: 30px; font-weight: 800; letter-spacing: -.02em; position: relative; z-index: 1; }
        .tile.hot { animation: pulse 2.2s ease-in-out infinite; }
        @keyframes pulse { 50% { box-shadow: 0 0 0 6px color-mix(in srgb, var(--c) 18%, transparent), var(--shadow); } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Borrowing History & Active Reservations</h2>

    <div class="tiles" id="tiles"></div>

    <div class="card">
        <div class="card-head">
            <div>
                <h3>My Active & Past Borrows</h3>
                <p class="card-sub">Anything past its due date is flagged in red.</p>
            </div>
        </div>
        <asp:GridView ID="gvMyBorrows" runat="server" AutoGenerateColumns="false" CssClass="table"
            OnRowDataBound="gvMyBorrows_RowDataBound" EmptyDataText="No borrow history found.">
            <Columns>
                <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                <asp:BoundField DataField="BorrowDate" HeaderText="Borrow Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="ExpectedReturnDate" HeaderText="Expected Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="ActualReturnDate" HeaderText="Actual Return Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" NullDisplayText="Not Returned" />
                <asp:BoundField DataField="TransactionStatus" HeaderText="Transaction Status" />

                <asp:TemplateField HeaderText="Overdue / Loan Status">
                    <ItemTemplate>
                        <asp:Label ID="lblOverdueStatus" runat="server"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <div class="card">
        <div class="card-head"><h3>My Reservations</h3></div>
        <asp:GridView ID="gvMyReservations" runat="server" AutoGenerateColumns="true" CssClass="table" EmptyDataText="No active reservations."></asp:GridView>
    </div>

    <script>
    (function () {
        var tbl = document.querySelector('[id$="gvMyBorrows"]');
        var res = document.querySelector('[id$="gvMyReservations"]');
        function dataRows(t) { return t ? Array.prototype.slice.call(t.querySelectorAll('tr')).filter(function (r) { return r.children.length > 1 && r.querySelector('td'); }) : []; }

        var rows = dataRows(tbl), active = 0, overdue = 0, returned = 0;
        rows.forEach(function (r) {
            var last = r.children[r.children.length - 1].textContent;
            if (/overdue/i.test(last)) { overdue++; active++; }
            else if (/returned/i.test(last)) returned++;
            else active++;
        });
        var resCount = dataRows(res).length;

        function tile(label, n, color, icon, hot) {
            return '<div class="tile' + (hot ? ' hot' : '') + '" style="--c:' + color + '"><div class="t-ico"><svg class="ico"><use href="#' + icon + '"/></svg></div>' +
                   '<span>' + label + '</span><b class="count-up">' + n + '</b></div>';
        }
        document.getElementById('tiles').innerHTML =
            tile('Currently borrowed', active, '#0d9488', 'i-repeat', false) +
            tile('Overdue', overdue, '#dc2626', 'i-alert', overdue > 0) +
            tile('Returned', returned, '#059669', 'i-check', false) +
            tile('Reservations', resCount, '#0284c7', 'i-clock', false);
    })();
    </script>
</asp:Content>
