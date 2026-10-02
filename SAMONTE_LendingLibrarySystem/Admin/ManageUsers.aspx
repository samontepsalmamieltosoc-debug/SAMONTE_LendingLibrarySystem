<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .btn-action-deactivate {
            background-color: #dc2626;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-action-activate {
            background-color: #16a34a;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>User Account Management</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true" Style="display:block; margin-bottom:15px;"></asp:Label>

    <div class="card">
        <h3>Registered Borrowers</h3>
        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" CssClass="table" 
            DataKeyNames="BorrowerID" OnRowCommand="gvUsers_RowCommand" EmptyDataText="No registered users found.">
            <Columns>
                <asp:BoundField DataField="BorrowerID" HeaderText="ID" />
                <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                <asp:BoundField DataField="Email" HeaderText="Email / Username" />
                <asp:BoundField DataField="ContactNo" HeaderText="Contact No" />
                <asp:BoundField DataField="AccountStatus" HeaderText="Status" />
                
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnToggle" runat="server" 
                            CommandName="ToggleStatus" 
                            CommandArgument='<%# Container.DataItemIndex %>' 
                            Text='<%# Eval("AccountStatus").ToString() == "Active" ? "Deactivate" : "Activate" %>' 
                            CssClass='<%# Eval("AccountStatus").ToString() == "Active" ? "btn-action-deactivate" : "btn-action-activate" %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>