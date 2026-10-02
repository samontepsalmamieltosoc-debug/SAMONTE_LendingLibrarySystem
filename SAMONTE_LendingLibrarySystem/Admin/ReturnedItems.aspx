<%@ Page Title="Returned Items Log" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ReturnedItems.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ReturnedItems" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Returned Items History</h2>

    <div class="card">
        <h3>Completed & Returned Tool Loans</h3>
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
</asp:Content>