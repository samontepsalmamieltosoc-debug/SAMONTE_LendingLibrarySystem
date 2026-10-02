<%@ Page Title="My Borrow History" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MyHistory.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.MyHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .badge-overdue {
            color: #dc2626;
            background-color: #fee2e2;
            padding: 4px 10px;
            border-radius: 4px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-ontime {
            color: #16a34a;
            background-color: #dcfce7;
            padding: 4px 10px;
            border-radius: 4px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-returned {
            color: #475569;
            background-color: #f1f5f9;
            padding: 4px 10px;
            border-radius: 4px;
            font-weight: 600;
            display: inline-block;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Borrowing History & Active Reservations</h2>

    <div class="card">
        <h3>My Active & Past Borrows</h3>
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
        <h3>My Reservations</h3>
        <asp:GridView ID="gvMyReservations" runat="server" AutoGenerateColumns="true" CssClass="table" EmptyDataText="No active reservations."></asp:GridView>
    </div>
</asp:Content>