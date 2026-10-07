<%@ Page Title="Returned Items Log" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="ReturnedItems.aspx.cs" Inherits="SAMONTE_LendingLibrarySystem.Admin.ReturnedItems" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .late-tag { margin-left: 8px; font-size: 11.5px; font-weight: 700; padding: 3px 9px; border-radius: 999px; color: var(--danger); background: var(--danger-soft); white-space: nowrap; }
        .ontime-tag { margin-left: 8px; font-size: 11.5px; font-weight: 700; padding: 3px 9px; border-radius: 999px; color: var(--success); background: var(--success-soft); white-space: nowrap; }

        .btn-ghost {
            display: inline-flex; align-items: center; justify-content: center; gap: 8px; padding: 7px 13px; border: 1px solid var(--line); border-radius: 10px;
            background: var(--surface-2); color: var(--text); font: inherit; font-size: 13px; font-weight: 600; cursor: pointer; transition: border-color .15s, color .15s;
        }
        .btn-ghost:hover { border-color: var(--primary); color: var(--primary); }

        /* Assessment modal. The master's entrance animation on .container would trap position:fixed inside the container, so it is switched off here. */
        .container { animation: none; }
        .am-backdrop { position: fixed; inset: 0; z-index: 100; display: flex; align-items: center; justify-content: center; padding: 20px; overflow-y: auto; background: rgba(11,13,28,.55); backdrop-filter: blur(3px); }
        .am-backdrop[hidden] { display: none; }
        .am-dialog { position: relative; width: min(620px, 100%); max-height: calc(100vh - 40px); overflow-y: auto; background: var(--surface); border: 1px solid var(--line); border-radius: var(--radius); box-shadow: 0 30px 80px rgba(0,0,0,.35); padding: 26px; }
        .am-dialog:focus { outline: none; }
        .am-dialog h3 { font-size: 19px; margin: 0 44px 4px 0; }
        .am-close { position: absolute; top: 14px; right: 14px; width: 36px; height: 36px; border-radius: 10px; border: 1px solid var(--line); background: var(--surface-2); color: var(--text); font-size: 22px; line-height: 1; cursor: pointer; }
        .am-close:hover { color: var(--primary); border-color: var(--primary); }

        .am-media { --h: 175; margin: 16px 0; border-radius: 14px; border: 1px solid var(--line); background: var(--surface-2); overflow: hidden; }
        .am-media img { display: block; width: 100%; max-height: 220px; object-fit: contain; }
        .am-tile { height: 92px; display: grid; place-items: center; color: #fff; font-size: 44px; font-weight: 800; background: linear-gradient(135deg, hsl(var(--h) 70% 38%), hsl(calc(var(--h) + 40) 75% 50%)); }
        .am-media p { margin: 0; padding: 9px 14px; font-size: 12.5px; color: var(--muted); }

        .am-facts { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 8px; margin: 0 0 14px; }
        .am-facts > div { background: var(--surface-2); border: 1px solid var(--line); border-radius: 12px; padding: 10px 12px; min-width: 0; }
        .am-facts dt { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .08em; color: var(--muted); margin-bottom: 3px; }
        .am-facts dd { margin: 0; font-weight: 600; overflow-wrap: anywhere; }
        #amName { text-transform: capitalize; }

        .am-notice { margin: 0 0 16px; padding: 10px 14px; border-radius: 12px; font-size: 13.5px; font-weight: 600; }
        .am-notice[hidden] { display: none; }
        .am-notice.info { color: var(--info); background: var(--info-soft); }
        .am-notice.locked { color: var(--warn); background: var(--warn-soft); }
        .am-actions { display: flex; gap: 10px; flex-wrap: wrap; }
        .am-actions .btn-ok, .am-actions .btn-no { flex: 1 1 180px; padding: 12px; }
        .am-actions input[disabled] { opacity: .5; cursor: not-allowed; transform: none; filter: none; }
        body.am-open { overflow: hidden; }
        @media (max-width: 560px) { .am-facts { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Returned Items History</h2>

    <asp:Label ID="lblMsg" runat="server" Font-Bold="true"></asp:Label>

    <div class="card">
        <div class="card-head">
            <div>
                <h3>Completed & Returned Tool Loans</h3>
                <p class="card-sub">Every finished loan, with a quick on-time / late check against the due date. Open an item to check it and decide whether it came back Good or Damaged.</p>
            </div>
        </div>
        <asp:GridView ID="gvReturnedItems" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="No returned items recorded yet.">
            <Columns>
                <asp:BoundField DataField="TransactionID" HeaderText="Tx ID" />
                <asp:BoundField DataField="BorrowerName" HeaderText="Borrower" />
                <asp:BoundField DataField="ToolName" HeaderText="Tool Name" />
                <asp:BoundField DataField="BorrowDate" HeaderText="Borrow Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="ExpectedReturnDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="ActualReturnDate" HeaderText="Return Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:TemplateField HeaderText="Assessment">
                    <ItemTemplate>
                        <div class="assess-cell">
                            <%# AssessmentBadge(Eval("AssessedCondition")) %>
                            <button type="button" class='<%# IsAssessed(Eval("AssessedCondition")) ? "btn-ghost js-assess" : "btn btn-sm js-assess" %>'
                                data-tx='<%#: Eval("TransactionID") %>'
                                data-tool='<%#: Eval("ToolID") %>'
                                data-name='<%#: Eval("ToolName") %>'
                                data-cat='<%#: Eval("CategoryName") %>'
                                data-borrower='<%#: Eval("BorrowerName") %>'
                                data-borrowed='<%#: Eval("BorrowDate", "{0:yyyy-MM-dd}") %>'
                                data-due='<%#: Eval("ExpectedReturnDate", "{0:yyyy-MM-dd}") %>'
                                data-returned='<%#: Eval("ActualReturnDate", "{0:yyyy-MM-dd HH:mm}") %>'
                                data-cond='<%#: Eval("AssessedCondition") %>'
                                data-fined='<%#: Eval("HasFine") %>'
                                data-photo='<%#: ResolveImage(Eval("ReturnImagePath")) %>'
                                data-toolimg='<%#: ResolveImage(Eval("ImageURL")) %>'>
                                <%# IsAssessed(Eval("AssessedCondition")) ? "Review" : "Assess Item" %>
                            </button>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- Assessment modal: filled in by the script below from the clicked row, decided with the two buttons at the bottom -->
    <div class="am-backdrop" id="amBackdrop" hidden>
        <div class="am-dialog" role="dialog" aria-modal="true" aria-labelledby="amTitle" tabindex="-1">
            <button type="button" class="am-close" id="amClose" aria-label="Close">&times;</button>
            <h3 id="amTitle">Assess returned item</h3>
            <p class="card-sub">Check the item as it came back, then decide whether it is Good or Damaged.</p>

            <div class="am-media" id="amMedia">
                <img id="amImg" alt="" hidden />
                <div class="am-tile" id="amTile"><span id="amInitial"></span></div>
                <p id="amMediaNote"></p>
            </div>

            <dl class="am-facts">
                <div><dt>Item ID</dt><dd id="amToolId"></dd></div>
                <div><dt>Item</dt><dd id="amName"></dd></div>
                <div><dt>Category</dt><dd id="amCat"></dd></div>
                <div><dt>Borrower</dt><dd id="amBorrower"></dd></div>
                <div><dt>Transaction</dt><dd id="amTx"></dd></div>
                <div><dt>Borrowed</dt><dd id="amBorrowed"></dd></div>
                <div><dt>Due date</dt><dd id="amDue"></dd></div>
                <div><dt>Returned</dt><dd id="amReturned"></dd></div>
            </dl>

            <p class="am-notice" id="amNotice" hidden></p>

            <asp:HiddenField ID="hfTxId" runat="server" />
            <div class="am-actions">
                <asp:Button ID="btnMarkGood" runat="server" Text="Mark as Good" CssClass="btn-ok"
                    OnClick="btnMarkGood_Click" UseSubmitBehavior="false" OnClientClick="amLock(this);" />
                <asp:Button ID="btnMarkDamaged" runat="server" Text="Mark as Damaged" CssClass="btn-no"
                    OnClick="btnMarkDamaged_Click" UseSubmitBehavior="false" OnClientClick="amLock(this);" />
            </div>
        </div>
    </div>

    <script>
    /* Stops a double click while the decision is being saved */
    function amLock(clicked) {
        var all = document.querySelectorAll('.am-actions input');
        for (var i = 0; i < all.length; i++) all[i].disabled = true;
        clicked.value = 'Saving...';
    }

    (function () {
        /* On-time / late tag next to the return date */
        var tbl = document.querySelector('[id$="gvReturnedItems"]');
        if (tbl) {
            var ths = Array.prototype.slice.call(tbl.querySelectorAll('th')).map(function (t) { return t.textContent.trim(); });
            var iDue = ths.indexOf('Due Date'), iRet = ths.indexOf('Return Date');
            if (iDue > -1 && iRet > -1) {
                Array.prototype.slice.call(tbl.querySelectorAll('tr')).forEach(function (r) {
                    if (!r.querySelector('td')) return;
                    var due = Date.parse(r.children[iDue].textContent.trim()), ret = Date.parse(r.children[iRet].textContent.trim().substr(0, 10));
                    if (isNaN(due) || isNaN(ret)) return;
                    var days = Math.round((ret - due) / 86400000), tag = document.createElement('span');
                    tag.className = days > 0 ? 'late-tag' : 'ontime-tag';
                    tag.textContent = days > 0 ? days + 'd late' : 'on time';
                    r.children[iRet].appendChild(tag);
                });
            }
        }

        /* Assessment modal */
        var $ = function (id) { return document.getElementById(id); };
        var back = $('amBackdrop'), dlg = back.querySelector('.am-dialog');
        var hf = document.querySelector('[id$="hfTxId"]');
        var btnGood = document.querySelector('[id$="btnMarkGood"]'), btnBad = document.querySelector('[id$="btnMarkDamaged"]');
        var img = $('amImg'), tile = $('amTile'), media = $('amMedia'), note = $('amNotice');
        var opener = null;

        function hue(k) { var s = 0; for (var i = 0; i < k.length; i++) s = (s * 31 + k.charCodeAt(i)) % 360; return s; }
        function put(id, v) { $(id).textContent = v || '-'; }

        function showTile(text) { img.hidden = true; tile.hidden = false; $('amMediaNote').textContent = text; }
        function showPhoto(src, text) { img.src = src; img.hidden = false; tile.hidden = true; $('amMediaNote').textContent = text; }

        function open(btn) {
            var d = btn.dataset, locked = d.fined === '1';
            opener = btn;
            hf.value = d.tx;

            put('amToolId', '#' + d.tool); put('amName', d.name); put('amCat', d.cat || 'Uncategorized');
            put('amBorrower', d.borrower); put('amTx', '#' + d.tx);
            put('amBorrowed', d.borrowed); put('amDue', d.due); put('amReturned', d.returned);

            media.style.setProperty('--h', hue(d.cat || ''));
            $('amInitial').textContent = (d.name || '?').charAt(0).toUpperCase();
            img.alt = 'Photo of ' + (d.name || 'the item');
            img.onerror = function () { showTile('The photo on file could not be loaded. Inspect the physical item before deciding.'); };
            if (d.photo) showPhoto(d.photo, 'Photo submitted with the return.');
            else if (d.toolimg) showPhoto(d.toolimg, 'No return photo was submitted. Showing the catalog photo of this item.');
            else showTile('No photo is on file for this item. Inspect the physical item before deciding.');

            if (locked) {
                note.className = 'am-notice locked'; note.textContent = 'A fine has already been issued for this return, so the assessment is locked.'; note.hidden = false;
            } else if (d.cond) {
                note.className = 'am-notice info'; note.textContent = 'Current assessment: ' + d.cond + '. You can change it until a fine is issued.'; note.hidden = false;
            } else {
                note.hidden = true;
            }
            btnGood.disabled = btnBad.disabled = locked;
            btnGood.value = 'Mark as Good'; btnBad.value = 'Mark as Damaged';

            back.hidden = false;
            document.body.classList.add('am-open');
            dlg.focus();
        }

        function close() {
            back.hidden = true;
            document.body.classList.remove('am-open');
            if (opener) opener.focus();
        }

        document.addEventListener('click', function (e) {
            var b = e.target.closest ? e.target.closest('.js-assess') : null;
            if (b) { e.preventDefault(); open(b); }
        });
        $('amClose').addEventListener('click', close);
        back.addEventListener('mousedown', function (e) { if (e.target === back) close(); });
        document.addEventListener('keydown', function (e) {
            if (back.hidden) return;
            if (e.key === 'Escape') { close(); return; }
            if (e.key !== 'Tab') return;
            /* Keep Tab inside the dialog */
            var f = Array.prototype.slice.call(dlg.querySelectorAll('button, input, [href]')).filter(function (x) { return !x.disabled && !x.hidden && x.type !== 'hidden'; });
            if (!f.length) { e.preventDefault(); return; }
            var first = f[0], last = f[f.length - 1];
            if (e.shiftKey && (document.activeElement === first || document.activeElement === dlg)) { e.preventDefault(); last.focus(); }
            else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
        });
    })();
    </script>
</asp:Content>
