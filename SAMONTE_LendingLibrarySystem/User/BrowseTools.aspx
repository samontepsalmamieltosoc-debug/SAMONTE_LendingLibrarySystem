<%@ Page Title="Available Tools Catalog" Language="C#" MasterPageFile="~/User.Master" AutoEventWireup="true" CodeBehind="BrowseTools.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.User.BrowseTools" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .hero {
            position: relative; overflow: hidden; border-radius: 22px; padding: 28px 32px; margin-bottom: 22px; color: #fff;
            background: linear-gradient(120deg, #0f766e 0%, #0d9488 45%, #0284c7 100%); box-shadow: 0 18px 40px rgba(13,148,136,.32);
        }
        .hero::before, .hero::after { content: ""; position: absolute; border-radius: 50%; background: rgba(255,255,255,.12); }
        .hero::before { width: 250px; height: 250px; right: -60px; top: -90px; animation: drift 9s ease-in-out infinite; }
        .hero::after { width: 150px; height: 150px; right: 160px; bottom: -80px; background: rgba(255,255,255,.08); animation: drift 12s ease-in-out infinite reverse; }
        @keyframes drift { 50% { transform: translate(-18px, 14px) scale(1.06); } }
        .hero h2 { font-size: 28px; position: relative; z-index: 1; }
        .hero p { margin: 8px 0 0; opacity: .9; max-width: 540px; position: relative; z-index: 1; }
        .hero-stats { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 16px; position: relative; z-index: 1; }
        .hero-stats span { background: rgba(255,255,255,.17); border: 1px solid rgba(255,255,255,.25); padding: 7px 14px; border-radius: 999px; font-size: 13px; font-weight: 600; }

        .filters { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin-bottom: 14px; }
        .filters .search-box { max-width: 340px; }
        .pill-row { display: flex; gap: 8px; flex-wrap: wrap; }
        .pill { border: 1.5px solid var(--line); background: var(--surface); color: var(--muted); padding: 7px 14px; border-radius: 999px; font: inherit; font-size: 13px; font-weight: 600; cursor: pointer; transition: all .15s; }
        .pill:hover { border-color: var(--primary); color: var(--primary); }
        .pill.on { color: #fff; border-color: transparent; background: linear-gradient(135deg, var(--primary), var(--primary-2)); box-shadow: 0 6px 14px color-mix(in srgb, var(--primary) 35%, transparent); }
        .switch { display: inline-flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 600; color: var(--muted); cursor: pointer; user-select: none; margin-left: auto; }
        .switch input { accent-color: var(--primary); width: 16px; height: 16px; }

        .catalog-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(262px, 1fr)); gap: 22px; margin-top: 16px; }
        .tool-card {
            --h: 175; background: var(--surface); border-radius: 20px; box-shadow: var(--shadow); overflow: hidden; display: flex; flex-direction: column;
            transition: transform .25s ease, box-shadow .25s ease; border: 1px solid var(--line);
        }
        .tool-card:hover { transform: translateY(-6px); box-shadow: 0 18px 36px color-mix(in srgb, hsl(var(--h) 70% 45%) 28%, transparent); }
        .tool-card.gone { display: none; }
        .card-image-placeholder {
            height: 132px; position: relative; overflow: hidden; display: flex; align-items: center; justify-content: center; color: #fff;
            font-size: 52px; font-weight: 800; letter-spacing: 2px;
            background: linear-gradient(135deg, hsl(var(--h) 70% 38%), hsl(calc(var(--h) + 40) 75% 50%));
        }
        .card-image-placeholder::before, .card-image-placeholder::after { content: ""; position: absolute; border-radius: 50%; background: rgba(255,255,255,.14); }
        .card-image-placeholder::before { width: 120px; height: 120px; right: -30px; top: -40px; }
        .card-image-placeholder::after { width: 70px; height: 70px; left: -20px; bottom: -28px; }
        .card-image-placeholder span { position: relative; z-index: 1; text-shadow: 0 4px 14px rgba(0,0,0,.25); }
        .card-body { padding: 18px 20px 20px; display: flex; flex-direction: column; flex-grow: 1; }
        .category-badge { display: inline-block; color: hsl(var(--h) 70% 38%); background: hsl(var(--h) 80% 93%); font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: .06em; padding: 4px 11px; border-radius: 20px; margin-bottom: 10px; align-self: flex-start; }
        [data-theme="dark"] .category-badge { color: hsl(var(--h) 85% 75%); background: hsl(var(--h) 45% 20%); }
        .tool-title { font-size: 19px; font-weight: 700; color: var(--text); margin: 0 0 12px 0; text-transform: capitalize; }
        .tool-info { font-size: 13.5px; color: var(--muted); margin-bottom: 9px; display: flex; justify-content: space-between; align-items: center; }
        .tool-info strong { color: var(--text); }
        .status-tag { font-weight: 700; padding: 3px 10px; border-radius: 999px; font-size: 12px; }
        .status-good { background-color: var(--success-soft); color: var(--success); }
        .status-damaged { background-color: var(--danger-soft); color: var(--danger); }
        .meter { height: 7px; border-radius: 999px; background: var(--line); overflow: hidden; margin: -2px 0 6px; }
        .meter i { display: block; height: 100%; width: 0; border-radius: inherit; transition: width .9s cubic-bezier(.2,.8,.2,1); }
        .card-footer { margin-top: auto; padding-top: 14px; }
        .btn-reserve { display: block; width: 100%; text-align: center; color: #fff; padding: 11px; border-radius: 12px; text-decoration: none; font-weight: 700; background: linear-gradient(135deg, var(--primary), var(--primary-2)); box-shadow: 0 6px 14px color-mix(in srgb, var(--primary) 32%, transparent); transition: transform .15s, filter .2s; }
        .btn-reserve:hover { transform: translateY(-2px); filter: brightness(1.08); }
        .btn-disabled { background: var(--line); color: var(--muted); cursor: not-allowed; pointer-events: none; box-shadow: none; }

        .no-results { display: none; text-align: center; padding: 50px 10px; color: var(--muted); }
        .no-results b { display: block; font-size: 38px; margin-bottom: 6px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="hero">
        <h2>Available Tools Catalog</h2>
        <p>Browse available equipment and reserve items directly for borrowing.</p>
        <div class="hero-stats" id="heroStats"></div>
    </div>

    <div class="filters">
        <div class="search-box">
            <svg class="ico"><use href="#i-search" /></svg>
            <input type="text" id="toolSearch" class="form-control" placeholder="Search tools or categories..." autocomplete="off" />
        </div>
        <div class="pill-row" id="catPills"></div>
        <label class="switch"><input type="checkbox" id="onlyAvail" /> Available only</label>
    </div>

    <div class="catalog-grid" id="catalogGrid">
        <asp:Repeater ID="rptCatalog" runat="server">
            <ItemTemplate>
                <div class="tool-card" data-cat='<%#: Eval("CategoryName") %>' data-name='<%#: Eval("ToolName") %>'
                     data-ok='<%# Convert.ToInt32(Eval("AvailableQty")) > 0 && Eval("ConditionStatus").ToString() == "Good" ? "1" : "0" %>'>
                    <div class="card-image-placeholder">
                        <span><%# Eval("ToolName").ToString().Substring(0, 1).ToUpper() %></span>
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
                            <strong class="stock-num"><%# Eval("AvailableQty") %></strong>
                        </div>
                        <div class="meter"><i></i></div>

                        <div class="card-footer">
                            <a href='<%# "BrowseTools.aspx?ToolID=" + Eval("ToolID") %>'
                               class='<%# Convert.ToInt32(Eval("AvailableQty")) > 0 && Eval("ConditionStatus").ToString() == "Good" ? "btn-reserve" : "btn-reserve btn-disabled" %>'>
                                <%# Convert.ToInt32(Eval("AvailableQty")) > 0 && Eval("ConditionStatus").ToString() == "Good" ? "Reserve Item" : "Unavailable" %>
                            </a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <div class="no-results" id="noResults"><b>&#128269;</b>No tools match your search.</div>

    <script>
    (function () {
        var cards = Array.prototype.slice.call(document.querySelectorAll('.tool-card'));
        var search = document.getElementById('toolSearch'), only = document.getElementById('onlyAvail');
        var pills = document.getElementById('catPills'), activeCat = '';

        /* Each category gets its own hue, so cards group visually */
        var cats = [];
        cards.forEach(function (c) { var k = c.getAttribute('data-cat') || ''; if (cats.indexOf(k) < 0) cats.push(k); });
        cats.sort();
        function hue(k) { var s = 0; for (var i = 0; i < k.length; i++) s = (s * 31 + k.charCodeAt(i)) % 360; return s; }
        cards.forEach(function (c) { c.style.setProperty('--h', hue(c.getAttribute('data-cat') || '')); });

        /* Stock meters: relative to the best-stocked tool in the catalog */
        var qty = cards.map(function (c) { return parseInt(c.querySelector('.stock-num').textContent, 10) || 0; });
        var max = Math.max.apply(null, qty.concat([1]));
        cards.forEach(function (c, i) {
            var p = qty[i] / max, bar = c.querySelector('.meter i');
            bar.style.background = qty[i] === 0 ? '#ef4444' : p > .3 ? '#10b981' : '#f59e0b';
            setTimeout(function () { bar.style.width = (p * 100) + '%'; }, 150 + i * 30);
        });

        /* Hero stats */
        var avail = cards.filter(function (c) { return c.getAttribute('data-ok') === '1'; }).length;
        document.getElementById('heroStats').innerHTML =
            '<span>' + cards.length + ' tools</span><span>' + avail + ' ready to borrow</span><span>' + cats.length + ' categories</span>';

        /* Category pills */
        function pill(label, val) {
            var b = document.createElement('button'); b.type = 'button'; b.className = 'pill' + (val === '' ? ' on' : ''); b.textContent = label;
            b.addEventListener('click', function () {
                activeCat = val;
                Array.prototype.forEach.call(pills.children, function (x) { x.classList.remove('on'); }); b.classList.add('on');
                apply();
            });
            pills.appendChild(b);
        }
        if (cats.length > 1) { pill('All', ''); cats.forEach(function (c) { if (c) pill(c, c); }); }

        function apply() {
            var q = search.value.toLowerCase().trim(), shown = 0;
            cards.forEach(function (c) {
                var cat = c.getAttribute('data-cat') || '', name = c.getAttribute('data-name') || '';
                var hit = (!q || (name + ' ' + cat).toLowerCase().indexOf(q) > -1) && (!activeCat || cat === activeCat) && (!only.checked || c.getAttribute('data-ok') === '1');
                c.classList.toggle('gone', !hit); if (hit) shown++;
            });
            document.getElementById('noResults').style.display = shown || !cards.length ? 'none' : 'block';
        }
        search.addEventListener('input', apply);
        search.addEventListener('keydown', function (e) { if (e.key === 'Enter') e.preventDefault(); });
        only.addEventListener('change', apply);
    })();
    </script>
</asp:Content>
