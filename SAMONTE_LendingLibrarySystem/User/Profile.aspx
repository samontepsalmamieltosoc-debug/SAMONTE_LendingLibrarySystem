<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>My Account Profile</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true" Style="display:block; margin-bottom:15px;"></asp:Label>

    <div class="card" style="max-width: 500px; background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.08);">
        <h3>Update Profile Information</h3>

        <div style="margin-bottom: 12px;">
            <label style="display:block; font-weight:bold; margin-bottom:4px;">Full Name:</label>
            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" Style="width:100%; padding:8px;"></asp:TextBox>
        </div>

        <div style="margin-bottom: 12px;">
            <label style="display:block; font-weight:bold; margin-bottom:4px;">Email Address:</label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" Style="width:100%; padding:8px;" Enabled="true"></asp:TextBox>
        </div>

        <div style="margin-bottom: 12px;">
            <label style="display:block; font-weight:bold; margin-bottom:4px;">Contact Number:</label>
            <asp:TextBox ID="txtContactNo" runat="server" CssClass="form-control" 
                MaxLength="11" 
                onkeypress="return event.charCode >= 48 && event.charCode <= 57" 
                Style="width:100%; padding:8px;" 
                Placeholder="09123456789"></asp:TextBox>
            <small style="color: #64748b; font-size: 11px;">Must be 11 digits starting with 09 (e.g., 09123456789)</small>
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display:block; font-weight:bold; margin-bottom:4px;">New Password (leave blank to keep current):</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" Style="width:100%; padding:8px;"></asp:TextBox>
        </div>

        <asp:Button ID="btnUpdate" runat="server" Text="Save Changes" OnClick="btnUpdate_Click" 
            Style="background-color: #0d9488; color: white; border: none; padding: 10px 18px; border-radius: 4px; font-weight: bold; cursor: pointer;" />
    </div>
</asp:Content>