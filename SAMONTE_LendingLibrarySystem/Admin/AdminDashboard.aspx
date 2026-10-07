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

        /* KPI tiles */
        .kpis { display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr)); gap: 18px; margin-bottom: 18px; }
        .kpi {
            --c: var(--primary); position: relative; overflow: hidden; padding: 20px 20px 18px; border-radius: var(--radius);
            background: var(--surface); border: 1px solid var(--line); box-shadow: var(--shadow);
            transition: transform .25s, box-shadow .25s;
        }
        .kpi:hover { transform: translateY(-5px); box-shadow: 0 16px 34px color-mix(in srgb, var(--c) 28%, transparent); }
        .kpi::after { content: ""; position: absolute; right: -28px; bottom: -28px; width: 100px; height: 100px; border-radius: 50%; background: color-mix(in srgb, var(--c) 14%, transparent); }
        .kpi-ico { width: 44px; height: 44px; border-radius: 14px; display: grid; place-items: center; color: #fff; margin-bottom: 14px; background: linear-gradient(135deg, var(--c), color-mix(in srgb, var(--c) 55%, #fff)); box-shadow: 0 8px 18px color-mix(in srgb, var(--c) 40%, transparent); }
        .kpi h4 { color: var(--muted); font-size: 12.5px; font-weight: 700; letter-spacing: .07em; text-transform: uppercase; }
        .kpi-value { display: block; font-size: 32px; font-weight: 800; letter-spacing: -.02em; margin-top: 4px; position: relative; z-index: 1; font-variant-numeric: tabular-nums; }
        .kpi.alert-kpi.hot { animation: pulse 2.2s ease-in-out infinite; }
        @keyframes pulse { 50% { box-shadow: 0 0 0 6px color-mix(in srgb, var(--c) 18%, transparent), var(--shadow); } }

        /* Money tiles */
        .money { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 18px; margin-bottom: 24px; }
        .money .kpi-value { font-size: 27px; }

        /* Rings / charts */
        .viz { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 22px; margin-bottom: 24px; }
        .viz .card { margin-bottom: 0; }
        .ring-box { display: flex; align-items: center; gap: 22px; flex-wrap: wrap; }
        .ring { position: relative; width: 150px; height: 150px; flex: none; }
        .ring svg { transform: rotate(-90deg); width: 100%; height: 100%; }
        .ring .track { stroke: var(--surface-2); }
        .ring .arc { transition: stroke-dashoffset 1.2s cubic-bezier(.2,.8,.2,1); }
        .ring-center { position: absolute; inset: 0; display: grid; place-content: center; text-align: center; }
        .ring-center b { font-size: 26px; letter-spacing: -.02em; }
        .ring-center small { color: var(--muted); font-size: 11.5px; }
        .legend { display: grid; gap: 10px; font-size: 14px; }
        .legend div { display: flex; align-items: center; gap: 10px; }
        .legend i { width: 12px; height: 12px; border-radius: 4px; display: inline-block; }
        .legend span { color: var(--muted); }

        /* Data bars inside the Popular Tools table */
        .bar-cell { display: flex; align-items: center; gap: 10px; min-width: 130px; }
        .bar-cell .bar { flex: 1; height: 8px; border-radius: 999px; background: var(--line); overflow: hidden; }
        .bar-cell .bar i { display: block; height: 100%; width: 0; border-radius: inherit; background: linear-gradient(90deg, var(--primary), var(--primary-2)); transition: width 1s cubic-bezier(.2,.8,.2,1); }
        .bar-cell b { min-width: 24px; text-align: right; font-variant-numeric: tabular-nums; }

        .late { font-weight: 700; padding: 4px 10px; border-radius: 8px; }
        .late-1 { color: var(--warn); background: var(--warn-soft); }
        .late-2 { color: var(--danger); background: var(--danger-soft); }
        .late-3 { color: #fff; background: var(--danger); }
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

    <!-- KPI Row 1: Operations -->
    <div class="kpis">
        <div class="kpi" style="--c:#4f46e5">
            <div class="kpi-ico"><svg class="ico"><use href="#i-tool" /></svg></div>
            <h4>Total Tools</h4>
            <asp:Label ID="lblTotalTools" runat="server" CssClass="kpi-value count-up" Text="0"></asp:Label>
        </div>

        <div class="kpi" style="--c:#0284c7">
            <div class="kpi-ico"><svg class="ico"><use href="#i-repeat" /></svg></div>
            <h4>Active Borrows</h4>
            <asp:Label ID="lblActiveBorrows" runat="server" CssClass="kpi-value count-up" Text="0"></asp:Label>
        </div>

        <div class="kpi alert-kpi" id="kpiOverdue" style="--c:#dc2626">
            <div class="kpi-ico"><svg class="ico"><use href="#i-clock" /></svg></div>
            <h4>Overdue Loans</h4>
            <asp:Label ID="lblOverdueLoans" runat="server" CssClass="kpi-value count-up" ForeColor="#dc2626" Text="0"></asp:Label>
        </div>

        <div class="kpi" style="--c:#f59e0b">
            <div class="kpi-ico"><svg class="ico"><use href="#i-inbox" /></svg></div>
            <h4>Pending Requests</h4>
            <asp:Label ID="lblPendingReservations" runat="server" CssClass="kpi-value count-up" Text="0"></asp:Label>
        </div>
    </div>

    <!-- KPI Row 2: Financials & Maintenance -->
    <div class="money">
        <div class="kpi" style="--c:#dc2626">
            <div class="kpi-ico"><svg class="ico"><use href="#i-alert" /></svg></div>
            <h4>Outstanding Unpaid Fines</h4>
            <asp:Label ID="lblUnpaidFines" runat="server" CssClass="kpi-value count-up" ForeColor="#dc2626" Text="₱0.00"></asp:Label>
        </div>

        <div class="kpi" style="--c:#059669">
            <div class="kpi-ico"><svg class="ico"><use href="#i-trend" /></svg></div>
            <h4>Total Revenue Collected</h4>
            <asp:Label ID="lblCollectedFines" runat="server" CssClass="kpi-value count-up" ForeColor="#059669" Text="₱0.00"></asp:Label>
        </div>

        <div class="kpi" style="--c:#d97706">
            <div class="kpi-ico"><svg class="ico"><use href="#i-tool" /></svg></div>
            <h4>Damaged / Maintenance Items</h4>
            <asp:Label ID="lblDamagedItems" runat="server" CssClass="kpi-value count-up" ForeColor="#ca8a04" Text="0"></asp:Label>
        </div>
    </div>

    <!-- Visual summaries (drawn client-side from the numbers above) -->
    <div class="viz">
        <div class="card">
            <h3>Loan Health</h3>
            <div class="ring-box">
                <div class="ring">
                    <svg viewBox="0 0 120 120">
                        <circle class="track" cx="60" cy="60" r="50" fill="none" stroke-width="14"></circle>
                        <circle class="arc" id="arcHealth" cx="60" cy="60" r="50" fill="none" stroke="#10b981" stroke-width="14" stroke-linecap="round" stroke-dasharray="314.16" stroke-dashoffset="314.16"></circle>
                    </svg>
                    <div class="ring-center"><b id="healthPct">&ndash;</b><small>on time</small></div>
                </div>
                <div class="legend">
                    <div><i style="background:#10b981"></i>On-time loans <span id="lgOnTime">0</span></div>
                    <div><i style="background:var(--line)"></i>Overdue <span id="lgLate">0</span></div>
                </div>
            </div>
        </div>

        <div class="card">
            <h3>Fines Collection</h3>
            <div class="ring-box">
                <div class="ring">
                    <svg viewBox="0 0 120 120">
                        <circle class="track" cx="60" cy="60" r="50" fill="none" stroke-width="14"></circle>
                        <circle class="arc" id="arcFines" cx="60" cy="60" r="50" fill="none" stroke="#6366f1" stroke-width="14" stroke-linecap="round" stroke-dasharray="314.16" stroke-dashoffset="314.16"></circle>
                    </svg>
                    <div class="ring-center"><b id="finePct">&ndash;</b><small>collected</small></div>
                </div>
                <div class="legend">
                    <div><i style="background:#6366f1"></i>Collected <span id="lgPaid">₱0.00</span></div>
                    <div><i style="background:var(--line)"></i>Outstanding <span id="lgUnpaid">₱0.00</span></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Grid Analytics Row 1 -->
    <div class="grid-2" style="margin-bottom: 22px;">
        <!-- Top Borrowed Tools -->
        <div class="card">
            <div class="card-head"><h3>Most Popular Tools</h3></div>
            <asp:GridView ID="gvPopularTools" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No borrow history recorded yet.">
                <Columns>
                    <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                    <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                    <asp:BoundField DataField="TimesBorrowed" HeaderText="Total Borrows" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- Overdue Watchlist -->
        <div class="card">
            <div class="card-head"><h3 style="color: var(--danger);">Overdue Loans Watchlist</h3></div>
            <asp:GridView ID="gvOverdueWatchlist" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No overdue loans at this time.">
                <Columns>
                    <asp:BoundField DataField="Borrower" HeaderText="Borrower" />
                    <asp:BoundField DataField="ToolName" HeaderText="Tool" />
                    <asp:BoundField DataField="ExpectedReturnDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="DaysOverdue" HeaderText="Days Late" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Grid Analytics Row 2 -->
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

    <script>
    (function () {
        var $ = function (s) { return document.querySelector(s); };
        var num = function (id) {
            var el = document.querySelector('[id$="' + id + '"]');
            return el ? (parseFloat(el.textContent.replace(/[^\d.\-]/g, '')) || 0) : 0;
        };
        var money = function (v) { return '₱' + v.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }); };

        /* Greeting */
        var h = new Date().getHours(), part = h < 12 ? 'Good morning' : h < 18 ? 'Good afternoon' : 'Good evening';
        var who = ($('#meName') || {}).textContent || 'Admin';
        $('#heroGreeting').textContent = part + ', ' + who.trim().split(' ')[0] + ' 👋';

        /* Overdue tile pulses only when there is something overdue */
        var active = num('lblActiveBorrows'), late = num('lblOverdueLoans');
        if (late > 0) $('#kpiOverdue').classList.add('hot');

        /* Rings */
        var C = 314.16;
        function ring(arcId, pctId, pct) {
            var arc = $(arcId), t = $(pctId);
            t.textContent = Math.round(pct * 100) + '%';
            requestAnimationFrame(function () { setTimeout(function () { arc.style.strokeDashoffset = C * (1 - pct); }, 120); });
        }
        var onTime = Math.max(active - late, 0);
        ring('#arcHealth', '#healthPct', active > 0 ? onTime / active : 1);
        $('#lgOnTime').textContent = onTime; $('#lgLate').textContent = late;

        var unpaid = num('lblUnpaidFines'), paid = num('lblCollectedFines');
        ring('#arcFines', '#finePct', (paid + unpaid) > 0 ? paid / (paid + unpaid) : 0);
        $('#lgPaid').textContent = money(paid); $('#lgUnpaid').textContent = money(unpaid);

        /* Popular tools: turn the borrow count into a bar + number */
        function colIndex(tbl, re) {
            var ths = tbl.querySelectorAll('th');
            for (var i = 0; i < ths.length; i++) if (re.test(ths[i].textContent)) return i;
            return -1;
        }
        var pop = document.querySelector('[id$="gvPopularTools"]');
        if (pop) {
            var ci = colIndex(pop, /borrows/i), rows = Array.prototype.slice.call(pop.querySelectorAll('tr')).filter(function (r) { return r.querySelector('td'); });
            if (ci > -1 && rows.length) {
                var vals = rows.map(function (r) { return parseFloat(r.children[ci].textContent) || 0; }), max = Math.max.apply(null, vals) || 1;
                rows.forEach(function (r, i) {
                    r.children[ci].innerHTML = '<div class="bar-cell"><div class="bar"><i></i></div><b>' + vals[i] + '</b></div>';
                    var fill = r.children[ci].querySelector('i');
                    setTimeout(function () { fill.style.width = (vals[i] / max * 100) + '%'; }, 150 + i * 70);
                });
            }
        }

        /* Overdue watchlist: severity-colored "days late" chips */
        var ow = document.querySelector('[id$="gvOverdueWatchlist"]');
        if (ow) {
            var di = colIndex(ow, /days late/i);
            if (di > -1) Array.prototype.slice.call(ow.querySelectorAll('tr')).forEach(function (r) {
                if (!r.querySelector('td')) return;
                var d = parseInt(r.children[di].textContent, 10);
                if (isNaN(d)) return;
                var sev = d >= 14 ? 3 : d >= 7 ? 2 : 1;
                r.children[di].innerHTML = '<span class="late late-' + sev + '">' + d + (d === 1 ? ' day' : ' days') + '</span>';
            });
        }
    })();
    </script>
</asp:Content>
