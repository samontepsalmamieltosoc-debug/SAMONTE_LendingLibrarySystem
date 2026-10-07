<%@ Page Title="Admin Analytics Dashboard" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Hero */
        .hero {
            position: relative; overflow: hidden; border-radius: 22px; padding: 30px 34px; margin-bottom: 24px; color: #fff;
            background: linear-gradient(120deg, #4338ca 0%, #7c3aed 55%, #db2777 120%);
            box-shadow: 0 18px 40px rgba(79,70,229,.35);
        }
        .hero::before, .hero::after { content: ""; position: absolute; border-radius: 50%; background: rgba(255,255,255,.12); }
        .hero::before { width: 260px; height: 260px; right: -60px; top: -90px; animation: drift 9s ease-in-out infinite; }
        .hero::after  { width: 160px; height: 160px; right: 150px; bottom: -80px; background: rgba(255,255,255,.08); animation: drift 12s ease-in-out infinite reverse; }
        @keyframes drift { 50% { transform: translate(-18px, 14px) scale(1.06); } }
        .hero h2 { font-size: 28px; position: relative; z-index: 1; }
        .hero p { margin: 8px 0 0; opacity: .88; max-width: 560px; position: relative; z-index: 1; }
        .hero-pills { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 18px; position: relative; z-index: 1; }
        .hero-pill { background: rgba(255,255,255,.17); backdrop-filter: blur(6px); border: 1px solid rgba(255,255,255,.25); padding: 7px 14px; border-radius: 999px; font-size: 13px; font-weight: 600; }
        .hero-pill a { color: #fff; text-decoration: none; }

        /* Charts. Two series colors only: blue = the normal side, orange = what needs attention (same meaning in every chart). */
        .chart-row { margin-bottom: 22px; }
        .chart-card {
            --series-1: #2a78d6; --series-2: #eb6834;
            --axis: color-mix(in srgb, var(--muted) 40%, var(--line));
        }
        [data-theme="dark"] .chart-card { --series-1: #3987e5; --series-2: #d95926; }
        .viz-empty { margin: 0; padding: 18px 0 6px; color: var(--muted); font-size: 13.5px; }

        /* Horizontal bars: one baseline, thin bars, value at the tip */
        .hb { display: grid; gap: 10px; margin-top: 14px; }
        .hb-row { display: grid; grid-template-columns: minmax(96px, 36%) minmax(0, 1fr); align-items: center; gap: 12px; padding: 3px 6px; margin: 0 -6px; border-radius: 10px; }
        .hb-row:hover, .hb-row:focus-visible { background: var(--surface-2); outline: none; }
        .hb-label { font-size: 13.5px; overflow-wrap: anywhere; }
        .hb-label small { display: block; color: var(--muted); font-size: 12px; text-transform: capitalize; }
        .hb-track { display: flex; align-items: center; gap: 8px; min-width: 0; height: 24px; border-left: 1px solid var(--axis); }
        .hb-bar { flex: none; height: 16px; border-radius: 0 4px 4px 0; background: var(--series-1); }
        .hb-bar.s2 { background: var(--series-2); }
        .hb-row:hover .hb-bar, .hb-row:focus-visible .hb-bar { filter: brightness(1.12); }
        .hb-val { flex: none; font-size: 13px; font-weight: 700; padding-left: 2px; font-variant-numeric: tabular-nums; }
        .hb-row .hb-label { text-transform: capitalize; }

        /* Part-to-whole: 100% stacked bars with a 2px gap between segments */
        .sb { display: grid; gap: 22px; margin-top: 14px; }
        .sb-head { display: flex; justify-content: space-between; align-items: baseline; gap: 10px; margin-bottom: 8px; font-size: 13.5px; }
        .sb-head span { color: var(--muted); font-size: 12.5px; }
        .sb-bar { display: flex; gap: 2px; height: 18px; }
        .sb-seg { min-width: 4px; border-radius: 4px; background: var(--series-1); }
        .sb-seg.s2 { background: var(--series-2); }
        .sb-seg:hover, .sb-seg:focus-visible { filter: brightness(1.12); outline: none; }
        .sb-empty { flex: 1; border-radius: 4px; background: var(--surface-2); border: 1px solid var(--line); }
        .sb-legend, .legend-row { display: flex; gap: 8px 18px; flex-wrap: wrap; margin-top: 8px; font-size: 12.5px; color: var(--muted); }
        .sb-legend i, .legend-row i { display: inline-block; width: 10px; height: 10px; margin-right: 6px; border-radius: 3px; background: var(--series-1); vertical-align: -1px; }
        .sb-legend i.s2, .legend-row i.s2 { background: var(--series-2); }
        .sb-legend b { margin-left: 5px; color: var(--text); font-weight: 700; }
        .legend-row { margin-top: 14px; }

        .viz-tip { position: fixed; z-index: 200; left: 0; top: 0; pointer-events: none; opacity: 0; padding: 8px 12px; border-radius: 10px; background: var(--surface); color: var(--text); border: 1px solid var(--line); box-shadow: var(--shadow); font-size: 12.5px; max-width: 280px; }
        .viz-tip.on { opacity: 1; }
        .viz-tip strong { display: block; font-size: 15px; }
        .viz-tip span { color: var(--muted); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero -->
    <div class="hero">
        <h2 id="heroGreeting">Analytics &amp; System Overview</h2>
        <p>Here's what's happening across the lending library right now: stock, loans, requests and money, all in one place.</p>
        <div class="hero-pills">
            <span class="hero-pill"><a href="ManageRequests.aspx">Review pending requests &rarr;</a></span>
            <span class="hero-pill"><a href="ManageDamagedItems.aspx">Assess a damage fine &rarr;</a></span>
            <span class="hero-pill"><a href="Inventory.aspx">Add a tool &rarr;</a></span>
        </div>
    </div>

    <!-- Row 1: where things stand -->
    <div class="grid-2 chart-row">
        <div class="card chart-card">
            <div class="card-head">
                <div>
                    <h3>Library at a glance</h3>
                    <p class="card-sub">Current counts. Orange marks what needs your attention.</p>
                </div>
            </div>
            <div id="chGlance"></div>
            <div class="legend-row"><span><i></i>Overview</span><span><i class="s2"></i>Needs attention</span></div>
        </div>

        <div class="card chart-card">
            <div class="card-head">
                <div>
                    <h3>Health check</h3>
                    <p class="card-sub">How much of each is in good shape.</p>
                </div>
            </div>
            <div id="chHealth"></div>
        </div>
    </div>

    <!-- Row 2: what is busy, what is late -->
    <div class="grid-2 chart-row">
        <div class="card chart-card">
            <div class="card-head">
                <div>
                    <h3>Most popular tools</h3>
                    <p class="card-sub">Times each tool has been borrowed, top five.</p>
                </div>
            </div>
            <div id="chPopular"></div>
        </div>

        <div class="card chart-card">
            <div class="card-head">
                <div>
                    <h3>Overdue loans</h3>
                    <p class="card-sub">Days past the due date, longest first.</p>
                </div>
            </div>
            <div id="chOverdue"></div>
        </div>
    </div>

    <!-- Recent activity stays a table: it is a list to look things up in, not a number to chart -->
    <div class="card">
        <div class="card-head"><h3>Recent Transactions Activity</h3></div>
        <asp:GridView ID="gvRecentTransactions" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No recent transactions found.">
            <Columns>
                <asp:BoundField DataField="TransactionID" HeaderText="Tx ID" />
                <asp:BoundField DataField="Borrower" HeaderText="Borrower" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                <asp:BoundField DataField="BorrowDate" HeaderText="Borrow Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:BoundField DataField="TransactionStatus" HeaderText="Status" />
            </Columns>
        </asp:GridView>
    </div>

    <asp:Literal ID="litDashData" runat="server" Mode="PassThrough"></asp:Literal>

    <script>
    (function () {
        var $ = function (id) { return document.getElementById(id); };

        /* Greeting */
        var h = new Date().getHours(), part = h < 12 ? 'Good morning' : h < 18 ? 'Good afternoon' : 'Good evening';
        var who = ($('meName') || {}).textContent || 'Admin';
        $('heroGreeting').textContent = part + ', ' + who.trim().split(' ')[0] + ' \uD83D\uDC4B';

        /* Data from the server (sp_GetDashboardAnalytics) */
        var D = {};
        try { D = JSON.parse($('dashData').textContent); } catch (e) { D = {}; }
        var M = D.metrics || {};
        var n = function (v) { return Math.max(parseInt(v, 10) || 0, 0); };
        var peso = function (v) { return '\u20B1' + (+v || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }); };
        var plural = function (c, one, many) { return c + ' ' + (c === 1 ? one : many); };

        function el(tag, cls, text) {
            var e = document.createElement(tag);
            if (cls) e.className = cls;
            if (text !== undefined) e.textContent = text;
            return e;
        }

        /* One tooltip for every mark. Names come from the database, so text only, never innerHTML. */
        var tip = el('div', 'viz-tip');
        document.body.appendChild(tip);
        function tipHide() { tip.classList.remove('on'); }
        function attachTip(node, value, label) {
            node.tabIndex = 0;
            node.setAttribute('role', 'img');
            node.setAttribute('aria-label', label + ': ' + value);
            function show(x, y) {
                tip.textContent = '';
                tip.appendChild(el('strong', '', value));
                tip.appendChild(el('span', '', label));
                tip.classList.add('on');
                var w = tip.offsetWidth, hgt = tip.offsetHeight;
                tip.style.left = Math.max(8, Math.min(x + 14, window.innerWidth - w - 8)) + 'px';
                tip.style.top = Math.max(8, Math.min(y - hgt - 12, window.innerHeight - hgt - 8)) + 'px';
            }
            node.addEventListener('pointermove', function (e) { show(e.clientX, e.clientY); });
            node.addEventListener('pointerleave', tipHide);
            node.addEventListener('focus', function () { var r = node.getBoundingClientRect(); show(r.left + r.width / 2, r.top); });
            node.addEventListener('blur', tipHide);
        }

        /* Horizontal bar chart. rows: { label, sub, v, text, tip, s } with s = 2 for the "needs attention" color. */
        function hbar(host, rows, opts) {
            host.textContent = '';
            if (!rows.length) { host.appendChild(el('p', 'viz-empty', opts.empty)); return; }
            var max = Math.max.apply(null, rows.map(function (r) { return r.v; })) || 1;
            var wrap = el('div', 'hb');
            rows.forEach(function (r) {
                var row = el('div', 'hb-row'), lab = el('div', 'hb-label', r.label);
                if (r.sub) lab.appendChild(el('small', '', r.sub));
                var track = el('div', 'hb-track'), bar = el('div', 'hb-bar' + (r.s === 2 ? ' s2' : ''));
                bar.style.width = 'calc((100% - ' + (opts.pad || 48) + 'px) * ' + (r.v / max) + ')';
                track.appendChild(bar);
                track.appendChild(el('span', 'hb-val', r.text));
                row.appendChild(lab);
                row.appendChild(track);
                attachTip(row, r.text, r.tip);
                wrap.appendChild(row);
            });
            host.appendChild(wrap);
        }

        /* Stacked part-to-whole bars. rows: { title, total, of, parts: [{ label, v, text, s }] } */
        function sbar(host, rows) {
            host.textContent = '';
            var wrap = el('div', 'sb');
            rows.forEach(function (r) {
                var total = r.parts.reduce(function (a, p) { return a + p.v; }, 0);
                var head = el('div', 'sb-head'), bar = el('div', 'sb-bar'), legend = el('div', 'sb-legend');
                head.appendChild(el('b', '', r.title));
                head.appendChild(el('span', '', total ? r.total : 'None yet'));
                if (!total) bar.appendChild(el('div', 'sb-empty'));
                r.parts.forEach(function (p) {
                    var share = total ? Math.round(p.v / total * 100) : 0;
                    var shown = p.v > 0 && share === 0 ? '<1' : String(share);   /* never show a real amount as 0% */
                    if (p.v > 0) {
                        var seg = el('div', 'sb-seg' + (p.s === 2 ? ' s2' : ''));
                        seg.style.flex = p.v + ' 1 0';
                        attachTip(seg, p.text, p.label + ' - ' + shown + '% of ' + r.of);
                        bar.appendChild(seg);
                    }
                    var key = el('span');
                    key.appendChild(el('i', p.s === 2 ? 's2' : ''));
                    key.appendChild(document.createTextNode(p.label));
                    key.appendChild(el('b', '', p.text + ' (' + shown + '%)'));
                    legend.appendChild(key);
                });
                var block = el('div');
                block.appendChild(head); block.appendChild(bar); block.appendChild(legend);
                wrap.appendChild(block);
            });
            host.appendChild(wrap);
        }

        /* 1. Library at a glance */
        var active = n(M.activeBorrows), late = n(M.overdueLoans), tools = n(M.totalTools), damaged = Math.min(n(M.damagedItems), tools);
        function glance(label, v, unit, s) { return { label: label, v: v, text: String(v), tip: label + ' (' + unit + ')', s: s }; }
        hbar($('chGlance'), [
            glance('Total tools', tools, 'tools in the catalog', 1),
            glance('Active borrows', active, 'loans out right now', 1),
            glance('Overdue loans', late, 'loans past their due date', 2),
            glance('Pending requests', n(M.pendingReservations), 'waiting for approval', 2),
            glance('Damaged tools', damaged, 'tools flagged damaged', 2)
        ], { empty: 'No data yet.' });

        /* 2. Health check */
        var paid = +M.collectedFines || 0, unpaid = +M.unpaidFines || 0;
        sbar($('chHealth'), [
            { title: 'Active loans', total: plural(active, 'loan', 'loans'), of: 'active loans', parts: [
                { label: 'On time', v: Math.max(active - late, 0), text: String(Math.max(active - late, 0)), s: 1 },
                { label: 'Overdue', v: Math.min(late, active), text: String(Math.min(late, active)), s: 2 }] },
            { title: 'Tool condition', total: plural(tools, 'tool', 'tools'), of: 'all tools', parts: [
                { label: 'Good', v: tools - damaged, text: String(tools - damaged), s: 1 },
                { label: 'Damaged', v: damaged, text: String(damaged), s: 2 }] },
            { title: 'Fines', total: peso(paid + unpaid) + ' assessed', of: 'all fines', parts: [
                { label: 'Collected', v: paid, text: peso(paid), s: 1 },
                { label: 'Outstanding', v: unpaid, text: peso(unpaid), s: 2 }] }
        ]);

        /* 3. Most popular tools (only tools that have actually been borrowed) */
        hbar($('chPopular'), (D.popular || []).filter(function (t) { return n(t.borrows) > 0; }).map(function (t) {
            var c = n(t.borrows);
            return { label: t.name, sub: t.category, v: c, text: String(c), tip: t.name + ' - ' + plural(c, 'borrow', 'borrows'), s: 1 };
        }), { empty: 'No borrow history recorded yet.' });

        /* 4. Overdue loans, longest first; the rest are summarised so the card stays readable */
        var od = D.overdue || [], SHOW = 8;
        hbar($('chOverdue'), od.slice(0, SHOW).map(function (o) {
            var d = n(o.days);
            return { label: o.tool, sub: o.borrower, v: d, text: plural(d, 'day', 'days'), tip: o.tool + ' - ' + o.borrower, s: 2 };
        }), { empty: 'No overdue loans at this time.', pad: 84 });
        if (od.length > SHOW) $('chOverdue').appendChild(el('p', 'viz-empty', '+' + (od.length - SHOW) + ' more overdue loans not shown.'));
    })();
    </script>
</asp:Content>
