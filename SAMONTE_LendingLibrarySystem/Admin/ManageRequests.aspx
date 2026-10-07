<%@ Page Title="Manage Requests & Queue" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ManageRequests.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ManageRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .actions { display: flex; gap: 8px; flex-wrap: nowrap; }
        .qpos { display: inline-grid; place-items: center; min-width: 30px; height: 30px; padding: 0 8px; border-radius: 10px; font-weight: 800; color: var(--primary); background: var(--primary-soft); }
        .qpos.first { color: #fff; background: linear-gradient(135deg, var(--primary), var(--primary-2)); box-shadow: 0 4px 10px color-mix(in srgb, var(--primary) 40%, transparent); }
        .low-stock { color: var(--danger); font-weight: 800; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Reservation Requests & Queue Manager</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true"></asp:Label>

    <!-- Section 1: Pending Actionable Requests -->
    <div class="card">
        <div class="card-head">
            <div>
                <h3>Pending Approval Requests</h3>
                <p class="card-sub">Approving issues the loan and deducts stock. A red stock count means nothing is left to lend.</p>
            </div>
        </div>

        <asp:GridView ID="gvPendingRequests" runat="server" AutoGenerateColumns="false" CssClass="table" 
            DataKeyNames="ReservationID,ToolID,BorrowerID" OnRowCommand="gvPendingRequests_RowCommand" 
            EmptyDataText="No pending reservation requests found.">
            <Columns>
                <asp:BoundField DataField="ReservationID" HeaderText="Req ID" />
                <asp:BoundField DataField="FullName" HeaderText="Borrower" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool Requested" />
                <asp:BoundField DataField="AvailableQty" HeaderText="Stock Available" />
                <asp:BoundField DataField="QueuePosition" HeaderText="Queue Pos." />
                <asp:BoundField DataField="RequestDate" HeaderText="Requested On" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:BoundField DataField="ReservationStatus" HeaderText="Status" />
                
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <div class="actions">
                            <asp:Button ID="btnApprove" runat="server" CommandName="ApproveRequest"
                                CommandArgument='<%# Container.DataItemIndex %>' Text="Accept & Issue Loan"
                                CssClass="btn-ok btn-sm" />

                            <asp:Button ID="btnReject" runat="server" CommandName="RejectRequest"
                                CommandArgument='<%# Container.DataItemIndex %>' Text="Reject"
                                CssClass="btn-no btn-sm"
                                OnClientClick="return confirm('Are you sure you want to reject this request?');" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- Section 2: Complete Master Queue Overview -->
    <div class="card">
        <div class="card-head"><h3>Master Reservation Queue Overview</h3></div>
        <asp:GridView ID="gvAllQueue" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No reservation records found in queue.">
            <Columns>
                <asp:BoundField DataField="ReservationID" HeaderText="Res ID" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool" />
                <asp:BoundField DataField="FullName" HeaderText="Borrower" />
                <asp:BoundField DataField="QueuePosition" HeaderText="Queue Position" />
                <asp:BoundField DataField="RequestDate" HeaderText="Request Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:BoundField DataField="ReservationStatus" HeaderText="Status" />
            </Columns>
        </asp:GridView>
    </div>

    <script>
    (function () {
        function headIndex(tbl, label) {
            var ths = Array.prototype.slice.call(tbl.querySelectorAll('th')).map(function (t) { return t.textContent.trim(); });
            return ths.indexOf(label);
        }
        function eachRow(tbl, fn) {
            Array.prototype.slice.call(tbl.querySelectorAll('tr')).forEach(function (r) { if (r.querySelector('td')) fn(r); });
        }
        ['gvPendingRequests', 'gvAllQueue'].forEach(function (id) {
            var tbl = document.querySelector('[id$="' + id + '"]');
            if (!tbl) return;
            var q = Math.max(headIndex(tbl, 'Queue Pos.'), headIndex(tbl, 'Queue Position'));
            var s = headIndex(tbl, 'Stock Available');
            eachRow(tbl, function (r) {
                if (q > -1) {
                    var n = r.children[q].textContent.trim();
                    r.children[q].innerHTML = '<span class="qpos' + (n === '1' ? ' first' : '') + '">' + (n || '-') + '</span>';
                }
                if (s > -1 && parseInt(r.children[s].textContent, 10) === 0) r.children[s].innerHTML = '<span class="low-stock">0</span>';
            });
        });
    })();
    </script>
</asp:Content>