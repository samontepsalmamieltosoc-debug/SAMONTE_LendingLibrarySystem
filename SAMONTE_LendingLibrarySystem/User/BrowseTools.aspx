<%@ Page Title="Available Tools Catalog" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="BrowseTools.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.BrowseTools" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .catalog-header { margin-bottom: 25px; }
        .catalog-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 25px; margin-top: 20px; }
        .tool-card { background: #ffffff; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); overflow: hidden; display: flex; flex-direction: column; transition: transform 0.2s ease, box-shadow 0.2s ease; border: 1px solid #e2e8f0; }
        .tool-card:hover { transform: translateY(-4px); box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12); }
        .card-image-placeholder { height: 140px; background: linear-gradient(135deg, #0f766e, #0d9488); display: flex; align-items: center; justify-content: center; color: #ffffff; font-size: 36px; font-weight: bold; letter-spacing: 2px; }
        .card-body { padding: 20px; display: flex; flex-direction: column; flex-grow: 1; }
        .category-badge { display: inline-block; background-color: #e0f2fe; color: #0369a1; font-size: 11px; font-weight: 700; text-transform: uppercase; padding: 4px 10px; border-radius: 20px; margin-bottom: 10px; align-self: flex-start; }
        .tool-title { font-size: 20px; font-weight: 700; color: #1e293b; margin: 0 0 12px 0; text-transform: capitalize; }
        .tool-info { font-size: 14px; color: #64748b; margin-bottom: 8px; display: flex; justify-content: space-between; }
        .status-tag { font-weight: 600; padding: 2px 8px; border-radius: 4px; font-size: 12px; }
        .status-good { background-color: #dcfce7; color: #15803d; }
        .status-damaged { background-color: #fee2e2; color: #b91c1c; }
        .card-footer { margin-top: auto; padding-top: 15px; border-top: 1px solid #f1f5f9; }
        .btn-reserve { display: block; width: 100%; text-align: center; background-color: #0d9488; color: white; padding: 10px; border-radius: 6px; text-decoration: none; font-weight: 600; transition: background-color 0.2s ease; }
        .btn-reserve:hover { background-color: #0f766e; }
        .btn-disabled { background-color: #cbd5e1; color: #64748b; cursor: not-allowed; pointer-events: none; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="catalog-header">
        <h2>Available Tools Catalog</h2>
        <p style="color: #64748b;">Browse available equipment and reserve items directly for borrowing.</p>
    </div>

    <div class="catalog-grid">
        <asp:Repeater ID="rptCatalog" runat="server">
            <ItemTemplate>
                <div class="tool-card">
                    <div class="card-image-placeholder">
                        <%# Eval("ToolName").ToString().Substring(0, 1).ToUpper() %>
                    </div>

                    <div class="card-body">
                        <span class="category-badge"><%# Eval("CategoryName") %></span>
                        <h3 class="tool-title"><%# Eval("ToolName") %></h3>

                        <div class="tool-info">
                            <span>Condition:</span>
                            <span class='<%# Eval("ConditionStatus").ToString() == "Good" ? "status-tag status-good" : "status-tag status-damaged" %>'>
                                <%# Eval("ConditionStatus") %>
                            </span>
                        </div>

                        <div class="tool-info">
                            <span>Available Stock:</span>
                            <strong style="color: #0f172a;"><%# Eval("AvailableQty") %></strong>
                        </div>

                        <div class="card-footer">
                            <a href='<%# "RequestReservation.aspx?ToolID=" + Eval("ToolID") %>' 
                               class='<%# Convert.ToInt32(Eval("AvailableQty")) > 0 && Eval("ConditionStatus").ToString() == "Good" ? "btn-reserve" : "btn-reserve btn-disabled" %>'>
                                <%# Convert.ToInt32(Eval("AvailableQty")) > 0 && Eval("ConditionStatus").ToString() == "Good" ? "Reserve Item" : "Unavailable" %>
                            </a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>