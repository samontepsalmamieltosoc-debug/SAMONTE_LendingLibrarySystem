<%@ Page Title="Manage Requests & Queue" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ManageRequests.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ManageRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Reservation Requests & Queue Manager</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true" Style="display:block; margin-bottom:15px;"></asp:Label>

    <!-- Section 1: Pending Actionable Requests -->
    <div class="card" style="margin-bottom: 25px;">
        <h3 style="margin-top:0; color:#1e293b;">Pending Approval Requests</h3>
        
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
                        <asp:Button ID="btnApprove" runat="server" CommandName="ApproveRequest" 
                            CommandArgument='<%# Container.DataItemIndex %>' Text="Accept & Issue Loan" 
                            Style="background-color: #16a34a; color: white; border: none; padding: 6px 12px; border-radius: 4px; font-weight: bold; cursor: pointer; margin-right: 5px;" />
                        
                        <asp:Button ID="btnReject" runat="server" CommandName="RejectRequest" 
                            CommandArgument='<%# Container.DataItemIndex %>' Text="Reject" 
                            Style="background-color: #dc2626; color: white; border: none; padding: 6px 12px; border-radius: 4px; font-weight: bold; cursor: pointer;" 
                            OnClientClick="return confirm('Are you sure you want to reject this request?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- Section 2: Complete Master Queue Overview -->
    <div class="card">
        <h3 style="margin-top:0; color:#1e293b;">Master Reservation Queue Overview</h3>
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
</asp:Content>