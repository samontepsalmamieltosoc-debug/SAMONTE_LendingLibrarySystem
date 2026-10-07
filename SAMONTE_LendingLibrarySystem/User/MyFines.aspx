<%@ Page Title="My Fines & Penalties" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MyFines.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.MyFines" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .balance {
            position: relative; overflow: hidden; display: flex; align-items: center; gap: 22px; flex-wrap: wrap;
            border-radius: 22px; padding: 26px 30px; margin-bottom: 22px; color: #fff;
            background: linear-gradient(120deg, #be123c, #ef4444 60%, #f59e0b 130%); box-shadow: 0 18px 40px rgba(239,68,68,.3);
            transition: background .4s;
        }
        .balance.clear { background: linear-gradient(120deg, #047857, #10b981 60%, #2dd4bf 130%); box-shadow: 0 18px 40px rgba(16,185,129,.3); }
        .balance::before { content: ""; position: absolute; width: 260px; height: 260px; border-radius: 50%; right: -70px; top: -100px; background: rgba(255,255,255,.12); }
        .balance-ico { width: 62px; height: 62px; border-radius: 18px; display: grid; place-items: center; background: rgba(255,255,255,.2); border: 1px solid rgba(255,255,255,.3); position: relative; z-index: 1; }
        .balance-ico .ico { width: 30px; height: 30px; }
        .balance h4 { font-size: 12.5px; text-transform: uppercase; letter-spacing: .1em; opacity: .9; font-weight: 700; position: relative; z-index: 1; }
        .balance .amount { display: block; font-size: 40px; font-weight: 800; letter-spacing: -.02em; position: relative; z-index: 1; font-variant-numeric: tabular-nums; }
        .balance small { opacity: .9; position: relative; z-index: 1; }
        .status-unpaid { color: var(--danger); background: var(--danger-soft); }
        .status-paid { color: var(--success); background: var(--success-soft); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Fines & Penalties</h2>

    <!-- Outstanding Balance Summary Card -->
    <div class="balance" id="balanceCard">
        <div class="balance-ico"><svg class="ico"><use href="#i-wallet" /></svg></div>
        <div>
            <h4>Outstanding Unpaid Balance</h4>
            <asp:Label ID="lblTotalUnpaid" runat="server" CssClass="amount count-up">₱0.00</asp:Label>
            <small id="balanceHint"></small>
        </div>
    </div>

    <!-- Fines History Table -->
    <div class="card">
        <div class="card-head">
            <div>
                <h3>Fine History</h3>
                <p class="card-sub">Fines are assessed when a returned tool is found damaged.</p>
            </div>
        </div>
        <asp:GridView ID="gvUserFines" runat="server" AutoGenerateColumns="false" CssClass="table"
            EmptyDataText="You have no fine records.">
            <Columns>
                <asp:BoundField DataField="FineID" HeaderText="Fine ID" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                <asp:BoundField DataField="DamageNotes" HeaderText="Damage Details / Reason" />
                <asp:BoundField DataField="FineAmount" HeaderText="Amount" DataFormatString="₱{0:N2}" />
                <asp:BoundField DataField="CreatedDate" HeaderText="Date Assessed" DataFormatString="{0:yyyy-MM-dd}" />

                <asp:TemplateField HeaderText="Payment Status">
                    <ItemTemplate>
                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("PaymentStatus") %>'
                            CssClass='<%# "badge " + (Eval("PaymentStatus").ToString() == "Unpaid" ? "status-unpaid" : "status-paid") %>'>
                        </asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" NullDisplayText="Pending Payment" />
            </Columns>
        </asp:GridView>
    </div>

    <script>
    (function () {
        var el = document.querySelector('[id$="lblTotalUnpaid"]');
        var v = el ? parseFloat(el.textContent.replace(/[^\d.]/g, '')) || 0 : 0;
        var card = document.getElementById('balanceCard'), hint = document.getElementById('balanceHint');
        if (v <= 0) { card.classList.add('clear'); hint.textContent = "You're all settled. Nothing owed."; }
        else hint.textContent = 'Please settle this with the library admin.';
    })();
    </script>
</asp:Content>
