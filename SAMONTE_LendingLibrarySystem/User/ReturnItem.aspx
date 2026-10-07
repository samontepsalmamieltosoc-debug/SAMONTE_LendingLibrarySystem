<%@ Page Title="Return Borrowed Item" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="ReturnItem.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.ReturnItem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .msg-box { display: block; }
        .section-header { margin-bottom: 20px; }
        .section-header h2 { font-size: 26px; margin: 0 0 6px 0; }
        .section-header p { margin: 0; color: var(--muted); }
        .due { font-size: 12px; font-weight: 700; padding: 3px 10px; border-radius: 999px; margin-left: 8px; white-space: nowrap; }
        .due-ok { color: var(--success); background: var(--success-soft); }
        .due-soon { color: var(--warn); background: var(--warn-soft); }
        .due-late { color: var(--danger); background: var(--danger-soft); }
        table.table td .form-control { min-width: 220px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="section-header">
        <h2>Return Borrowed Tools</h2>
        <p>Select an active borrow transaction to process an item return request.</p>
    </div>

    <!-- Status / Error Notification Label -->
    <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>

    <div class="card">
        <div class="card-head">
            <div>
                <h3>My Active Borrows</h3>
                <p class="card-sub">Add an optional note about the tool's condition, then process the return.</p>
            </div>
        </div>
        <asp:GridView ID="gvActiveBorrows" runat="server" AutoGenerateColumns="false" CssClass="table"
            DataKeyNames="TransactionID,ToolID" OnRowCommand="gvActiveBorrows_RowCommand"
            EmptyDataText="You currently have no active borrowed items to return.">
            <Columns>
                <asp:BoundField DataField="TransactionID" HeaderText="Txn ID" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                <asp:BoundField DataField="BorrowDate" HeaderText="Borrow Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="ExpectedReturnDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />

                <asp:TemplateField HeaderText="Condition / Notes">
                    <ItemTemplate>
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control"
                            Placeholder="Optional return notes / condition report..." MaxLength="200"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnReturn" runat="server"
                            CommandName="ReturnTool"
                            CommandArgument='<%# Container.DataItemIndex %>'
                            Text="Process Return"
                            CssClass="btn btn-sm" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <script>
    (function () {
        var tbl = document.querySelector('[id$="gvActiveBorrows"]');
        if (!tbl) return;
        var ths = Array.prototype.slice.call(tbl.querySelectorAll('th')).map(function (t) { return t.textContent.trim(); });
        var iDue = ths.indexOf('Due Date');
        if (iDue < 0) return;
        var today = new Date(); today.setHours(0, 0, 0, 0);
        Array.prototype.slice.call(tbl.querySelectorAll('tr')).forEach(function (r) {
            if (!r.querySelector('td')) return;
            var d = Date.parse(r.children[iDue].textContent.trim() + 'T00:00:00');
            if (isNaN(d)) return;
            var days = Math.round((d - today.getTime()) / 86400000), tag = document.createElement('span');
            tag.className = 'due ' + (days < 0 ? 'due-late' : days <= 2 ? 'due-soon' : 'due-ok');
            tag.textContent = days < 0 ? Math.abs(days) + (days === -1 ? ' day overdue' : ' days overdue') : days === 0 ? 'due today' : 'in ' + days + (days === 1 ? ' day' : ' days');
            r.children[iDue].appendChild(tag);
        });
    })();
    </script>
</asp:Content>
