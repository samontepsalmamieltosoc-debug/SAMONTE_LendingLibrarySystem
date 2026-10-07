<%@ Page Title="Inventory Management" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="Inventory.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.Inventory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .inv-layout { display: grid; grid-template-columns: 340px 1fr; gap: 22px; align-items: start; }
        .inv-layout > .card { margin-bottom: 0; }
        .add-card { position: sticky; top: 92px; overflow: hidden; }
        .add-card::before { content: ""; position: absolute; inset: 0 0 auto 0; height: 5px; background: linear-gradient(90deg, var(--primary), var(--primary-2), #ec4899); }
        .add-head { display: flex; align-items: center; gap: 12px; margin-bottom: 18px; }
        .add-head .kpi-ico { margin: 0; width: 42px; height: 42px; background: linear-gradient(135deg, var(--primary), var(--primary-2)); color: #fff; display: grid; place-items: center; border-radius: 13px; }
        .add-head h3 { margin: 0; }
        .add-head small { color: var(--muted); }
        .add-card .btn { width: 100%; padding: 12px; }
        .chips { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 8px; }
        .chip { border: 1px dashed var(--line); background: var(--surface-2); color: var(--muted); padding: 4px 11px; border-radius: 999px; font-size: 12.5px; cursor: pointer; transition: all .15s; }
        .chip:hover { border-color: var(--primary); color: var(--primary); background: var(--primary-soft); }

        .stock { display: flex; align-items: center; gap: 10px; min-width: 150px; }
        .stock .meter { flex: 1; height: 8px; border-radius: 999px; background: var(--line); overflow: hidden; }
        .stock .meter i { display: block; height: 100%; width: 0; border-radius: inherit; transition: width 1s cubic-bezier(.2,.8,.2,1); }
        .stock span { font-size: 12.5px; color: var(--muted); font-variant-numeric: tabular-nums; white-space: nowrap; }
        .stock b { color: var(--text); }

        @media (max-width: 1000px) { .inv-layout { grid-template-columns: 1fr; } .add-card { position: static; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Inventory Management</h2>

    <div class="inv-layout">
        <div class="card add-card">
            <div class="add-head">
                <div class="kpi-ico"><svg class="ico"><use href="#i-plus" /></svg></div>
                <div><h3>Add New Tool</h3><small>Register stock into the library</small></div>
            </div>
            <asp:Label ID="lblMsg" runat="server" ForeColor="Green"></asp:Label>
            <div class="form-group">
                <label>Tool Name:</label>
                <asp:TextBox ID="txtToolName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>Category:</label>
                <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" Placeholder="e.g., Gardening, Power Tools, Hand Tools"></asp:TextBox>
                <div class="chips" id="catChips"></div>
            </div>
            <div class="form-group">
                <label>Quantity:</label>
                <asp:TextBox ID="txtQty" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
            </div>
            <asp:Button ID="btnAddTool" runat="server" Text="Add Tool" CssClass="btn" OnClick="btnAddTool_Click" />
        </div>

        <div class="card">
            <div class="card-head">
                <div>
                    <h3>Existing Inventory</h3>
                    <p class="card-sub">Live stock levels. Green means plenty on the shelf, red means nearly out.</p>
                </div>
            </div>
            <asp:GridView ID="gvTools" runat="server" AutoGenerateColumns="true" CssClass="table" EmptyDataText="No inventory items found."></asp:GridView>
        </div>
    </div>

    <script>
    (function () {
        var tbl = document.querySelector('[id$="gvTools"]');
        if (tbl) {
            var ths = Array.prototype.slice.call(tbl.querySelectorAll('th')).map(function (t) { return t.textContent.trim().toLowerCase(); });
            var iAvail = ths.indexOf('availableqty'), iTotal = ths.indexOf('totalqty'), iCat = ths.indexOf('categoryname');
            var cats = {};

            Array.prototype.slice.call(tbl.querySelectorAll('tr')).forEach(function (r, n) {
                if (!r.querySelector('td')) return;
                if (iCat > -1) { var c = r.children[iCat].textContent.trim(); if (c) cats[c] = (cats[c] || 0) + 1; }
                if (iAvail < 0 || iTotal < 0) return;
                var a = parseInt(r.children[iAvail].textContent, 10), t = parseInt(r.children[iTotal].textContent, 10);
                if (isNaN(a) || isNaN(t) || t <= 0) return;
                var p = Math.max(0, Math.min(1, a / t)), col = p > .5 ? '#10b981' : p > .2 ? '#f59e0b' : '#ef4444';
                r.children[iAvail].innerHTML = '<div class="stock"><div class="meter"><i style="background:' + col + '"></i></div><span><b>' + a + '</b> / ' + t + '</span></div>';
                var fill = r.children[iAvail].querySelector('i');
                setTimeout(function () { fill.style.width = (p * 100) + '%'; }, 120 + n * 40);
            });

            /* Quick-pick chips: most-used existing categories fill the Category box */
            var box = document.getElementById('catChips'), input = document.querySelector('[id$="txtCategory"]');
            Object.keys(cats).sort(function (a, b) { return cats[b] - cats[a]; }).slice(0, 6).forEach(function (c) {
                var b = document.createElement('button'); b.type = 'button'; b.className = 'chip'; b.textContent = c;
                b.addEventListener('click', function () { input.value = c; input.focus(); });
                box.appendChild(b);
            });
        }
    })();
    </script>
</asp:Content>
