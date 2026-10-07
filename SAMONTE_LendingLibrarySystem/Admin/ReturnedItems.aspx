<%@ Page Title="Returned Items Log" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ReturnedItems.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ReturnedItems" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .late-tag { margin-left: 8px; font-size: 11.5px; font-weight: 700; padding: 3px 9px; border-radius: 999px; color: var(--danger); background: var(--danger-soft); white-space: nowrap; }
        .ontime-tag { margin-left: 8px; font-size: 11.5px; font-weight: 700; padding: 3px 9px; border-radius: 999px; color: var(--success); background: var(--success-soft); white-space: nowrap; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Returned Items History</h2>

    <div class="card">
        <div class="card-head">
            <div>
                <h3>Completed & Returned Tool Loans</h3>
                <p class="card-sub">Every finished loan, with a quick on-time / late check against the due date.</p>
            </div>
        </div>
        <asp:GridView ID="gvReturnedItems" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No returned items recorded yet.">
            <Columns>
                <asp:BoundField DataField="TransactionID" HeaderText="Tx ID" />
                <asp:BoundField DataField="BorrowerName" HeaderText="Borrower" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                <asp:BoundField DataField="BorrowDate" HeaderText="Borrow Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="ExpectedReturnDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="ActualReturnDate" HeaderText="Return Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:BoundField DataField="ConditionStatus" HeaderText="Condition Status" />
            </Columns>
        </asp:GridView>
    </div>

    <script>
    (function () {
        var tbl = document.querySelector('[id$="gvReturnedItems"]');
        if (!tbl) return;
        var ths = Array.prototype.slice.call(tbl.querySelectorAll('th')).map(function (t) { return t.textContent.trim(); });
        var iDue = ths.indexOf('Due Date'), iRet = ths.indexOf('Return Date');
        if (iDue < 0 || iRet < 0) return;
        Array.prototype.slice.call(tbl.querySelectorAll('tr')).forEach(function (r) {
            if (!r.querySelector('td')) return;
            var due = Date.parse(r.children[iDue].textContent.trim()), ret = Date.parse(r.children[iRet].textContent.trim().substr(0, 10));
            if (isNaN(due) || isNaN(ret)) return;
            var days = Math.round((ret - due) / 86400000), tag = document.createElement('span');
            tag.className = days > 0 ? 'late-tag' : 'ontime-tag';
            tag.textContent = days > 0 ? days + 'd late' : 'on time';
            r.children[iRet].appendChild(tag);
        });
    })();
    </script>
</asp:Content>
