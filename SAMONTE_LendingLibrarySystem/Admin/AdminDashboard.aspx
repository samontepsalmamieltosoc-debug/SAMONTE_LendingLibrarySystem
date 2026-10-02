<%@ Page Title="Admin Analytics Dashboard" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Analytics & System Overview</h2>

    <!-- Top KPI Cards Row 1: Operations -->
    <div style="display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap;">
        <div class="card" style="flex: 1; min-width: 180px; text-align: center; border-top: 4px solid #2563eb;">
            <h4 style="margin: 0; color: #64748b;">Total Tools</h4>
            <asp:Label ID="lblTotalTools" runat="server" Font-Size="26px" Font-Bold="true" Text="0"></asp:Label>
        </div>
        
        <div class="card" style="flex: 1; min-width: 180px; text-align: center; border-top: 4px solid #0284c7;">
            <h4 style="margin: 0; color: #64748b;">Active Borrows</h4>
            <asp:Label ID="lblActiveBorrows" runat="server" Font-Size="26px" Font-Bold="true" Text="0"></asp:Label>
        </div>

        <div class="card" style="flex: 1; min-width: 180px; text-align: center; border-top: 4px solid #dc2626;">
            <h4 style="margin: 0; color: #dc2626;">Overdue Loans</h4>
            <asp:Label ID="lblOverdueLoans" runat="server" Font-Size="26px" Font-Bold="true" ForeColor="#dc2626" Text="0"></asp:Label>
        </div>

        <div class="card" style="flex: 1; min-width: 180px; text-align: center; border-top: 4px solid #f59e0b;">
            <h4 style="margin: 0; color: #64748b;">Pending Requests</h4>
            <asp:Label ID="lblPendingReservations" runat="server" Font-Size="26px" Font-Bold="true" Text="0"></asp:Label>
        </div>
    </div>

    <!-- Top KPI Cards Row 2: Financials & Maintenance -->
    <div style="display: flex; gap: 15px; margin-bottom: 25px; flex-wrap: wrap;">
        <div class="card" style="flex: 1; min-width: 220px; text-align: center; background-color: #fef2f2; border: 1px solid #fca5a5;">
            <h4 style="margin: 0; color: #991b1b;">Outstanding Unpaid Fines</h4>
            <asp:Label ID="lblUnpaidFines" runat="server" Font-Size="24px" Font-Bold="true" ForeColor="#dc2626" Text="₱0.00"></asp:Label>
        </div>

        <div class="card" style="flex: 1; min-width: 220px; text-align: center; background-color: #f0fdf4; border: 1px solid #86efac;">
            <h4 style="margin: 0; color: #166534;">Total Revenue Collected</h4>
            <asp:Label ID="lblCollectedFines" runat="server" Font-Size="24px" Font-Bold="true" ForeColor="#16a34a" Text="₱0.00"></asp:Label>
        </div>

        <div class="card" style="flex: 1; min-width: 220px; text-align: center; background-color: #fffbe3; border: 1px solid #fde047;">
            <h4 style="margin: 0; color: #854d0e;">Damaged / Maintenance Items</h4>
            <asp:Label ID="lblDamagedItems" runat="server" Font-Size="24px" Font-Bold="true" ForeColor="#ca8a04" Text="0"></asp:Label>
        </div>
    </div>

    <!-- Grid Analytics Row 1 -->
    <div style="display: flex; gap: 20px; margin-bottom: 25px; flex-wrap: wrap;">
        <!-- Top Borrowed Tools -->
        <div class="card" style="flex: 1; min-width: 300px;">
            <h3 style="margin-top: 0;">Most Popular Tools</h3>
            <asp:GridView ID="gvPopularTools" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No borrow history recorded yet.">
                <Columns>
                    <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                    <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                    <asp:BoundField DataField="TimesBorrowed" HeaderText="Total Borrows" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- Overdue Watchlist -->
        <div class="card" style="flex: 1; min-width: 300px;">
            <h3 style="margin-top: 0; color: #dc2626;">Overdue Loans Watchlist</h3>
            <asp:GridView ID="gvOverdueWatchlist" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No overdue loans at this time.">
                <Columns>
                    <asp:BoundField DataField="Borrower" HeaderText="Borrower" />
                    <asp:BoundField DataField="ToolName" HeaderText="Tool" />
                    <asp:BoundField DataField="ExpectedReturnDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="DaysOverdue" HeaderText="Days Late" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Grid Analytics Row 2 -->
    <div class="card">
        <h3 style="margin-top: 0;">Recent Transactions Activity</h3>
        <asp:GridView ID="gvRecentTransactions" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No recent transactions found.">
            <Columns>
                <asp:BoundField DataField="TransactionID" HeaderText="Tx ID" />
                <asp:BoundField DataField="Borrower" HeaderText="Borrower" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                <asp:BoundField DataField="BorrowDate" HeaderText="Borrow Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:BoundField DataField="TransactionStatus" HeaderText="Status" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>