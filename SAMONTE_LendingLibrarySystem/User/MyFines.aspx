<%@ Page Title="My Fines & Penalties" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="MyFines.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.MyFines" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .status-unpaid { 
            color: #dc2626; 
            font-weight: bold; 
        }
        .status-paid { 
            color: #16a34a; 
            font-weight: bold; 
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Fines & Penalties</h2>

    <!-- Outstanding Balance Summary Card -->
    <div class="card" style="margin-bottom: 20px; background-color: #fef2f2; border: 1px solid #fca5a5; padding: 15px; border-radius: 6px;">
        <h4 style="margin: 0 0 5px 0; color: #991b1b;">Outstanding Unpaid Balance</h4>
        <asp:Label ID="lblTotalUnpaid" runat="server" Font-Size="22px" Font-Bold="true" ForeColor="#dc2626">₱0.00</asp:Label>
    </div>

    <!-- Fines History Table -->
    <div class="card">
        <h3>Fine History</h3>
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
                            CssClass='<%# Eval("PaymentStatus").ToString() == "Unpaid" ? "status-unpaid" : "status-paid" %>'>
                        </asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" NullDisplayText="Pending Payment" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>