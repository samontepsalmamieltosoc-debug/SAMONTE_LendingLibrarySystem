<%@ Page Title="Inventory Management" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.Inventory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Inventory Management</h2>
    <div class="card">
        <h3>Add New Tool</h3>
        <asp:Label ID="lblMsg" runat="server" ForeColor="Green"></asp:Label>
        <div class="form-group">
            <label>Tool Name:</label>
            <asp:TextBox ID="txtToolName" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="form-group">
            <label>Category:</label>
            <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" Placeholder="e.g., Gardening, Power Tools, Hand Tools"></asp:TextBox>
        </div>
        <div class="form-group">
            <label>Quantity:</label>
            <asp:TextBox ID="txtQty" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
        </div>
        <asp:Button ID="btnAddTool" runat="server" Text="Add Tool" CssClass="btn" OnClick="btnAddTool_Click" />
    </div>

    <div class="card">
        <h3>Existing Inventory</h3>
        <asp:GridView ID="gvTools" runat="server" AutoGenerateColumns="true" EmptyDataText="No inventory items found."></asp:GridView>
    </div>
</asp:Content>