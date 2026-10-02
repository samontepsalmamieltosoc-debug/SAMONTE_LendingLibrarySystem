<%@ Page Title="Return Borrowed Item" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="ReturnItem.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.ReturnItem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .msg-box {
            padding: 12px 16px;
            border-radius: 6px;
            font-weight: 600;
            margin-bottom: 20px;
            display: block;
        }
        .msg-error {
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        .msg-success {
            background-color: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }
        .section-header {
            margin-bottom: 20px;
        }
        .section-header h2 {
            margin: 0 0 6px 0;
            color: #0f172a;
        }
        .section-header p {
            margin: 0;
            color: #64748b;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="section-header">
        <h2>Return Borrowed Tools</h2>
        <p>Select an active borrow transaction to process an item return request.</p>
    </div>

    <!-- Status / Error Notification Label -->
    <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>

    <div class="card">
        <h3>My Active Borrows</h3>
        <asp:GridView ID="gvActiveBorrows" runat="server" AutoGenerateColumns="false" CssClass="table"
            DataKeyNames="TransactionID,ToolID" OnRowCommand="gvActiveBorrows_RowCommand" 
            EmptyDataText="You currently have no active borrowed items to return.">
            <Columns>
                <asp:BoundField DataField="TransactionID" HeaderText="Txn ID" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                <asp:BoundField DataField="BorrowDate" HeaderText="Borrow Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="ExpectedReturnDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                
                <asp:TemplateField HeaderText="Condition / Notes">
                    <ItemTemplate>
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" 
                            Placeholder="Optional return notes / condition report..." MaxLength="200" Style="width:90%;"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnReturn" runat="server" 
                            CommandName="ReturnTool" 
                            CommandArgument='<%# Container.DataItemIndex %>' 
                            Text="Process Return" 
                            CssClass="btn" Style="background-color: #0d9488;" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>