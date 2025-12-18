<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="urn:svor:functions"
                xmlns:cqt="http://cqt/ComparativeQuantityTakeoff.xsd"
                xmlns:bd="http://types/BaseDocument.xsd"
                xmlns:ct="http://types/CommonTypes.xsd"
                xmlns:bt="http://types/BaseTypes.xsd"
                exclude-result-prefixes="xs f cqt bd ct bt"
                version="2.0">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Schematron отключен -->

  <!-- Утилиты -->

  <xsl:function name="f:quantity" as="xs:decimal?">
    <xsl:param name="item" as="element()"/>
    <xsl:param name="stageId" as="xs:string"/>
    <xsl:variable name="node"
                  select="if ($stageId = 'base')
                          then $item/*:volumeList/*:volume[@alterationRef='base']/*:volumeQuantity
                          else $item/*:volumeList/*:volume[@alterationRef=$stageId]/*:volumeQuantity"/>
    <xsl:sequence select="if ($node) then xs:decimal($node) else ()"/>
  </xsl:function>

  <xsl:function name="f:stage-label" as="xs:string">
    <xsl:param name="stage" as="element()"/>
    <xsl:variable name="year" select="normalize-space($stage/*:year)"/>
    <xsl:variable name="month-raw" select="normalize-space($stage/*:month)"/>
    <xsl:variable name="month"
                  select="if ($month-raw castable as xs:integer)
                          then xs:integer($month-raw)
                          else if (matches($month-raw, '\\d\\d$'))
                               then xs:integer(substring($month-raw, string-length($month-raw) - 1))
                               else ()"/>
    <xsl:variable name="quarter" select="if ($month) then xs:integer(ceiling($month div 3)) else ()"/>
    <xsl:variable name="quarter-roman"
                  select="if ($quarter = 1) then 'I'
                          else if ($quarter = 2) then 'II'
                          else if ($quarter = 3) then 'III'
                          else if ($quarter = 4) then 'IV'
                          else ()"/>
    <xsl:variable name="quarter-label"
                  select="if ($quarter-roman)
                          then concat($quarter-roman, ' квартал')
                          else ''"/>
    <xsl:sequence select="normalize-space(string-join((
                          $quarter-label,
                          if ($year) then concat($year, ' г.') else ''), ' '))"/>
  </xsl:function>

  <xsl:function name="f:full-date" as="xs:string?">
    <xsl:param name="date" as="xs:date?"/>
    <xsl:sequence select="if (exists($date)) then format-date($date, '[D01].[M01].[Y0001]') else ()"/>
  </xsl:function>


  <xsl:function name="f:format" as="xs:string">
    <xsl:param name="value" as="xs:double?"/>
    <xsl:sequence select="if (exists($value)) then format-number(xs:decimal($value), '0.###') else ''"/>
  </xsl:function>

  <xsl:function name="f:tooltip" as="xs:string">
    <xsl:param name="path" as="xs:string"/>
    <xsl:param name="note" as="xs:string"/>
    <xsl:sequence select="concat('Путь: ', $path, '&#10;Назначение: ', $note)"/>
  </xsl:function>

  <xsl:function name="f:link-label" as="xs:string?">

    <xsl:param name="ref" as="element()?"/>

    <xsl:variable name="fileInternalId" select="$ref/*:fileInternalId"/>

    <xsl:variable name="fileName" select="(root($ref)/cqt:comparativeQuantityTakeoff/bd:fileList/bd:file[ct:fileInternalId=$fileInternalId]/ct:fileName)[1]"/>

    <xsl:variable name="fileLabel" select="if ($fileName) then $fileName else concat('Файл #', $fileInternalId)"/>

    <xsl:variable name="pageNumbers" select="$ref/*:pageNumbers"/>

    <xsl:variable name="pageDesc" select="$ref/*:pageDescription"/>

    <xsl:variable name="ifcGuids" select="$ref/*:ifcGuids"/>

    <xsl:variable name="ifcDesc" select="$ref/*:ifcDescription"/>

    <xsl:variable name="propName" select="$ref/*:propertyName"/>

    <xsl:variable name="propDesc" select="$ref/*:propertyDescription"/>

    <xsl:variable name="propValue" select="$ref/*:propertyValue"/>

    <xsl:sequence select="if (not($ref) or not($fileInternalId)) then ''

                          else if ($pageNumbers)

                               then concat($fileLabel,

                                           ' (стр. ', normalize-space(string-join($pageNumbers/*, ' ')), ')',

                                           if ($pageDesc) then concat(' - ', $pageDesc) else '')

                          else if ($ifcGuids)

                               then concat($fileLabel,

                                           ' (IFC ', normalize-space(string-join($ifcGuids/*, ' ')), ')',

                                           if ($ifcDesc) then concat(' — ', $ifcDesc) else '')

                          else if ($propName)

                               then concat($fileLabel,

                                           ' (', $propName,

                                           if ($propValue) then concat('=', $propValue) else '',

                                           ')',

                                           if ($propDesc) then concat(' — ', $propDesc) else '')

                          else $fileLabel"/>

  </xsl:function>

  <xsl:template match="/">
    <xsl:variable name="doc" select="/cqt:comparativeQuantityTakeoff"/>
    <xsl:variable name="stages" select="$doc/bd:alterationList/bd:alteration"/>
    <xsl:variable name="stages-order" as="element()*">
      <xsl:perform-sort select="$stages">
        <xsl:sort select="number(ct:year)" data-type="number" order="ascending"/>
        <xsl:sort select="number(substring(normalize-space(ct:month), string-length(normalize-space(ct:month)) - 1, 2))" data-type="number" order="ascending"/>
      </xsl:perform-sort>
    </xsl:variable>
    <xsl:variable name="alteration-stages" select="$stages-order[@id!='base']"/>
    <xsl:variable name="base-stage" select="$stages-order[@id='base'][1]"/>
    <xsl:variable name="stage-count" select="xs:integer(count($alteration-stages))"/>
    <!-- Кол-во колонок считается детерминированно по блокам:
         5 фиксированных + (1 база + S Total по стадиям) +
         (S блоков изменений: 1 увеличение + снижения ко всем предыдущим стадиям) +
         (S обоснований) +
         (1 база документов + S документов по стадиям) -->
    <xsl:variable name="total-columns" select="1 + $stage-count"/>
    <xsl:variable name="decrease-columns" select="xs:integer(sum(for $i in 1 to $stage-count return $i))"/>
    <xsl:variable name="changes-columns" select="xs:integer($stage-count + $decrease-columns)"/>
    <xsl:variable name="reasons-columns" select="$stage-count"/>
    <xsl:variable name="docs-columns" select="1 + $stage-count"/>
    <xsl:variable name="column-count"
                  select="xs:integer(5 + $total-columns + $changes-columns + $reasons-columns + $docs-columns)"/>
    <xsl:variable name="base-label"
                  select="( ($doc/bd:estimateList//ct:item[1]/ct:volumeList/@baseLabel)[1],
                            'До изменений (база)')[1]"/>


    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta charset="UTF-8"/>
        <title>Сводная ведомость объемов работ</title>
      <style type="text/css">
          :root {
            --bg: #f5f7fb;
            --card: #ffffff;
            --border: #dfe3ec;
            --text: #1f2937;
            --muted: #6b7280;
            --primary: #1d4ed8;
            --accent: #0ea5e9;
            --danger: #cc0000;
            --danger-bg: #ffe6e6;
          }
          body {
            font-family: "Inter", "Segoe UI", system-ui, -apple-system, sans-serif;
            font-size: 11pt;
            margin: 0;
            padding: 24px;
            background: linear-gradient(135deg, #f7f9fc 0%, #eef2f7 100%);
            color: var(--text);
          }
          h1 { font-size: 20pt; text-align: center; margin: 20px 0; letter-spacing: 0.4px; }
          .page { width: 100%; max-width: 100%; margin: 0 auto; display: flex; flex-direction: column; gap: 16px; }
          .card { background: transparent; border: none; border-radius: 0; box-shadow: none; padding: 0; width: 100%; overflow: visible; }
          .table-card { padding: 0; overflow: visible; }
          .meta { margin: 12px 0; }
          .meta div { margin: 2px 0; color: var(--muted); }
          table { width: auto; min-width: 2600px; border-collapse: separate; border-spacing: 0; margin: 8px 0; }
          thead th {
            border: 1px solid var(--border);
            padding: 6px 6px;
            font-size: 11pt;
            background: #f0f4ff;
            vertical-align: middle;
            text-align: center;
            white-space: normal;
            word-break: break-word;
          }
          thead th.numbering { background: #eef1f6; font-size: 10pt; font-weight: 600; }
          tbody td {
            border: 1px solid var(--border);
            padding: 6px 6px;
            vertical-align: top;
            white-space: normal;
            word-break: break-word;
            line-height: 1.25;
          }
          tbody tr:nth-child(even) { background: #fafbfe; }
          .alert { border: 1px solid var(--danger); background: #ffecec; padding: 10px 12px; margin: 0 0 4px; border-radius: 10px; }
          .alert ul { margin: 6px 0 0 18px; padding: 0; }
          .alert li { margin: 4px 0; }
          .center { text-align: center; }
          .right { text-align: right; white-space: nowrap; }
          .nowrap { white-space: nowrap; word-break: normal; }
          .section-row td { font-weight: 700; background: #f3f4f6; }
          .estimate-row td { font-weight: 700; background: #e0e7ff; }
          .free-string-row td { font-style: italic; background: #fff9e6; }
          .notes-cell { white-space: pre-wrap; }
          .header-block { margin: 4px 0 12px 0; }
          .header-title { font-size: 16pt; font-weight: 800; text-align: center; text-transform: uppercase; margin: 0 0 12px; letter-spacing: 0.6px; }
          table.header-table { width: 100%; min-width: 0; margin: 0; border-collapse: collapse; table-layout: fixed; }
          table.header-table td { border: none; padding: 6px 4px; font-size: 12pt; vertical-align: bottom; }
          table.header-table .label { width: 14%; min-width: 80px; white-space: nowrap; text-align: left; padding-right: 6px; color: var(--muted); font-weight: 600; }
          table.header-table .line { width: auto; padding-left: 0; }
          table.header-table .line-text { border-bottom: 1px solid var(--border); min-height: 20px; padding: 10px 6px 6px 6px; text-align: center; display: block; margin-left: 60px; margin-right: 12px; }
          table.header-table .hint { font-size: 10pt; color: var(--muted); text-align: center; font-style: italic; white-space: nowrap; padding-top: 2px; }
          table.header-table .date-alt { color: #c00; font-style: italic; }
          .export-info { font-size: 10pt; color: var(--muted); margin-bottom: 6px; text-align: left; }
          .row-issue { position: relative; }
          .row-issue:hover::after {
            content: attr(data-error);
            position: absolute;
            left: 0;
            top: -6px;
            transform: translateY(-100%);
            background: var(--danger-bg);
            color: var(--danger);
            border: 1px solid var(--danger);
            padding: 6px 8px;
            white-space: pre-wrap;
            max-width: 520px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            z-index: 5;
          }
          .center { text-align: center; }
          .right { text-align: right; white-space: nowrap; }
          .nowrap { white-space: nowrap; word-break: normal; }
          .section-row td { font-weight: bold; background: #f0f0f0; }
          .estimate-row td { font-weight: bold; background: #dfe7ff; }
          .free-string-row td { font-style: italic; background: #fff9e6; }
          .notes-cell { white-space: pre-wrap; }
          .header-block { margin: 8px 0 24px 0; width: 1100px; max-width: 1100px; }
          .header-title { font-size: 18pt; font-weight: bold; text-align: center; text-transform: uppercase; margin: 0 0 18px; }
          table.header-table { width: 1100px; max-width: 1100px; min-width: 0; margin: 0; border-collapse: collapse; table-layout: fixed; }
          table.header-table td { border: none; padding: 4px 4px; font-size: 12pt; vertical-align: bottom; }
          table.header-table .label { width: 12%; min-width: 80px; white-space: nowrap; text-align: left; padding-right: 4px; }
          table.header-table .line { width: auto; padding-left: 0; }
          table.header-table .line-text { border-bottom: 1px solid #000; min-height: 22px; padding: 10px 4px 4px 4px; text-align: center; display: block; margin-left: 60px; margin-right: 12px; }
          table.header-table .hint { font-size: 10pt; color: #666; text-align: center; font-style: italic; white-space: nowrap; padding-top: 2px; }
          table.header-table .date-alt { color: #c00; font-style: italic; }
          table.data-table { table-layout: auto; }
          .col-number { min-width: 180px; max-width: 240px; width: 200px; white-space: normal; word-break: break-word; }
          .col-estimate-name { min-width: 620px; max-width: 760px; width: 620px; white-space: normal; word-break: break-word; }
          .col-work { min-width: 880px; max-width: 1100px; width: 880px; white-space: normal; word-break: break-word; }
          .col-unit { min-width: 120px; max-width: 160px; width: 140px; }
          .col-position { min-width: 90px; max-width: 120px; width: 100px; }
          .col-reason { min-width: 260px; max-width: 520px; width: 320px; white-space: normal; word-break: break-word; }
          .col-docs { min-width: 220px; max-width: 520px; width: 280px; white-space: normal; word-break: break-word; }
          .comment-wrapper { display: flex; flex-direction: column; gap: 4px; }
          .comment-toggle { display: none; }
          .comment-body { white-space: pre-wrap; word-break: break-word; }
          .comment-toggle:not(:checked) + .comment-body {
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
          }
          .comment-toggle:not(:checked) ~ .comment-more,
          .comment-toggle:checked ~ .comment-more {
            color: var(--primary);
            font-weight: 600;
            cursor: pointer;
            display: inline-block;
          }
          .comment-toggle:not(:checked) ~ .comment-more .less-text { display: none; }
          .comment-toggle:checked ~ .comment-more .more-text { display: none; }
          .section-toggle {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            margin-right: 6px;
            background: #eef2ff;
            border: 1px solid #c7d2fe;
            border-radius: 4px;
            font-weight: 800;
            font-size: 16px;
            cursor: pointer;
            color: #1f2937;
          }
          .section-toggle:hover { background: #e0e7ff; }
          .section-toggle:focus { outline: 2px solid #8ea0ff; outline-offset: 2px; }
          .collapsed-placeholder { background: #f7f7f7; color: #666; font-style: italic; }
          table.data-table td.right { min-width: 80px; }
          .th-label-muted { display: block; font-size: 10pt; color: var(--muted); line-height: 1.2; margin-bottom: 2px; }
        .th-label-strong { display: block; font-weight: 700; line-height: 1.3; }
        .footer-card { padding: 4px 0 0 0; margin-top: 8px; border: none; }
        .footer-table { width: 100%; border-collapse: collapse; }
        .footer-table .label { width: 14%; min-width: 80px; color: var(--muted); font-weight: 600; text-align: left; vertical-align: top; padding: 2px 6px 2px 0; }
        .footer-table .line { display: none; }
        .footer-table .hint { display: block; font-size: 10pt; color: var(--muted); padding: 0 0 6px 0; }
        .footer-table .decode { display: block; font-size: 10pt; color: #000; padding: 0 0 12px 0; }
      </style>
      </head>
      <body>
        <xsl:variable name="doc-date" select="if ($doc/bd:documentDate) then xs:date($doc/bd:documentDate) else ()"/>
        <xsl:variable name="customer" select="normalize-space($doc/bd:customerName)"/>
        <xsl:variable name="construction-name" select="normalize-space($doc/bd:constructionName)"/>
        <xsl:variable name="full-date" select="f:full-date($doc-date)"/>
        <xsl:variable name="composer-name" select="concat($doc/bd:signatures/bd:composer/ct:surname, ' ', $doc/bd:signatures/bd:composer/ct:name, if ($doc/bd:signatures/bd:composer/ct:patronymic) then concat(' ', $doc/bd:signatures/bd:composer/ct:patronymic) else '')"/>
        <xsl:variable name="composer-position" select="$doc/bd:signatures/bd:composer/ct:position"/>
        <xsl:variable name="verifier-name" select="concat($doc/bd:signatures/bd:verifier/ct:surname, ' ', $doc/bd:signatures/bd:verifier/ct:name, if ($doc/bd:signatures/bd:verifier/ct:patronymic) then concat(' ', $doc/bd:signatures/bd:verifier/ct:patronymic) else '')"/>
        <xsl:variable name="verifier-position" select="$doc/bd:signatures/bd:verifier/ct:position"/>
        <xsl:variable name="composer-label" select="normalize-space(string-join(($composer-position, $composer-name), ', '))"/>
        <xsl:variable name="verifier-label" select="normalize-space(string-join(($verifier-position, $verifier-name), ', '))"/>

          <div class="page">
      <div class="card">
        <div class="header-block">
          <div class="export-info">
            <xsl:text>Документ экспортирован </xsl:text>
            <xsl:variable name="export-dt" select="$doc/bd:exportDateTime"/>
            <xsl:choose>
              <xsl:when test="exists($export-dt)">
                <xsl:variable name="dt" select="xs:dateTime($export-dt)"/>
                <xsl:value-of select="format-dateTime($dt, '[D01].[M01].[Y0001]')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="format-dateTime($dt, '[H01]:[m01]')"/>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </div>
          <div class="header-title">СОПОСТАВИТЕЛЬНАЯ ВЕДОМОСТЬ ОБЪЕМОВ РАБОТ</div>
          <table class="header-table">
            <tr>
              <td class="label">Заказчик</td>
              <td class="line">
                    <div class="line-text">
                      <xsl:value-of select="$customer"/>
                    </div>
                    <div class="hint">(наименование организации)</div>
                  </td>
                </tr>
                <tr>
                  <td class="label">Наименование стройки</td>
                  <td class="line">
                    <div class="line-text">
                      <xsl:value-of select="$construction-name"/>
                    </div>
                    <div class="hint">(наименование стройки)</div>
                  </td>
                </tr>
                <tr>
                  <td class="label">Дата составления:</td>
                  <td class="line">
                    <div class="line-text">
                      <xsl:choose>
                        <xsl:when test="exists($full-date)">
                          <xsl:value-of select="$full-date"/>
                        </xsl:when>
                        <xsl:otherwise>&#160;</xsl:otherwise>
                      </xsl:choose>
                    </div>
                  </td>
                </tr>
              </table>
            </div>
          </div>

          <div class="card table-card">
            <xsl:call-template name="render-table">
              <xsl:with-param name="doc" select="$doc"/>
              <xsl:with-param name="stages-order" select="$alteration-stages"/>
              <xsl:with-param name="stage-count" select="$stage-count"/>
              <xsl:with-param name="column-count" select="$column-count"/>
              <xsl:with-param name="base-label" select="$base-label"/>
              <xsl:with-param name="base-stage" select="$base-stage"/>
            </xsl:call-template>
          </div>

          <div class="card footer-card">
            <table class="footer-table">
              <tr>
                <td class="label">Составил</td>
                <td>
                  <div class="hint">
                    <xsl:choose>
                      <xsl:when test="$composer-label">
                        <xsl:value-of select="$composer-label"/>
                      </xsl:when>
                      <xsl:otherwise>&#160;</xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div class="decode">[должность, подпись (инициалы, фамилия)]</div>
                </td>
              </tr>
              <tr>
                <td class="label">Проверил</td>
                <td>
                  <div class="hint">
                    <xsl:choose>
                      <xsl:when test="$verifier-label">
                        <xsl:value-of select="$verifier-label"/>
                      </xsl:when>
                      <xsl:otherwise>&#160;</xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div class="decode">[должность, подпись (инициалы, фамилия)]</div>
                </td>
              </tr>
            </table>
          </div>
        </div>
        <!-- Schematron JS removed -->
        <script type="text/javascript">
          <![CDATA[
          (function() {
            const toggles = Array.from(document.querySelectorAll('.section-toggle'));
            const rows = Array.from(document.querySelectorAll('table.data-table tr'));

            function collapseRange(sectionRow) {
              const idx = rows.indexOf(sectionRow);
              if (idx === -1) return [];
              const level = parseInt(sectionRow.getAttribute('data-level') || '0', 10);
              const affected = [];
              for (let i = idx + 1; i < rows.length; i++) {
                const r = rows[i];
                if (r.getAttribute('data-row-type') === 'section') {
                  const lvl = parseInt(r.getAttribute('data-level') || '0', 10);
                  if (lvl <= level) break;
                }
                affected.push(r);
              }
              return affected;
            }

            function setCollapsed(sectionRow, collapsed) {
              const secId = sectionRow.getAttribute('data-section-id');
              const btn = sectionRow.querySelector('.section-toggle');
              const placeholder = document.querySelector(`tr[data-row-type=\"section-placeholder\"][data-parent-section=\"${secId}\"]`);
              const targets = collapseRange(sectionRow);
              targets.forEach(r => { r.style.display = collapsed ? 'none' : ''; });
              if (placeholder) placeholder.style.display = collapsed ? '' : 'none';
              if (btn) {
                btn.setAttribute('data-collapsed', collapsed ? 'true' : 'false');
                btn.textContent = collapsed ? '▸' : '▾';
              }
            }

            toggles.forEach(btn => {
              btn.addEventListener('click', () => {
                const row = btn.closest('tr.section-row');
                const isCollapsed = btn.getAttribute('data-collapsed') === 'true';
                setCollapsed(row, !isCollapsed);
              });
            });

            // default expanded
            toggles.forEach(btn => {
              const row = btn.closest('tr.section-row');
              setCollapsed(row, false);
            });
          })();
          ]]>
        </script>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="render-table">
    <xsl:param name="doc"/>
    <xsl:param name="stages-order" as="element()*"/>
    <xsl:param name="stage-count" as="xs:integer"/>
    <xsl:param name="column-count" as="xs:integer"/>
    <xsl:param name="base-label" as="xs:string"/>
    <xsl:param name="base-stage" as="element()?"/>
    <xsl:variable name="total-columns" select="1 + $stage-count"/>
    <xsl:variable name="reasons-columns" select="$stage-count"/>
    <xsl:variable name="docs-columns" select="1 + $stage-count"/>
    <xsl:variable name="decrease-columns" select="xs:integer(sum(for $i in 1 to $stage-count return $i))"/>
    <xsl:variable name="change-columns" select="xs:integer($stage-count + $decrease-columns)"/>
      <xsl:variable name="numbering" as="xs:string*">
        <xsl:sequence select="('1','2','3','4','5')"/>
        <xsl:sequence select="'6'"/>
        <xsl:for-each select="1 to $stage-count">
          <xsl:sequence select="if (position() = 1) then '7' else concat('7.', position() - 1)"/>
        </xsl:for-each>
        <xsl:for-each select="1 to $stage-count">
          <xsl:variable name="idx" select="position() - 1"/>
          <xsl:sequence select="if ($idx = 0) then '8' else concat('8.', $idx)"/>
          <xsl:choose>
            <xsl:when test="$idx = 0">
              <xsl:sequence select="'9'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="1 to ($idx + 1)">
                <xsl:sequence select="concat('9.', $idx, '.', position())"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:variable name="reason-start" select="10"/>
        <xsl:for-each select="1 to $stage-count">
          <xsl:sequence select="if (position() = 1) then string($reason-start) else concat($reason-start, '.', position() - 1)"/>
        </xsl:for-each>
        <xsl:sequence select="'11'"/>
        <xsl:for-each select="$stages-order">
          <xsl:sequence select="if (position() = 1)
                                then '12'
                                else concat('12.', position() - 1)"/>
        </xsl:for-each>
      </xsl:variable>

    <table class="data-table">
      <colgroup>
        <col class="col-position"/>
        <col class="col-number"/>
        <col class="col-estimate-name"/>
        <col class="col-work"/>
        <col style="width:100px"/>
      </colgroup>
        <thead>
          <tr>
            <th rowspan="3" class="center">№ п/п</th>
            <th colspan="2" class="center">Данные сметного расчета (сметы)</th>
            <th rowspan="3" class="center">Наименование работ и затрат</th>
            <th rowspan="3" class="center">Ед. изм.</th>
            <th colspan="{1 + $stage-count}" class="center">Объем работ в сметной документации</th>
            <th colspan="{$change-columns}" class="center">Изменение объема работ</th>
            <th colspan="{$stage-count}" class="center">Обоснование изменений</th>
            <th colspan="{$stage-count + 1}" class="center">Ссылки на исходные документы</th>
          </tr>
          <tr>
            <th class="center" rowspan="2">Номер</th>
            <th class="center" rowspan="2">Наименование</th>
            <th class="center" rowspan="2">
              <xsl:value-of select="$base-label"/>
            </th>
            <xsl:if test="$stage-count &gt; 0">
              <th class="center" colspan="{$stage-count}">С учетом изменений</th>
            </xsl:if>
            <xsl:for-each select="$stages-order">
              <xsl:variable name="stage-index" select="position()"/>
              <th class="center" colspan="{1 + $stage-index}">
                Корректировка <xsl:value-of select="f:stage-label(.)"/>
              </th>
            </xsl:for-each>
            <xsl:for-each select="$stages-order">
              <th class="center" rowspan="2">
                <xsl:value-of select="f:stage-label(.)"/>
              </th>
            </xsl:for-each>
            <th class="center" rowspan="2">
              <xsl:value-of select="$base-label"/>
            </th>
            <xsl:for-each select="$stages-order">
              <th class="center" rowspan="2">
                <xsl:value-of select="f:stage-label(.)"/>
              </th>
            </xsl:for-each>
          </tr>
          <tr>
            <xsl:for-each select="$stages-order">
              <xsl:variable name="year" select="normalize-space(*:year)"/>
              <xsl:variable name="month-raw" select="normalize-space(*:month)"/>
              <xsl:variable name="month-digits" select="replace($month-raw, '[^0-9]', '')"/>
              <xsl:variable name="month-num"
                            select="if (string-length($month-digits) &gt;= 2)
                                    then xs:integer(substring($month-digits, 1, 2))
                                    else if ($month-raw castable as xs:integer)
                                         then xs:integer($month-raw)
                                         else ()"/>
              <xsl:variable name="month"
                            select="if ($month-num)
                                    then format-number($month-num, '00')
                                    else ''"/>
              <th class="center">
                <xsl:choose>
                  <xsl:when test="$month and $year">
                    <xsl:value-of select="concat($month, ' ', $year)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="f:stage-label(.)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </th>
            </xsl:for-each>
            <xsl:for-each select="$stages-order">
              <xsl:variable name="stage-index" select="position()"/>
              <xsl:variable name="stage-label" select="f:stage-label(.)"/>
              <th class="center">Увеличение <xsl:value-of select="$stage-label"/></th>
              <xsl:variable name="prior-stages" select="reverse(($base-stage, $stages-order[position() lt $stage-index]))"/>
              <xsl:for-each select="$prior-stages">
                <xsl:variable name="target-label" select="if (@id = 'base') then f:stage-label($base-stage) else f:stage-label(.)"/>
                <th class="center">Снижение <xsl:value-of select="$target-label"/></th>
              </xsl:for-each>
            </xsl:for-each>
          </tr>
          <tr>
            <xsl:for-each select="$numbering">
              <th class="center numbering">
                <xsl:value-of select="."/>
              </th>
            </xsl:for-each>
          </tr>
        </thead>
      <tbody>
        <xsl:call-template name="render-estimates">
          <xsl:with-param name="estimates" select="$doc/*:estimateList/*:estimate"/>
          <xsl:with-param name="stages-order" select="$stages-order"/>
          <xsl:with-param name="base-label" select="$base-label"/>
          <xsl:with-param name="column-count" select="xs:integer($column-count)"/>
          <xsl:with-param name="base-stage" select="$base-stage"/>
        </xsl:call-template>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="render-estimates">
    <xsl:param name="estimates" as="element()*"/>
    <xsl:param name="stages-order" as="element()*"/>
    <xsl:param name="base-label" as="xs:string"/>
    <xsl:param name="column-count" as="xs:integer"/>
    <xsl:param name="base-stage" as="element()?"/>

    <xsl:for-each select="$estimates">
      <xsl:variable name="estimate" select="."/>
      <xsl:variable name="estimate-number" select="normalize-space(@estimateNumber)"/>
      <xsl:variable name="estimate-name" select="normalize-space(*:estimateName)"/>
      <tr class="estimate-row">
        <td colspan="{$column-count}"
            title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/@estimateNumber|estimateName','Исходная смета (номер, наименование)')}">
          <xsl:text>Смета </xsl:text>
          <xsl:value-of select="$estimate-number"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="$estimate-name"/>
        </td>
      </tr>
        <xsl:call-template name="render-sections">
          <xsl:with-param name="sections" select="$estimate/*:sectionList/*:section"/>
          <xsl:with-param name="level" select="0"/>
          <xsl:with-param name="stages-order" select="$stages-order"/>
          <xsl:with-param name="base-label" select="$base-label"/>
          <xsl:with-param name="column-count" select="$column-count"/>
          <xsl:with-param name="estimate-number" select="$estimate-number"/>
          <xsl:with-param name="estimate-name" select="$estimate-name"/>
          <xsl:with-param name="base-stage" select="$base-stage"/>
        </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="render-sections">
    <xsl:param name="sections" as="element()*"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:param name="stages-order" as="element()*"/>
    <xsl:param name="base-label" as="xs:string"/>
    <xsl:param name="column-count" as="xs:integer"/>
    <xsl:param name="estimate-number" as="xs:string"/>
    <xsl:param name="estimate-name" as="xs:string"/>
    <xsl:param name="base-stage" as="element()?"/>

    <xsl:for-each select="$sections">
      <xsl:variable name="section-id" select="concat('sec-', generate-id(.))"/>
      <tr class="section-row"
          data-row-type="section"
          data-section-id="{$section-id}"
          data-level="{$level}">
        <td colspan="{$column-count}"
            title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/(@sectionNumber|sectionName)','Номер и наименование раздела сметы')}">
          <xsl:attribute name="style">
            <xsl:text>padding-left: </xsl:text>
            <xsl:value-of select="xs:integer($level * 16)"/>
            <xsl:text>px;</xsl:text>
          </xsl:attribute>
          <button type="button" class="section-toggle" data-target="{$section-id}" aria-label="Свернуть/развернуть раздел">
            <xsl:text>▾</xsl:text>
          </button>
          <xsl:variable name="sectionNumber" select="normalize-space(@sectionNumber)"/>
          <xsl:variable name="sectionName" select="normalize-space(*:sectionName)"/>
          <xsl:value-of select="concat(if ($sectionNumber) then concat($sectionNumber, '. ') else '', $sectionName)"/>
        </td>
      </tr>
      <tr class="collapsed-placeholder" data-row-type="section-placeholder" data-parent-section="{$section-id}" style="display:none;">
        <td colspan="{$column-count}">
          <xsl:text>Раздел скрыт. Нажмите ▸, чтобы раскрыть.</xsl:text>
        </td>
      </tr>
      <xsl:for-each select="*:itemList/*">
        <xsl:choose>
          <xsl:when test="local-name() = 'freeStringItem'">
            <xsl:call-template name="render-free-string">
              <xsl:with-param name="free-string" select="."/>
              <xsl:with-param name="column-count" select="$column-count"/>
              <xsl:with-param name="section-id" select="$section-id"/>
              <xsl:with-param name="section-level" select="$level"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="render-item">
              <xsl:with-param name="item" select="."/>
              <xsl:with-param name="stages-order" select="$stages-order"/>
              <xsl:with-param name="base-label" select="$base-label"/>
              <xsl:with-param name="estimate-number" select="$estimate-number"/>
              <xsl:with-param name="estimate-name" select="$estimate-name"/>
              <xsl:with-param name="base-stage" select="$base-stage"/>
              <xsl:with-param name="section-id" select="$section-id"/>
              <xsl:with-param name="section-level" select="$level"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:if test="*:sectionList/*:section">
        <xsl:call-template name="render-sections">
          <xsl:with-param name="sections" select="*:sectionList/*:section"/>
          <xsl:with-param name="level" select="$level + 1"/>
          <xsl:with-param name="stages-order" select="$stages-order"/>
          <xsl:with-param name="base-label" select="$base-label"/>
          <xsl:with-param name="column-count" select="$column-count"/>
          <xsl:with-param name="estimate-number" select="$estimate-number"/>
          <xsl:with-param name="estimate-name" select="$estimate-name"/>
          <xsl:with-param name="base-stage" select="$base-stage"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="render-item">
    <xsl:param name="item" as="element()"/>
    <xsl:param name="stages-order" as="element()*"/>
    <xsl:param name="base-label" as="xs:string"/>
    <xsl:param name="estimate-number" as="xs:string"/>
    <xsl:param name="estimate-name" as="xs:string"/>
    <xsl:param name="base-stage" as="element()?"/>
    <xsl:param name="depth" as="xs:integer" select="0"/>
    <xsl:param name="display-prefix" as="xs:string" select="''"/>
    <xsl:param name="section-id" as="xs:string" select="''"/>
    <xsl:param name="section-level" as="xs:integer" select="0"/>

    <xsl:variable name="indent" select="string-join(for $i in 1 to $depth return '   ', '')"/>
    <xsl:variable name="base-value" select="f:quantity($item, 'base')"/>
    <xsl:variable name="raw-position" select="string($item/@itemPositionId)"/>
    <xsl:variable name="local-position" select="(tokenize($raw-position, '\\.')[last()], $raw-position)[1]"/>
    <xsl:variable name="display-position"
      select="if (string-length($display-prefix) gt 0)
              then concat($display-prefix, '.', $local-position)
              else $local-position"/>
    <xsl:variable name="item-id" select="generate-id($item)"/>

    <xsl:variable name="item-has-issue" select="false()"/>
    <xsl:variable name="item-issue-messages" select="()"/>

    <tr data-row-type="item">
      <xsl:attribute name="title"/>
      <xsl:attribute name="title"/>
      <xsl:if test="string($section-id)">
        <xsl:attribute name="data-parent-section" select="$section-id"/>
        <xsl:attribute name="data-parent-level" select="$section-level"/>
      </xsl:if>
      <xsl:variable name="pos-title-base"
        select="f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/@itemPositionId','Номер позиции сметы (атрибут itemPositionId)')"/>
      <xsl:variable name="pos-title"
        select="if ($item-has-issue and count($item-issue-messages) &gt; 0)
                then concat($pos-title-base, '&#10;', '')
                else $pos-title-base"/>

      <td class="center nowrap col-position" title="{$pos-title}">
        <xsl:value-of select="$display-position"/>
      </td>
      <td class="col-number" title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/@estimateNumber','Номер исходной сметы (атрибут estimateNumber)')}">
        <xsl:value-of select="$estimate-number"/>
      </td>
      <td class="col-estimate-name" title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/estimateName','Наименование исходной сметы (estimateName)')}">
        <xsl:value-of select="$estimate-name"/>
      </td>
      <td class="col-work" title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/work','Работа (workName, normCodePrefix, normCode)')}">
        <xsl:value-of select="$indent"/>
        <xsl:value-of select="normalize-space($item/*:work/*:workName)"/>
        <xsl:variable name="prefix" select="normalize-space($item/*:work/*:normCodePrefix)"/>
        <xsl:variable name="code" select="normalize-space($item/*:work/*:normCode)"/>
        <xsl:if test="$prefix or $code">
          <xsl:text> (</xsl:text>
          <xsl:if test="$code">
            <xsl:text>код: </xsl:text>
            <xsl:value-of select="$code"/>
            <xsl:if test="$prefix">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:if>
          <xsl:if test="$prefix">
            <xsl:value-of select="$prefix"/>
          </xsl:if>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </td>
      <td class="center col-unit"
          title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/work/measurementUnit','Единица измерения (measurementUnit)')}">
        <xsl:value-of select="$item/*:work/*:measurementUnit"/>
      </td>
      <td class="right"
          title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumeList/volume[@alterationRef=&quot;base&quot;]/volumeQuantity','Объем базы (volumeList/volume, alterationRef=base)')}">
        <xsl:value-of select="f:format($base-value)"/>
      </td>
      <xsl:for-each select="$stages-order">
        <xsl:variable name="stageId" select="@id"/>
        <xsl:variable name="stageLabel" select="f:stage-label(.)"/>
        <xsl:variable name="value" select="f:quantity($item, $stageId)"/>
        <td class="right"
            title="{f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumeList/volume[@alterationRef=&quot;',$stageId,'&quot;]/volumeQuantity'), concat('Объем по стадии ', $stageLabel))}">
          <xsl:value-of select="f:format($value)"/>
        </td>
      </xsl:for-each>
      <xsl:for-each select="$stages-order">
        <xsl:variable name="stage" select="."/>
        <xsl:variable name="stageId" select="$stage/@id"/>
        <xsl:variable name="stageLabel" select="f:stage-label($stage)"/>
        <xsl:variable name="has-schematron-issue" select="false()"/>
        <xsl:variable name="stage-issue-msgs" select="()"/>
        <xsl:variable name="stage-pos" select="position()"/>
        <xsl:variable name="volume" select="$item/*:volumeList/*:volume[@alterationRef=$stageId]"/>
        <xsl:variable name="inc" select="$volume/*:volumeIncrease/*:amount"/>
        <xsl:variable name="prior-stages" select="reverse(($base-stage, $stages-order[position() lt $stage-pos]))"/>
        <xsl:variable name="prev-stage-id" select="( ($stages-order[position() lt $stage-pos])[last()]/@id, 'base')[1]"/>

        <td class="right">
          <xsl:if test="$has-schematron-issue">
            <xsl:attribute name="style">background:#ffe6e6;border:2px solid #cc0000;</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="title">
            <xsl:value-of select="f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumeList/volume[@alterationRef=&quot;',$stageId,'&quot;]/volumeIncrease/amount'), concat('Увеличения объема на стадии ', $stageLabel))"/>
          </xsl:attribute>
          <xsl:value-of select="f:format($inc)"/>
        </td>
        <xsl:for-each select="$prior-stages">
          <xsl:variable name="target-stage" select="."/>
          <xsl:variable name="target-id" select="@id"/>
          <xsl:variable name="target-label" select="if ($target-id = 'base') then f:stage-label($base-stage) else f:stage-label($target-stage)"/>
          <xsl:variable name="dec-value"
                        select="$item/*:volumeList/*:volume[@alterationRef=$stageId]/*:decreaseList/*:decrease[@fromRef=$target-id]/*:amount"/>
          <td class="right"
              title="{f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumeList/volume[@alterationRef=&quot;',$stageId,'&quot;]/decreaseList/decrease[@fromRef=&quot;',$target-id,'&quot;]/amount'), concat('Снижение объема от ', if ($target-id = 'base') then 'базы' else concat('стадии ', $target-label), ' до стадии ', $stageLabel))}">
            <xsl:value-of select="f:format($dec-value[1])"/>
          </td>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="$stages-order">
        <xsl:variable name="stageId" select="@id"/>
        <xsl:variable name="stageLabel" select="f:stage-label(.)"/>
        <xsl:variable name="volume" select="$item/*:volumeList/*:volume[@alterationRef=$stageId]"/>
        <xsl:variable name="reason" select="normalize-space($volume/*:reason)"/>
        <xsl:variable name="has-schematron-issue" select="false()"/>
        <td class="notes-cell col-reason">
          <xsl:if test="$has-schematron-issue">
            <xsl:attribute name="style">background:#ffe6e6;border:2px solid #cc0000;</xsl:attribute>
          </xsl:if>
          <xsl:attribute name="title">
            <xsl:value-of
              select="f:tooltip(
                        concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumeList/volume[@alterationRef=&quot;',$stageId,'&quot;]/reason'),
                        concat('Обоснования изменений по стадии ', $stageLabel)
                     )"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="string-length($reason) gt 120">
              <xsl:variable name="rid" select="concat('reason-', generate-id($item), '-', $stageId)"/>
              <div class="comment-wrapper">
                <input type="checkbox" id="{$rid}" class="comment-toggle"/>
                <div class="comment-body">
                  <xsl:value-of select="$reason"/>
                </div>
                <label class="comment-more" for="{$rid}">
                  <span class="more-text">Показать полностью</span>
                  <span class="less-text">Скрыть</span>
                </label>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$reason"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </xsl:for-each>
      <xsl:variable name="baseDocs" select="$item/*:documentationList/*:documentReference[not(@alterationRef) or @alterationRef='base']"/>
      <td class="notes-cell col-docs"
          title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/documentationList/documentReference[@alterationRef=&quot;base&quot;]', 'Документы, привязанные к базе (подпись ссылки)')}">
        <xsl:variable name="doc-labels" select="$baseDocs/f:link-label(.)"/>
        <xsl:choose>
          <xsl:when test="exists($doc-labels)">
            <xsl:variable name="docs-id" select="concat('docs-', generate-id($item), '-base')"/>
            <xsl:variable name="doc-count" select="count($doc-labels)"/>
            <xsl:choose>
              <xsl:when test="$doc-count gt 3">
                <div class="comment-wrapper">
                  <input type="checkbox" id="{$docs-id}" class="comment-toggle"/>
                  <div class="comment-body">
                    <xsl:for-each select="$doc-labels">
                      <xsl:if test="position() gt 1"><br/></xsl:if>
                      <xsl:value-of select="."/>
                    </xsl:for-each>
                  </div>
                  <label class="comment-more" for="{$docs-id}">
                    <span class="more-text">Показать полностью</span>
                    <span class="less-text">Скрыть</span>
                  </label>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:for-each select="$doc-labels">
                  <xsl:if test="position() gt 1"><br/></xsl:if>
                  <xsl:value-of select="."/>
                </xsl:for-each>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </td>
      <xsl:for-each select="$stages-order">
        <xsl:variable name="stageId" select="@id"/>
        <xsl:variable name="stageLabel" select="f:stage-label(.)"/>
        <xsl:variable name="docs" select="$item/*:documentationList/*:documentReference[@alterationRef=$stageId]"/>
        <td class="notes-cell col-docs"
            title="{f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/documentationList/documentReference[@alterationRef=&quot;',$stageId,'&quot;]'), concat('Документы по стадии ', $stageLabel, ' (подпись ссылки)'))}">
          <xsl:variable name="doc-labels" select="$docs/f:link-label(.)"/>
          <xsl:choose>
            <xsl:when test="exists($doc-labels)">
              <xsl:variable name="docs-id-stage" select="concat('docs-', generate-id($item), '-', translate($stageId,' ','_'))"/>
              <xsl:variable name="doc-count" select="count($doc-labels)"/>
              <xsl:choose>
                <xsl:when test="$doc-count gt 3">
                  <div class="comment-wrapper">
                    <input type="checkbox" id="{$docs-id-stage}" class="comment-toggle"/>
                    <div class="comment-body">
                      <xsl:for-each select="$doc-labels">
                        <xsl:if test="position() gt 1"><br/></xsl:if>
                        <xsl:value-of select="."/>
                      </xsl:for-each>
                    </div>
                    <label class="comment-more" for="{$docs-id-stage}">
                      <span class="more-text">Показать полностью</span>
                      <span class="less-text">Скрыть</span>
                    </label>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:for-each select="$doc-labels">
                    <xsl:if test="position() gt 1"><br/></xsl:if>
                    <xsl:value-of select="."/>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </td>
      </xsl:for-each>
    </tr>

    <xsl:for-each select="$item/*:itemList/*:item">
      <xsl:call-template name="render-item">
        <xsl:with-param name="item" select="."/>
        <xsl:with-param name="stages-order" select="$stages-order"/>
        <xsl:with-param name="base-label" select="$base-label"/>
        <xsl:with-param name="estimate-number" select="$estimate-number"/>
        <xsl:with-param name="estimate-name" select="$estimate-name"/>
        <xsl:with-param name="base-stage" select="$base-stage"/>
        <xsl:with-param name="depth" select="$depth + 1"/>
        <xsl:with-param name="display-prefix" select="$display-position"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="render-free-string">
    <xsl:param name="free-string" as="element()"/>
    <xsl:param name="column-count" as="xs:integer"/>
    <xsl:param name="section-id" as="xs:string" select="''"/>
    <xsl:param name="section-level" as="xs:integer" select="0"/>

    <tr class="free-string-row" data-row-type="item">
      <xsl:if test="string($section-id)">
        <xsl:attribute name="data-parent-section" select="$section-id"/>
        <xsl:attribute name="data-parent-level" select="$section-level"/>
      </xsl:if>
      <td colspan="{$column-count}"
          title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/freeStringItem/freeStringName','Свободная строка раздела')}">
        <xsl:value-of select="normalize-space($free-string/*:freeStringName)"/>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
