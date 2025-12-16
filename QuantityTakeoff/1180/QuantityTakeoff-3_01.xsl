<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<!-- Главный шаблон и описание стилей CSS -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				                <style type="text/css" id="styles">
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
            font-size: 10pt;
            margin: 0;
            padding: 24px;
            background: linear-gradient(135deg, #f7f9fc 0%, #eef2f7 100%);
            color: var(--text);
          }

          .main {
            width: 100%;
            display: flex;
            flex-direction: column;
            gap: 16px;
            background: transparent;
          }

          .header-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 12px 16px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.04);
          }

          .header-card.small td {
            font-size: 9pt;
          }
          .header-card.small .line-text {
            font-size: 9pt;
          }

          table.header-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            margin: 0;
          }
          table.header-table td {
            border: none;
            padding: 6px 4px;
            font-size: 11pt;
            vertical-align: bottom;
          }
          table.header-table .label {
            width: 30%;
            min-width: 140px;
            white-space: normal;
            text-align: left;
            padding-right: 8px;
            color: var(--muted);
            font-weight: 600;
          }
          table.header-table .line {
            width: 70%;
            padding-left: 0;
          }
          table.header-table .line-text {
            border-bottom: 1px solid var(--border);
            min-height: 20px;
            padding: 2px 6px 4px 6px;
            text-align: left;
            font-style: italic;
          }

          table {
            border-collapse: separate;
            border-spacing: 0;
            width: 100%;
            margin: 8px 0;
          }
          table.main-table {
            table-layout: fixed;
          }
          thead th {
            border: 1px solid var(--border);
            padding: 6px 6px;
            font-size: 9pt;
            background: #f0f4ff;
            vertical-align: middle;
            text-align: center;
            white-space: normal;
            word-break: break-word;
          }
          thead th.numbering {
            background: #eef1f6;
            font-size: 8pt;
            font-weight: 600;
          }
          tbody td {
            border: 1px solid var(--border);
            padding: 6px 6px;
            vertical-align: top;
            white-space: normal;
            word-break: break-word;
            line-height: 1.25;
          }
          tbody tr:nth-child(even) { background: #fafbfe; }

          .center { text-align: center; }
          .right { text-align: right; white-space: nowrap; }
          .left { text-align: left; }
          .nowrap { white-space: nowrap; word-break: normal; }

          .section-row td { font-weight: 700; background: #f3f4f6; }
          .free-string-row td { font-style: italic; background: #fff9e6; }
          .notes-cell { white-space: pre-wrap; }

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

          table.main-table col.col-1 { width: 4%; }
          table.main-table col.col-2 { width: 22%; }
          table.main-table col.col-3 { width: 6%; }
          table.main-table col.col-4 { width: 9%; }
          table.main-table col.col-5 { width: 12%; }
          table.main-table col.col-6 { width: 17%; }
          table.main-table col.col-6-1 { width: 13%; }
          table.main-table col.col-6-2 { width: 8%; }
          table.main-table col.col-7 { width: 9%; }

          table.main-table tbody td:nth-child(3) { white-space: nowrap; }
          table.main-table tbody td:nth-child(6) { white-space: nowrap; }

          .alert { border: 1px solid var(--danger); background: #ffecec; padding: 10px 12px; margin: 0 0 4px; border-radius: 10px; }
          .alert ul { margin: 6px 0 0 18px; padding: 0; }
          .alert li { margin: 4px 0; }

          .header-table .doc-row td {
            font-size: 12.5pt;
            font-weight: 700;
            color: var(--text);
          }
          .header-table .doc-row .line-text {
            font-style: normal;
            font-size: 12.5pt;
            font-weight: 700;
          }
        </style>
			</head>
			<body>
				<xsl:apply-templates select="Construction" mode="render"/>
				
			</body>
		</html>
	</xsl:template>

	<xsl:template name="get-quarter-name">
		<xsl:param name="quarter"/>
		<xsl:choose>
			<xsl:when test="$quarter = 1">I квартал </xsl:when>
			<xsl:when test="$quarter = 2">II квартал </xsl:when>
			<xsl:when test="$quarter = 3">III квартал </xsl:when>
			<xsl:when test="$quarter = 4">IV квартал </xsl:when>
			<xsl:otherwise>error: <xsl:value-of select="$quarter"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="get-month-name">
		<xsl:param name="month"/>
		<xsl:choose>
			<xsl:when test="$month = 1">Январь </xsl:when>
			<xsl:when test="$month = 2">Февраль </xsl:when>
			<xsl:when test="$month = 3">Март </xsl:when>
			<xsl:when test="$month = 4">Апрель </xsl:when>
			<xsl:when test="$month = 5">Май </xsl:when>
			<xsl:when test="$month = 6">Июнь </xsl:when>
			<xsl:when test="$month = 7">Июль </xsl:when>
			<xsl:when test="$month = 8">Август </xsl:when>
			<xsl:when test="$month = 9">Сентябрь </xsl:when>
			<xsl:when test="$month = 10">Октябрь </xsl:when>
			<xsl:when test="$month = 11">Ноябрь </xsl:when>
			<xsl:when test="$month = 12">Декабрь </xsl:when>
			<xsl:otherwise>error: <xsl:value-of select="$month"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Стройка -->
	<xsl:template match="Construction" mode="render">
		<div class="main">
      <div class="header-card small">
        <table class="header-table">
          <tr>
            <td class="label">Дата и время выгрузки файла из сметного программного комплекса</td>
            <td class="line"><div class="line-text"><xsl:value-of select="concat(substring(ExportDateTime, 9, 2), '.', substring(ExportDateTime, 6, 2), '.', substring(ExportDateTime, 1, 4), ' ', substring(ExportDateTime, 12, 5))"/></div></td>
          </tr>
          <tr>
            <td class="label">Наименование программного продукта</td>
            <td class="line"><div class="line-text"><xsl:value-of select="concat(Meta/Soft/Name, ' ', Meta/Soft/Version)"/></div></td>
          </tr>
        </table>
      </div>

      <div class="header-card">
        <table class="header-table">
          <tr class="doc-row">
            <td class="label">Документ</td>
            <td class="line"><div class="line-text"><xsl:value-of select="Meta/File/Type"/></div></td>
          </tr>
          <tr>
            <td class="label">Наименование стройки</td>
            <td class="line"><div class="line-text"><xsl:value-of select="ConstructionSite"/></div></td>
          </tr>
          <tr>
            <td class="label">Наименование объекта капитального строительства</td>
            <td class="line"><div class="line-text"><xsl:value-of select="ObjectName"/></div></td>
          </tr>
          <tr>
            <td class="label">Ведомость объемов работ №</td>
            <td class="line"><div class="line-text"><xsl:value-of select="Num"/></div></td>
          </tr>
          <tr>
            <td class="label">Основание (наименование раздела (подраздела) ПД, акта, содержащего перечень дефектов (при капитальном ремонте))</td>
            <td class="line"><div class="line-text"><xsl:value-of select="Reason"/></div></td>
          </tr>
          <tr>
            <td class="label">Дата составления</td>
            <td class="line"><div class="line-text"><xsl:value-of select="Date/Day"/>.<xsl:value-of select="Date/Month"/>.<xsl:value-of select="Date/Year"/></div></td>
          </tr>
        </table>
      </div>

			<xsl:apply-templates select="./Sections"/>
		</div>
		
		
	</xsl:template>

	<!-- Объект -->
	<xsl:template match="Sections">
		<table class="main-table">
      <colgroup>
        <col class="col-1"/>
        <col class="col-2"/>
        <col class="col-3"/>
        <col class="col-4"/>
        <col class="col-5"/>
        <col class="col-6"/>
        <col class="col-6-1"/>
        <col class="col-6-2"/>
        <col class="col-7"/>
      </colgroup>
			<thead>
				<tr>
					<th >№ п.п.</th>
					<th >Наименование и описание работ, наименование ресурсов, затрат по проекту</th>
					<th >Ед. изм.</th>
					<th >Объем работ / Количество</th>
					<th >Формула расчета объемов работ и расхода материалов, потребности ресурсов</th>
					<th >Ссылка на чертежи, спецификации в проектной документации</th>
					<th >Наименование файла</th>
					<th >Номер страниц (через пробел)</th>
					<th >Дополнительная информация (комментарий)</th>
				</tr>
				
				<tr>
					<td class="tborder center">1</td>
					<td class="tborder center">2</td>
					<td class="tborder center">3</td>
					<td class="tborder center">4</td>
					<td class="tborder center">5</td>
					<td class="tborder center">6</td>
					<td class="tborder center">6.1</td>
					<td class="tborder center">6.2</td>
					<td class="tborder center">7</td>
					
				</tr>
			</thead>
			
			<xsl:apply-templates select="Section">
				<xsl:with-param name="num_prefix" select="''"/>
			</xsl:apply-templates>	
			
			<tr>
				<td  colspan="9">&#160;</td>
			</tr>
			<tr> <td  colspan="9">&#160;</td></tr>
			<tr>
				<td class= "left" colspan="2">Составил, ФИО</td>
				<td class= "left" colspan="7"><xsl:value-of select="/Construction/Signatures/Composer/Name"/></td>
			</tr>
			<tr>
				<td class= "left" colspan="2">Составил, должность (проектировщик)</td>
				<td class= "left" colspan="7"><xsl:value-of select="/Construction/Signatures/Composer/Position"/></td>
			</tr>
			<tr>
				<td class= "left" colspan="2">Проверил, ФИО</td>
				<td class= "left" colspan="7"><xsl:value-of select="/Construction/Signatures/Verifier/Name"/></td>
			</tr>
			<tr>
				<td class= "left" colspan="2">Проверил, должность (заказчик)</td>
				<td class= "left" colspan="7"><xsl:value-of select="/Construction/Signatures/Verifier/Position"/></td>
			</tr>
			
			
		</table>
		
		
		
	</xsl:template>
	
	<xsl:template match="FreeString">
		<!-- Здесь может быть ваше преобразование или вывод -->
		<!-- Например, выведем содержимое элемента FreeString -->
		<tr>
			<td class= "left  bbottom" colspan="7"><xsl:value-of select="."/></td>
		</tr>
	</xsl:template>
	
	<!-- Section в ВОР -->
	<xsl:template match="Section">
		<xsl:param name="num_prefix"/>
		
		<xsl:variable name="current_num">
			<xsl:choose>
				<xsl:when test="$num_prefix != ''">
					<xsl:value-of select="concat($num_prefix, '.', Num)"/>
				</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="Num"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<tr class="section-row">
		<td class="bbottom left bold" colspan="9">
			<xsl:value-of select="concat('Раздел ', $current_num, '. ', ./Name)"/>
		</td>
	</tr>
	
	<xsl:apply-templates select="FreeString"/>
		<!-- Сохраняем порядок элементов Work/Resource/FreeString -->
		<xsl:apply-templates select="Works/*"/>
		
		<xsl:apply-templates select="Section">
			<xsl:with-param name="num_prefix" select="$current_num"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="Work">
		<xsl:apply-templates select="FreeString"/>
		<tr>
			<td class="center"><xsl:value-of select="Num"/></td>
			<td class="left"><xsl:value-of select="Name"/></td>
			<td class="center"><xsl:value-of select="Unit"/></td>
			<td class="right"><xsl:value-of select="Quantity"/></td>
			<td class="left"><xsl:value-of select="QuantityFormula"/></td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:value-of select="PageDescription"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:variable name="fileName">
						<xsl:for-each select="/Construction/Files/File[ID = current()/FileID]">
							<xsl:value-of select="FileName"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:value-of select="$fileName"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:value-of select="normalize-space(PageNumber)"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
        <xsl:variable name="comment" select="Comment"/>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($comment)) &gt; 80 or contains($comment, '&#10;')">
            <xsl:variable name="commentId" select="concat('comment-', generate-id())"/>
            <div class="comment-wrapper">
              <input type="checkbox" id="{$commentId}" class="comment-toggle"/>
              <div class="comment-body"><xsl:value-of select="$comment"/></div>
              <label class="comment-more" for="{$commentId}">
                <span class="more-text">Показать полностью</span>
                <span class="less-text">Скрыть</span>
              </label>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="comment-body"><xsl:value-of select="$comment"/></div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
		</tr>
		<xsl:apply-templates select="Resources/Resource"/>
	</xsl:template>
	
	<!-- Ресурс внутри работы -->
	<xsl:template match="Work/Resources/Resource">
		<tr>
			<td class="center"><xsl:value-of select="../../Num"/>.<xsl:value-of select="Num"/></td>
			<td class="left"><xsl:value-of select="Name"/></td>
			<td class="center"><xsl:value-of select="Unit"/></td>
			<td class="right"><xsl:value-of select="Quantity"/></td>
			<td class="left"><xsl:value-of select="QuantityFormula"/></td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:value-of select="PageDescription"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:variable name="fileName">
						<xsl:for-each select="/Construction/Files/File[ID = current()/FileID]">
							<xsl:value-of select="FileName"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:value-of select="$fileName"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:value-of select="normalize-space(PageNumber)"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
        <xsl:variable name="comment" select="Comment"/>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($comment)) &gt; 80 or contains($comment, '&#10;')">
            <xsl:variable name="commentId" select="concat('comment-', generate-id())"/>
            <div class="comment-wrapper">
              <input type="checkbox" id="{$commentId}" class="comment-toggle"/>
              <div class="comment-body"><xsl:value-of select="$comment"/></div>
              <label class="comment-more" for="{$commentId}">
                <span class="more-text">Показать полностью</span>
                <span class="less-text">Скрыть</span>
              </label>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="comment-body"><xsl:value-of select="$comment"/></div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
		</tr>
	</xsl:template>
	
	<!-- Свободный ресурс на уровне Works (без родительского Work) -->
	<xsl:template match="Works/Resource">
		<tr>
			<td class="center"><xsl:value-of select="Num"/></td>
			<td class="left"><xsl:value-of select="Name"/></td>
			<td class="center"><xsl:value-of select="Unit"/></td>
			<td class="right"><xsl:value-of select="Quantity"/></td>
			<td class="left"><xsl:value-of select="QuantityFormula"/></td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:value-of select="PageDescription"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:variable name="fileName">
						<xsl:for-each select="/Construction/Files/File[ID = current()/FileID]">
							<xsl:value-of select="FileName"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:value-of select="$fileName"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
				<xsl:for-each select="Links/Link">
					<xsl:value-of select="normalize-space(PageNumber)"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
			</td>
			<td class="left">
        <xsl:variable name="comment" select="Comment"/>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($comment)) &gt; 80 or contains($comment, '&#10;')">
            <xsl:variable name="commentId" select="concat('comment-', generate-id())"/>
            <div class="comment-wrapper">
              <input type="checkbox" id="{$commentId}" class="comment-toggle"/>
              <div class="comment-body"><xsl:value-of select="$comment"/></div>
              <label class="comment-more" for="{$commentId}">
                <span class="more-text">Показать полностью</span>
                <span class="less-text">Скрыть</span>
              </label>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="comment-body"><xsl:value-of select="$comment"/></div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
		</tr>
	</xsl:template>
	
	<!-- Раздел (по каждому разделу / свободная строка -->
	<xsl:template match="Works/FreeString">
		<xsl:param name="IndexType" select="0"/>
		<tr class="free-string-row">
			
			<td colspan="9" class="bbottom left">
				<xsl:value-of select="."/>
			</td>
		</tr>

	</xsl:template>




</xsl:stylesheet>
