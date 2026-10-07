<%@ Page Title="Manage Damaged Items & Fines" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" MaintainScrollPositionOnPostBack="true" CodeBehind="ManageDamagedItems.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ManageDamagedItems" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fine-layout { display: grid; grid-template-columns: 380px minmax(0, 1fr); gap: 22px; align-items: start; }
        .fine-layout > .card { margin-bottom: 0; }
        .assess { position: sticky; top: 92px; overflow-x: hidden; overflow-y: auto; max-height: calc(100vh - 110px); scrollbar-width: thin; scrollbar-color: var(--line) transparent; }
        .assess::before { content: ""; position: absolute; inset: 0 0 auto 0; height: 5px; background: linear-gradient(90deg, #f59e0b, #ef4444, #ec4899); }
        .assess-head { display: flex; align-items: center; gap: 12px; margin-bottom: 18px; }
        .assess-head .ico-box { width: 42px; height: 42px; border-radius: 13px; display: grid; place-items: center; color: #fff; background: linear-gradient(135deg, #f59e0b, #ef4444); box-shadow: 0 8px 18px rgba(239,68,68,.35); }
        .assess-head h3 { margin: 0; }
        .assess-head small { color: var(--muted); }
        .peso { position: relative; }
        .peso::before { content: "\20B1"; position: absolute; left: 14px; top: 50%; transform: translateY(-50%); font-weight: 700; color: var(--muted); }
        .peso .form-control { padding-left: 32px; font-weight: 700; font-size: 16px; }
        .assess .btn-no { width: 100%; padding: 12px; }

        /* The damaged item the admin is about to fine */
        .no-damaged { margin: 0 0 16px; padding: 10px 14px; border-radius: 12px; font-size: 13.5px; color: var(--muted); background: var(--surface-2); border: 1px solid var(--line); }
        .no-damaged a { color: var(--primary); font-weight: 600; }
        .item-box { margin: 0 0 16px; padding: 14px; border-radius: 14px; background: var(--surface-2); border: 1px solid var(--line); }
        .item-head { display: flex; align-items: center; gap: 14px; margin-bottom: 12px; }
        .item-tile { width: 56px; height: 56px; border-radius: 16px; display: grid; place-items: center; flex: none; color: #fff; font-size: 26px; font-weight: 800; background: linear-gradient(135deg, #f59e0b, #ef4444); box-shadow: 0 8px 18px rgba(239,68,68,.3); }
        .item-photo { width: 56px; height: 56px; border-radius: 16px; object-fit: cover; flex: none; border: 1px solid var(--line); }
        .item-head .badge { margin-bottom: 4px; }
        .item-head h4 { margin: 0; font-size: 17px; text-transform: capitalize; overflow-wrap: anywhere; }
        .item-head small { color: var(--muted); }
        .item-facts { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 8px; margin: 0; }
        .item-facts > div { background: var(--surface); border: 1px solid var(--line); border-radius: 10px; padding: 8px 10px; min-width: 0; }
        .item-facts dt { font-size: 10.5px; font-weight: 700; text-transform: uppercase; letter-spacing: .08em; color: var(--muted); margin-bottom: 2px; }
        .item-facts dd { margin: 0; font-weight: 600; font-size: 13.5px; overflow-wrap: anywhere; }

        .totals { display: flex; gap: 12px; flex-wrap: wrap; margin: 10px 0 6px; }
        .stat { display: flex; align-items: center; gap: 10px; padding: 10px 16px; border-radius: 14px; background: var(--surface-2); border: 1px solid var(--line); }
        .stat b { font-size: 18px; font-variant-numeric: tabular-nums; }
        .stat span { color: var(--muted); font-size: 12.5px; font-weight: 600; text-transform: uppercase; letter-spacing: .06em; }
        .settled { color: var(--success); font-weight: 800; display: inline-flex; align-items: center; gap: 6px; }

        @media (max-width: 1000px) { .fine-layout { grid-template-columns: 1fr; } .assess { position: static; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Damaged Items & Fine Management</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true"></asp:Label>

    <div class="fine-layout">
        <!-- Section 1: Assess Fine Form -->
        <div class="card assess">
            <div class="assess-head">
                <div class="ico-box"><svg class="ico"><use href="#i-alert" /></svg></div>
                <div><h3>Assess Damage Fine</h3><small>Flags the tool as damaged</small></div>
            </div>

            <div class="form-group">
                <label>Select Transaction / Item:</label>
                <asp:DropDownList ID="ddlTransactions" runat="server" CssClass="form-control"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlTransactions_SelectedIndexChanged"></asp:DropDownList>
            </div>

            <asp:Panel ID="pnlNoDamaged" runat="server" CssClass="no-damaged" Visible="false">
                Nothing is waiting for a fine. Mark a returned tool as Damaged on the
                <asp:HyperLink ID="lnkReturned" runat="server" NavigateUrl="~/Admin/ReturnedItems.aspx">Returned Items</asp:HyperLink>
                page and it will show up here.
            </asp:Panel>

            <asp:Panel ID="pnlItem" runat="server" CssClass="item-box" Visible="false">
                <div class="item-head">
                    <asp:Image ID="imgItem" runat="server" CssClass="item-photo" Visible="false" />
                    <div class="item-tile" id="itemTile" runat="server"><asp:Literal ID="litItemInitial" runat="server" Mode="Encode"></asp:Literal></div>
                    <div>
                        <span class="badge badge-danger">Damaged on return</span>
                        <h4><asp:Literal ID="litItemName" runat="server" Mode="Encode"></asp:Literal></h4>
                        <small><asp:Literal ID="litItemCategory" runat="server" Mode="Encode"></asp:Literal></small>
                    </div>
                </div>
                <dl class="item-facts">
                    <div><dt>Item ID</dt><dd><asp:Literal ID="litItemId" runat="server" Mode="Encode"></asp:Literal></dd></div>
                    <div><dt>Transaction</dt><dd><asp:Literal ID="litItemTx" runat="server" Mode="Encode"></asp:Literal></dd></div>
                    <div><dt>Borrower</dt><dd><asp:Literal ID="litItemBorrower" runat="server" Mode="Encode"></asp:Literal></dd></div>
                    <div><dt>Borrowed</dt><dd><asp:Literal ID="litItemBorrowed" runat="server" Mode="Encode"></asp:Literal></dd></div>
                    <div><dt>Due date</dt><dd><asp:Literal ID="litItemDue" runat="server" Mode="Encode"></asp:Literal></dd></div>
                    <div><dt>Returned</dt><dd><asp:Literal ID="litItemReturned" runat="server" Mode="Encode"></asp:Literal></dd></div>
                </dl>
            </asp:Panel>

            <div class="form-group">
                <label>Damage Description:</label>
                <asp:TextBox ID="txtDamageNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" Placeholder="e.g. Broken casing, missing attachments"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Fine Amount (₱):</label>
                <div class="peso">
                    <asp:TextBox ID="txtFineAmount" runat="server" TextMode="Number" step="0.01" CssClass="form-control" Placeholder="0.00"></asp:TextBox>
                </div>
            </div>

            <asp:Button ID="btnAssessFine" runat="server" Text="Assess Fine" OnClick="btnAssessFine_Click" CssClass="btn-no" />
        </div>

        <!-- Section 2: Active Fines & Payment Records -->
        <div class="card">
            <div class="card-head">
                <div>
                    <h3>Fine & Payment Records</h3>
                    <p class="card-sub">Mark a fine as paid once you've received the money.</p>
                </div>
            </div>
            <div class="totals" id="fineTotals"></div>
            <asp:GridView ID="gvFines" runat="server" AutoGenerateColumns="false" CssClass="table"
                DataKeyNames="FineID" OnRowCommand="gvFines_RowCommand" EmptyDataText="No fine records found.">
                <Columns>
                    <asp:BoundField DataField="FineID" HeaderText="Fine ID" />
                    <asp:BoundField DataField="BorrowerName" HeaderText="Borrower" />
                    <asp:BoundField DataField="ToolName" HeaderText="Tool" />
                    <asp:BoundField DataField="DamageNotes" HeaderText="Damage Details" />
                    <asp:BoundField DataField="FineAmount" HeaderText="Fine Amount" DataFormatString="₱{0:N2}" />
                    <asp:BoundField DataField="CreatedDate" HeaderText="Date Assessed" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="PaymentStatus" HeaderText="Status" />
                    <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" NullDisplayText="N/A" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnMarkPaid" runat="server" CommandName="MarkAsPaid"
                                CommandArgument='<%# Container.DataItemIndex %>' Text="Mark as Paid"
                                Visible='<%# Eval("PaymentStatus").ToString() == "Unpaid" %>'
                                CssClass="btn-ok btn-sm"
                                OnClientClick="return confirm('Confirm receipt of payment for this fine?');" />
                            <asp:Label ID="lblPaid" runat="server" Text="Settled" CssClass="settled"
                                Visible='<%# Eval("PaymentStatus").ToString() == "Paid" %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <script>
    (function () {
        var tbl = document.querySelector('[id$="gvFines"]');
        if (!tbl) return;
        var ths = Array.prototype.slice.call(tbl.querySelectorAll('th')).map(function (t) { return t.textContent.trim(); });
        var iAmt = ths.indexOf('Fine Amount'), iSt = ths.indexOf('Status');
        if (iAmt < 0 || iSt < 0) return;
        var unpaid = 0, paid = 0, n = 0;
        Array.prototype.slice.call(tbl.querySelectorAll('tr')).forEach(function (r) {
            if (!r.querySelector('td')) return;
            var amt = parseFloat(r.children[iAmt].textContent.replace(/[^\d.]/g, '')) || 0;
            n++;
            if (r.children[iSt].textContent.trim() === 'Paid') paid += amt; else unpaid += amt;
            r.children[iAmt].style.fontWeight = '700';
        });
        var m = function (v) { return '₱' + v.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }); };
        if (n) document.getElementById('fineTotals').innerHTML =
            '<div class="stat"><b>' + n + '</b><span>Fines</span></div>' +
            '<div class="stat"><b style="color:var(--danger)">' + m(unpaid) + '</b><span>Unpaid</span></div>' +
            '<div class="stat"><b style="color:var(--success)">' + m(paid) + '</b><span>Collected</span></div>';
    })();
    </script>
</asp:Content>
