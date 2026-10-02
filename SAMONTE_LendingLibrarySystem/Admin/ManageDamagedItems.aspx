<%@ Page Title="Manage Damaged Items & Fines" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ManageDamagedItems.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ManageDamagedItems" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Damaged Items & Fine Management</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true" Style="display:block; margin-bottom:15px;"></asp:Label>

    <!-- Section 1: Assess Fine Form -->
    <div class="card" style="margin-bottom: 25px;">
        <h3>Assess Damage Fine</h3>
        
        <div class="form-group" style="margin-bottom: 12px;">
            <label style="display:block; font-weight:bold; margin-bottom:4px;">Select Transaction / Item:</label>
            <asp:DropDownList ID="ddlTransactions" runat="server" CssClass="form-control" Style="max-width:450px; padding:8px;"></asp:DropDownList>
        </div>

        <div class="form-group" style="margin-bottom: 12px;">
            <label style="display:block; font-weight:bold; margin-bottom:4px;">Damage Description:</label>
            <asp:TextBox ID="txtDamageNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" Style="max-width:450px; padding:8px;" Placeholder="e.g. Broken casing, missing attachments"></asp:TextBox>
        </div>

        <div class="form-group" style="margin-bottom: 12px;">
            <label style="display:block; font-weight:bold; margin-bottom:4px;">Fine Amount (₱):</label>
            <asp:TextBox ID="txtFineAmount" runat="server" TextMode="Number" step="0.01" CssClass="form-control" Style="max-width:200px; padding:8px;" Placeholder="0.00"></asp:TextBox>
        </div>

        <asp:Button ID="btnAssessFine" runat="server" Text="Assess Fine" OnClick="btnAssessFine_Click" 
            Style="background-color: #dc2626; color: white; border: none; padding: 10px 18px; border-radius: 4px; font-weight: bold; cursor: pointer;" />
    </div>

    <!-- Section 2: Active Fines & Payment Records -->
    <div class="card">
        <h3>Fine & Payment Records</h3>
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
                            Style="background-color: #16a34a; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer;" 
                            OnClientClick="return confirm('Confirm receipt of payment for this fine?');" />
                        <asp:Label ID="lblPaid" runat="server" Text="Settled" ForeColor="Green" Font-Bold="true"
                            Visible='<%# Eval("PaymentStatus").ToString() == "Paid" %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>