<%@ Page Title="Manage Damaged Items & Fines" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ManageDamagedItems.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ManageDamagedItems" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fine-layout { display: grid; grid-template-columns: 380px 1fr; gap: 22px; align-items: start; }
        .fine-layout > .card { margin-bottom: 0; }
        .assess { position: sticky; top: 92px; overflow: hidden; }
        .assess::before { content: ""; position: absolute; inset: 0 0 auto 0; height: 5px; background: linear-gradient(90deg, #f59e0b, #ef4444, #ec4899); }
        .assess-head { display: flex; align-items: center; gap: 12px; margin-bottom: 18px; }
        .assess-head .ico-box { width: 42px; height: 42px; border-radius: 13px; display: grid; place-items: center; color: #fff; background: linear-gradient(135deg, #f59e0b, #ef4444); box-shadow: 0 8px 18px rgba(239,68,68,.35); }
        .assess-head h3 { margin: 0; }
        .assess-head small { color: var(--muted); }
        .peso { position: relative; }
        .peso::before { content: "\20B1"; position: absolute; left: 14px; top: 50%; transform: translateY(-50%); font-weight: 700; color: var(--muted); }
        .peso .form-control { padding-left: 32px; font-weight: 700; font-size: 16px; }
        .assess .btn-no { width: 100%; padding: 12px; }

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
                <asp:DropDownList ID="ddlTransactions" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

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
