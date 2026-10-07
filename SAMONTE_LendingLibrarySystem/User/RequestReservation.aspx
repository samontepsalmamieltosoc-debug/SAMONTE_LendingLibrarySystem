<%@ Page Title="Reserve Tool" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="RequestReservation.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.RequestReservation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .section-header { margin-bottom: 20px; }
        .section-header h2 { font-size: 26px; margin: 0 0 6px 0; }
        .section-header p { margin: 0; color: var(--muted); }

        .reserve-card { max-width: 640px; }
        .tool-head { --h: 175; display: flex; align-items: center; gap: 18px; margin-bottom: 20px; }
        .tool-tile {
            width: 76px; height: 76px; border-radius: 20px; display: grid; place-items: center; flex: none; color: #fff; font-size: 34px; font-weight: 800;
            background: linear-gradient(135deg, hsl(var(--h) 70% 38%), hsl(calc(var(--h) + 40) 75% 50%));
            box-shadow: 0 10px 22px color-mix(in srgb, hsl(var(--h) 70% 45%) 35%, transparent);
        }
        .cat-chip { display: inline-block; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: .06em; padding: 4px 11px; border-radius: 20px; margin-bottom: 6px; color: hsl(var(--h) 70% 38%); background: hsl(var(--h) 80% 93%); }
        [data-theme="dark"] .cat-chip { color: hsl(var(--h) 85% 75%); background: hsl(var(--h) 45% 20%); }
        .card .tool-name { font-size: 22px; margin: 0; text-transform: capitalize; }

        .facts { display: grid; grid-template-columns: repeat(auto-fit, minmax(170px, 1fr)); gap: 12px; margin: 0 0 22px; }
        .facts > div { background: var(--surface-2); border: 1px solid var(--line); border-radius: 12px; padding: 12px 14px; }
        .facts dt { font-size: 11.5px; font-weight: 700; text-transform: uppercase; letter-spacing: .08em; color: var(--muted); margin-bottom: 5px; }
        .facts dd { margin: 0; font-weight: 600; }

        .steps { margin: 0 0 24px; padding: 0; list-style: none; counter-reset: step; display: grid; gap: 10px; }
        .steps li { counter-increment: step; display: flex; gap: 12px; align-items: flex-start; color: var(--muted); font-size: 14px; }
        .steps li::before { content: counter(step); flex: none; width: 24px; height: 24px; border-radius: 50%; display: grid; place-items: center; font-size: 12px; font-weight: 700; color: var(--primary); background: var(--primary-soft); }

        .actions { display: flex; gap: 10px; flex-wrap: wrap; }
        a.btn { text-decoration: none; }
        .btn-ghost { color: var(--text); background: var(--surface-2); box-shadow: inset 0 0 0 1px var(--line); }
        .btn[disabled] { opacity: .7; cursor: wait; transform: none; }

        .done-card { max-width: 640px; text-align: center; padding: 36px 24px; }
        .done-mark { width: 64px; height: 64px; margin: 0 auto 16px; border-radius: 50%; display: grid; place-items: center; font-size: 30px; font-weight: 800; color: var(--success); background: var(--success-soft); }
        .done-card h3 { font-size: 20px; margin-bottom: 6px; }
        .done-card .card-sub { max-width: 440px; margin: 0 auto 22px; }
        .done-card .actions { justify-content: center; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="section-header">
        <h2>Reserve a Tool</h2>
        <p>Review the details below, then confirm to send your request to an administrator for approval.</p>
    </div>

    <asp:Label ID="lblMsg" runat="server"></asp:Label>

    <asp:Panel ID="pnlRequest" runat="server">
        <div class="card reserve-card">
            <div class="tool-head" id="toolHead" runat="server">
                <div class="tool-tile"><asp:Literal ID="litInitial" runat="server" Mode="Encode"></asp:Literal></div>
                <div>
                    <span class="cat-chip"><asp:Literal ID="litCategory" runat="server" Mode="Encode"></asp:Literal></span>
                    <h3 class="tool-name"><asp:Literal ID="litToolName" runat="server" Mode="Encode"></asp:Literal></h3>
                </div>
            </div>

            <dl class="facts">
                <div>
                    <dt>Condition</dt>
                    <dd><asp:Label ID="lblCondition" runat="server"></asp:Label></dd>
                </div>
                <div>
                    <dt>Available stock</dt>
                    <dd><asp:Literal ID="litStock" runat="server" Mode="Encode"></asp:Literal></dd>
                </div>
                <div>
                    <dt>Requested by</dt>
                    <dd><asp:Literal ID="litRequester" runat="server" Mode="Encode"></asp:Literal></dd>
                </div>
            </dl>

            <ol class="steps">
                <li>Confirm below to submit your reservation request.</li>
                <li>An administrator reviews it under Manage Requests and approves or rejects it.</li>
                <li>If approved, a loan is issued and the tool appears in My Borrow History.</li>
            </ol>

            <div class="actions">
                <asp:Button ID="btnConfirm" runat="server" Text="Confirm Reservation" CssClass="btn"
                    OnClick="btnConfirm_Click" UseSubmitBehavior="false"
                    OnClientClick="this.disabled = true; this.value = 'Sending request...';" />
                <asp:HyperLink ID="lnkCancel" runat="server" NavigateUrl="~/User/BrowseTools.aspx" CssClass="btn btn-ghost">Cancel</asp:HyperLink>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlDone" runat="server" Visible="false">
        <div class="card done-card">
            <div class="done-mark">&#10003;</div>
            <h3>Reservation request sent</h3>
            <p class="card-sub"><asp:Literal ID="litDone" runat="server" Mode="Encode"></asp:Literal></p>
            <div class="actions">
                <asp:HyperLink ID="lnkHistory" runat="server" NavigateUrl="~/User/MyHistory.aspx" CssClass="btn">View My Reservations</asp:HyperLink>
                <asp:HyperLink ID="lnkCatalog" runat="server" NavigateUrl="~/User/BrowseTools.aspx" CssClass="btn btn-ghost">Back to Catalog</asp:HyperLink>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div class="actions">
            <asp:HyperLink ID="lnkBackToCatalog" runat="server" NavigateUrl="~/User/BrowseTools.aspx" CssClass="btn">Back to Catalog</asp:HyperLink>
        </div>
    </asp:Panel>
</asp:Content>
