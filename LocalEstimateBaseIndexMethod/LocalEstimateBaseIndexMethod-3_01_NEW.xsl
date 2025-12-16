<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="http://www.gge.ru/utils" exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	

	<xsl:function name="util:formatNumberWithZeroCheck">
		<xsl:param name="number"/>
		<xsl:choose>
			<!-- Проверка на NaN и пустое значение -->
			<xsl:when test="not($number) or string($number) = 'NaN'">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Форматируем число с разделением тысяч запятой и точкой для дробной части -->
				<xsl:variable name="formattedNumber">
					<xsl:value-of select="format-number($number, '#,##0.00')"/>
				</xsl:variable>
				
				<!-- Заменяем запятые (разделители тысяч) на пробелы -->
				<xsl:variable name="translatedNumber">
					<xsl:value-of select="translate($formattedNumber, ',', ' ')"/>
				</xsl:variable>
				
				<!-- Заменяем точку (разделитель дробной части) на запятую -->
				<xsl:variable name="finalNumber">
					<xsl:value-of select="translate($translatedNumber, '.', ',')"/>
				</xsl:variable>
				
				<!-- Возвращаем окончательное число -->
				<xsl:value-of select="$finalNumber"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

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

					body, p, td {
					font-family: "Inter", "Segoe UI", system-ui, -apple-system, sans-serif;
					font-size: 10pt;
					margin: 0;
					color: var(--text);
					}

					body {
					padding: 24px;
					background: linear-gradient(135deg, #f7f9fc 0%, #eef2f7 100%);
					}

					h1 {
					font-size: 12pt;
					font-weight: 700;
					text-align: center;
					width: 100%;
					margin: 16px 0;
					}

					div.heading-left2 {
					margin-left: 1.7em;
					display: flex;
					width: 30%;
					margin-top: 0.5em;
					min-height: 1em;
					}

					div.heading-left2 .headingvalue {
					border-bottom: 1px solid var(--border);
					flex: 1;
					}

					div.heading-left3 {
					margin-left: 1.7em;
					display: flex;
					width: 50%;
					margin-top: 0.5em;
					min-height: 1em;
					}

					div.heading-left3 .headingvalue {
					border-bottom: 1px solid var(--border);
					flex: 1;
					}

					div.helptext {
					text-align: center;
					width: 100%;
					margin-top: 0;
					color: var(--muted);
					}

					div.headingname {
					white-space: nowrap;
					margin-right: 0.3em;
					margin-left: 0.3em;
					flex-grow: *;
					min-height: 1em;
					}

					div.headingnametop {
					width: 50%;
					margin-right: 0.3em;
					margin-left: 0.3em;
					flex-grow: *;
					min-height: 1em;
					}

					div.heading-left {
					display: flex;
					width: 50%;
					margin-bottom: 0.5em;
					min-height: 1em;
					}

					div.heading-left .headingvalue {
					border-bottom: 1px solid var(--border);
					flex-grow: 2;
					}

					div.spacer {
					flex: 1;
					}

					div.report {
					margin-bottom: 2em;
					border-bottom: 2px solid var(--border);
					padding: 0.5em 2em;
					}

					div.report h3 {
					font-size: 120%;
					font-weight: bold;
					}

					div.heading {
					margin-right: 2em;
					margin-left: 2em;
					display: flex;
					margin-top: 1em;
					}

					div.heading .headingvalue {
					border-bottom: 1px solid var(--border);
					width: 100%;
					min-height: 1em;
					}

					div.headingblock {
					display: flex;
					flex-direction: column;
					flex: 3;
					margin-top: 2em;
					}

					.fieldError {
					color: var(--danger);
					}

					td.fieldError {
					border: 1px solid var(--danger);
					}

					div.fieldError .headingvalue {
					border-bottom: 1px solid var(--border);
					flex-grow: 2;
					}

					.main {
					width: 100%;
					display: flex;
					flex-direction: column;
					gap: 16px;
					background: transparent;
					}

					.center {
					text-align: center;
					}

					.right {
					text-align: right;
					}

					.left {
					text-align: left;
					}

					.leftmargin {
					padding-left: 3em;
					}

					.nowrap {
					white-space: nowrap;
					}

					.wrap {
					white-space: normal;
					word-break: break-word;
					}

					.top {
					vertical-align: top;
					}

					.italic {
					font-style: italic;
					}

					.bold {
					font-weight: bold;
					}

					.inline {
					display: inline;
					}

					.breakword {
					word-wrap: break-word;
					}

					.indent {
					padding-left: 2em;
					}

					.indent2 {
					padding-left: 4em;
					}

					.indent3 {
					padding-left: 6em;
					}

					.err {
					color: var(--danger);
					text-decoration: underline;
					}

					.err A {
					color: var(--danger);
					text-decoration: underline;
					}

					table {
					border-collapse: separate;
					border-spacing: 0;
					width: 100%;
					margin: 12px 0;
					}

					th {
					border: 1px solid var(--border);
					padding: 3px 4px;
					vertical-align: top;
					background: #f0f4ff;
					line-height: 1.15;
					font-size: 8pt;
					}

					td {
					border: 0px;
					padding: 3px 4px;
					vertical-align: top;
					text-align: right;
					line-height: 1.15;
					}

					td.tborder {
					border: 1px solid var(--border);
					}

					td.btop {
					border-top: 1px solid var(--border);
					}

					td.btop,
					td.bbottom {
					border-top: 1px solid var(--border);
					border-bottom: 1px solid var(--border);
					}

					.estimate-table {
					width: 100%;
					border-collapse: collapse;
					table-layout: fixed;
					background: var(--card);
					border: 1px solid var(--border);
					}

					.estimate-table td {
					padding: 5px;
					vertical-align: top;
					text-align: left;
					font-weight: normal;
					border: 1px solid var(--border);
					}

					.estimate-table .bordered {
					border-bottom: 1px solid var(--border);
					}

					/* Основная таблица */
					.main-table {
					table-layout: fixed;
					width: 100%;
					max-width: 100%;
					min-width: 1600px;
					margin: 0 auto;
					border-collapse: separate;
					border-spacing: 0;
					background: var(--card);
					border: 1px solid var(--border);
					}

					.main-table thead th {
					border: 1px solid var(--border);
					padding: 6px;
					font-size: 9pt;
					background: #f0f4ff;
					vertical-align: middle;
					text-align: center;
					word-break: break-word;
					}

					.main-table tbody td {
					border: 1px solid var(--border);
					padding: 6px;
					vertical-align: top;
					text-align: right;
					line-height: 1.25;
					}

					.main-table tbody tr:nth-child(even) {
					background: #fafbfe;
					}

					.main-table tbody tr:nth-child(odd) {
					background: #ffffff;
					}
				</style>
			</head>
			<body>
				<xsl:apply-templates select="Construction" mode="render"/>
				<xsl:apply-templates select="Construction" mode="validate"/>
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

			<table class="estimate-table">
				<tr>
					<td>Дата и время выгрузки файла:</td>
					<td class="bordered">
						<xsl:value-of select="concat(substring(ExportDateTime, 9, 2), '.', substring(ExportDateTime, 6, 2), '.', substring(ExportDateTime, 1, 4), ' ', substring(ExportDateTime, 12, 5))"/>
					</td>
				</tr>
				<tr>
					<td>Наименование программного продукта</td>
					<td class="bordered"><xsl:value-of select="concat(Meta/Soft/Name, ' ', Meta/Soft/Version)"/></td>
				</tr>
				<tr>
					<td>Наименование редакции сметных нормативов</td>
					<td class="bordered">
						<xsl:value-of select="Object/Estimate/Legal/Main/Name"/><br/>
						<xsl:value-of select="Object/Estimate/Legal/Metodology/Name"/><br/>
						<xsl:value-of select="Object/Estimate/Legal/Overheads/Name"/><br/>
						<xsl:value-of select="Object/Estimate/Legal/Profits/Name"/>
					</td>
				</tr>
				<tr>
					<td>Реквизиты приказа Минстроя России</td>
					<td class="bordered">
						<xsl:value-of select="concat(Object/Estimate/Legal/Main/Orders, '; ', Object/Estimate/Legal/Metodology/Orders, '; ', Object/Estimate/Legal/Overheads/Orders, '; ', Object/Estimate/Legal/Profits/Orders)"/>
					</td>
				</tr>
				<tr>
					<td>Реквизиты письма Минстроя России об индексах изменения сметной стоимости</td>
					<td class="bordered">
						<xsl:value-of select="Object/Estimate/Legal/Indexes/Name"/>;<br/>
						<xsl:for-each select="Object/Estimate/Legal/Indexes">
							<xsl:value-of select="Orders"/>
							<xsl:if test="not(position() = last())">, </xsl:if>
						</xsl:for-each>
					</td>
				</tr>
				<tr>
					<td>Реквизиты нормативного правового акта об оплате труда</td>
					<td class="bordered"><xsl:value-of select="Object/Estimate/Salary"/></td>
				</tr>
				<tr>
					<td>Наименование субъекта РФ</td>
					<td class="bordered"><xsl:value-of select="Object/Estimate/Region/RegionName"/></td>
				</tr>
				<tr>
					<td>Наименование зоны субъекта РФ</td>
					<td class="bordered"><xsl:value-of select="Object/Estimate/Region/SubRegion/SubRegionName"/></td>
				</tr>
				<tr>
					<td>Стройка</td>
					<td class="bordered"><xsl:value-of select="Name"/></td>
				</tr>
				<tr>
					<td>Объект капитального строительства</td>
					<td class="bordered"><xsl:value-of select="Object/Name"/></td>
				</tr>
			</table>

			<h1 id="EstimateNum">ЛОКАЛЬНЫЙ СМЕТНЫЙ РАСЧЕТ (СМЕТА) №<xsl:value-of
					select="Object/Estimate/Num"/></h1>

			<div class="heading">
				<div class="headingvalue center">
					<xsl:value-of select="Object/Estimate/Name"/>
				</div>
			</div>
			<div class="helptext">(наименование работ и затрат)</div>

			<div class="heading">
				<div class="headingname">Составлен</div>
				<div class="headingvalue center">базисно-индексным</div>
				<div class="headingname">методом</div>
			</div>
			<div class="heading">
				<div class="headingname">Основание</div>
				<div class="headingvalue">
					<xsl:value-of select="Object/Estimate/Reason"/>
					<xsl:text> </xsl:text>
										
						
						
							<xsl:variable name="uniqueFiles" select="/Construction/Object/Estimate/Sections/Section/Items/Item/QTF/FileNameQTF"/>
							
							<xsl:for-each select="$uniqueFiles">
								<xsl:variable name="current" select="."/>
								<xsl:if test="not($current = preceding::FileNameQTF)">
									<xsl:value-of select="$current"/>
									<xsl:if test="position() != last()">, </xsl:if>
								</xsl:if>
							</xsl:for-each>
						
				</div>
			</div>
			
			<div class="heading" style="margin-top: 0;">
				<div class="helptext">(проектная и (или) иная техническая документация)</div>
			</div>

			<div class="heading">
				<div class="headingblock">
					<div class="heading">
						<div class="headingname">
							<b>Составлен в уровне цен</b>
						</div>
						<div class="headingvalue right">
							<xsl:if test="Object/Estimate/PriceLevelCur">
								<xsl:if test="Object/Estimate/PriceLevelCur/Month">
									<xsl:call-template name="get-month-name">
										<xsl:with-param name="month"
											select="Object/Estimate/PriceLevelCur/Month"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="Object/Estimate/PriceLevelCur/Quarter">
									<xsl:call-template name="get-quarter-name">
										<xsl:with-param name="quarter"
											select="Object/Estimate/PriceLevelCur/Quarter"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:value-of select="Object/Estimate/PriceLevelCur/Year"/> г.
							</xsl:if>
							<xsl:if test="Object/Estimate/PriceLevelBase">
								(
								<xsl:value-of select="normalize-space(concat(Object/Estimate/PriceLevelBase/Day, '.', Object/Estimate/PriceLevelBase/Month, '.', Object/Estimate/PriceLevelBase/Year))"/>
								)
							</xsl:if>
							
							
						</div>
					</div>
					<div class="heading">
						<div class="headingname">
							<b>Сметная стоимость</b>
						</div>
						<div class="headingvalue right">
							<xsl:if test="Object/Estimate/EstimatePrice/Total/PriceCurrent != 0">
								<xsl:value-of
									select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Total/PriceCurrent div 1000)'
								/>
							</xsl:if>
							<xsl:if test="Object/Estimate/EstimatePrice/Total/PriceBase != 0">
									(<xsl:value-of
										select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Total/PriceBase div 1000)'
								/>) </xsl:if>
						</div>
						<div class="headingname">тыс. руб.</div>
					</div>
					<div class="heading leftmargin">
						<div class="headingname italic">в том числе:</div>
					</div>

					<xsl:if test="Object/Estimate/EstimateType = 'Реставрация'">
						<div class="heading leftmargin">
							<div class="headingname">
								<b>ремонтно-реставрационных работ</b>
							</div>
							<div class="headingvalue right">
								<xsl:if
									test="Object/Estimate/EstimatePrice/Restoration/Total/PriceCurrent != 0">
									<xsl:value-of
								select='util:formatNumberWithZeroCheck((Object/Estimate/EstimatePrice/Restoration/Total/PriceCurrent + Object/Estimate/EstimatePrice/Restoration/TransportTotal/PriceCurrent) div 1000)'
									/>
								</xsl:if>
								<xsl:if
									test="Object/Estimate/EstimatePrice/Restoration/Total/PriceBase != 0"
									> (<xsl:value-of
								select='util:formatNumberWithZeroCheck((Object/Estimate/EstimatePrice/Restoration/Total/PriceBase + Object/Estimate/EstimatePrice/Restoration/TransportTotal/PriceBase) div 1000)'
									/>) </xsl:if>
							</div>
							<div class="headingname">тыс. руб.</div>
						</div>
					</xsl:if>
					<xsl:if test="Object/Estimate/EstimateType = 'Строительство'">
						<div class="heading leftmargin">
							<div class="headingname">
								<b>строительных работ</b>
							</div>
							<div class="headingvalue right">
								<xsl:if
									test="Object/Estimate/EstimatePrice/Building/Total/PriceCurrent != 0">
									<xsl:value-of
										select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Building/Total/PriceCurrent div 1000)'
									/>
								</xsl:if>
								<xsl:if
									test="Object/Estimate/EstimatePrice/Building/Total/PriceBase != 0"
									> (<xsl:value-of
										select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Building/Total/PriceBase div 1000)'
									/>) </xsl:if>
							</div>
							<div class="headingname">тыс. руб.</div>
						</div>
						<div class="heading leftmargin">
							<div class="headingname">
								<b>монтажных работ</b>
							</div>
							<div class="headingvalue right">
								<xsl:if
									test="Object/Estimate/EstimatePrice/Mounting/Total/PriceCurrent != 0">
									<xsl:value-of
										select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Mounting/Total/PriceCurrent div 1000)'
									/>
								</xsl:if>
								<xsl:if
									test="Object/Estimate/EstimatePrice/Mounting/Total/PriceBase != 0"
									> (<xsl:value-of
										select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Mounting/Total/PriceBase div 1000)'
									/>) </xsl:if>
							</div>

							<div class="headingname">тыс. руб.</div>
						</div>
						<div class="heading leftmargin">
							<div class="headingname">
								<b>оборудования</b>
							</div>
							<div class="headingvalue right">
								<xsl:if
									test="Object/Estimate/EstimatePrice/Equipment/Total/PriceCurrent != 0">
									<xsl:value-of
										select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Equipment/Total/PriceCurrent div 1000)'
									/>
								</xsl:if>
								<xsl:if
									test="Object/Estimate/EstimatePrice/Equipment/Total/PriceBase != 0"
									> (<xsl:value-of
										select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Equipment/Total/PriceBase div 1000)'
									/>) </xsl:if>
							</div>
							<div class="headingname">тыс. руб.</div>
						</div>

					</xsl:if>
					<div class="heading leftmargin">
						<div class="headingname">
							<b>прочих затрат</b>
						</div>
						<div class="headingvalue right">
							<xsl:if
								test="Object/Estimate/EstimatePrice/OtherTotal/PriceCurrent != 0">
								<xsl:value-of
									select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/OtherTotal/PriceCurrent div 1000)'
								/>
							</xsl:if>
							<xsl:if test="Object/Estimate/EstimatePrice/OtherTotal/PriceBase != 0">
									(<xsl:value-of
										select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/OtherTotal/PriceBase div 1000)'
								/>) </xsl:if>
						</div>
						<div class="headingname">тыс. руб.</div>
					</div>
				</div>
				<div class="spacer"/>
				<div class="headingblock" style="margin-top: 8em">
					<div class="heading">
						<div class="headingname">Средства на оплату труда рабочих</div>
						<div class="headingvalue right">
							<xsl:if
								test="Object/Estimate/EstimatePrice/Summary/WorkersSalary/PriceCurrent != 0">
								<xsl:value-of
									select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Summary/WorkersSalary/PriceCurrent div 1000)'
								/>
							</xsl:if>
							<xsl:if
								test="Object/Estimate/EstimatePrice/Summary/WorkersSalary/PriceBase != 0"
								> (<xsl:value-of
									select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Summary/WorkersSalary/PriceBase div 1000)'
								/>) </xsl:if>
						</div>
						<div class="headingname">тыс. руб.</div>
					</div>
					<xsl:if test="Object/Estimate/EstimateType = 'Строительство'">
						<div class="heading">
							<div class="headingname">Нормативные затраты труда рабочих</div>
							<div class="headingvalue right">
								<xsl:value-of
									select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Summary/LaborCosts)'
								/>
							</div>
							<div class="headingname">чел.-ч.</div>
						</div>
						<div class="heading">
							<div class="headingname">Нормативные затраты труда машинистов</div>
							<div class="headingvalue right">
								<xsl:value-of
									select='util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Summary/MachinistLaborCosts)'
								/>
							</div>
							<div class="headingname">чел.-ч;</div>
						</div>
					</xsl:if>
				</div>
			</div>
			<xsl:apply-templates select="./Object"/>
		</div>
	</xsl:template>

	<!-- Объект -->
	<xsl:template match="Object">
		<xsl:apply-templates select="./Estimate"/>
	</xsl:template>

	<!-- Локальная смета -->
	<xsl:template match="Estimate">
		<table class="main-table">
			<colgroup>
				<col style="min-width:56px"/>
				<col style="min-width:110px"/>
				<col style="min-width:450px"/>
				<col style="min-width:80px"/>
				<col style="min-width:92px"/>
				<col style="min-width:92px"/>
				<col style="min-width:92px"/>
				<col style="min-width:120px"/>
				<col style="min-width:120px"/>
				<col style="min-width:120px"/>
				<col style="min-width:100px"/>
				<col style="min-width:100px"/>
			</colgroup>
			<thead>
				<tr>
					<th scope="col" class="center" rowspan="2">№ п.п.</th>
					<th scope="col" class="left" rowspan="2">Обоснование</th>
					<th scope="col" class="left" rowspan="2">Наименование работ и затрат</th>
					<th scope="col" class="center" rowspan="2">Единица измерения</th>
					<th scope="col" class="center" colspan="3">Количество</th>
					<th scope="col" class="center" colspan="3">
						<xsl:choose>
							<xsl:when test="EstimateType = 'Реставрация'">
								Сметная стоимость в базисном уровне цен 1984 года, руб.
							</xsl:when>
							<xsl:otherwise>
								Сметная стоимость в базисном уровне цен (в текущем уровне цен (гр. 8) для ресурсов, отсутствующих в ФРСН), руб.
							</xsl:otherwise>
						</xsl:choose>
					</th>
					<th scope="col" class="center" rowspan="2">Индексы</th>
					<th scope="col" class="center" rowspan="2">
						<xsl:choose>
							<xsl:when test="EstimateType = 'Реставрация'">
								Сметная стоимость в базисном уровне цен по состоянию на 01.01.2000, руб.
							</xsl:when>
							<xsl:otherwise>
								Сметная стоимость в текущем уровне цен, руб.
							</xsl:otherwise>
						</xsl:choose>
					</th>
				</tr>
				<tr>
					<th scope="col" class="center">на единицу измерения</th>
					<th scope="col" class="center">коэффи-циенты</th>
					<th scope="col" class="center">всего с учетом коэффи-циента</th>
					<th scope="col" class="center">на единицу измерения</th>
					<th scope="col" class="center">коэффи-циенты</th>
					<th scope="col" class="center">всего</th>
				</tr>
				<tr>
					<th class="tborder center" scope="col">1</th>
					<th class="tborder center" scope="col">2</th>
					<th class="tborder center" scope="col">3</th>
					<th class="tborder center" scope="col">4</th>
					<th class="tborder center" scope="col">5</th>
					<th class="tborder center" scope="col">6</th>
					<th class="tborder center" scope="col">7</th>
					<th class="tborder center" scope="col">8</th>
					<th class="tborder center" scope="col">9</th>
					<th class="tborder center" scope="col">10</th>
					<th class="tborder center" scope="col">11</th>
					<th class="tborder center" scope="col">12</th>
				</tr>
			</thead>
			<xsl:apply-templates select="Sections">
				<xsl:with-param name="IndexType" select="IndexType"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="EstimatePrice" mode="Common">
				<xsl:with-param name="IndexType" select="IndexType"/>
			</xsl:apply-templates>
		</table>
		<div class="heading-left3">
			<div class="headingname">Составил</div>
			<div class="headingvalue">
				<xsl:value-of select="Signatures/ComposeFIO"/>
			</div>
		</div>
		<div class="heading-left3" style="margin-top: 0;">
			<div class="helptext">[должность, подпись (инициалы, фамилия)]</div>
		</div>
		<p/>
		<div class="heading-left3">
			<div class="headingname">Проверил</div>
			<div class="headingvalue">
				<xsl:value-of select="Signatures/VerifyFIO"/>
			</div>
		</div>
		<div class="heading-left3" style="margin-top: 0;">
			<div class="helptext">[должность, подпись (инициалы, фамилия)]</div>
		</div>
	</xsl:template>

	<!-- Значения в итогах -->
	<xsl:template match="*" mode="SummaryElement">
		<td>
			<xsl:if test="PriceBase != 0">
				<xsl:value-of select='util:formatNumberWithZeroCheck(PriceBase)'/>
			</xsl:if>
		</td>
		<td>
			<xsl:if test="PriceIndex/Final != 0">
				<xsl:value-of select='util:formatNumberWithZeroCheck(PriceIndex/Final)'/>
			</xsl:if>
		</td>
		<td>
			<xsl:if test="PriceCurrent != 0">
				<xsl:value-of select='util:formatNumberWithZeroCheck(PriceCurrent)'/>
			</xsl:if>
		</td>
	</xsl:template>

	<!-- Концевик сметы -->
	<xsl:template match="EstimatePrice" mode="Common">
		<xsl:param name="IndexType" select="0"/>
		<tbody>
			<tr>
				<td style="border-top:1px solid black">&#160;</td>
				<td style="border-top:1px solid black">&#160;</td>
				<td colspan="10" class="bold left" style="border-top:1px solid black;">ИТОГИ ПО
					СМЕТЕ</td>
			</tr>

			<xsl:if test="Building/Total/PriceCurrent != 0">
				<tr>
					<td colspan="12">&#160;</td>
				</tr>
				<tr class="bold">
					<td colspan="2"/>
					<td class="left bold" colspan="7">ВСЕГО строительные работы</td>
					<xsl:apply-templates select="./Building/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<xsl:if test="$IndexType = 'Индексы к СМР'">
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">строительные работы без учета перевозки, в том
							числе дополнительной</td>
						<xsl:apply-templates select="./Building/Price" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="12">&#160;</td>
					</tr>
				</xsl:if>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего прямые затраты</td>
					<xsl:apply-templates select="./Building/Direct" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">оплата труда (ОТ)</td>
					<xsl:apply-templates select="./Building/WorkersSalary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">эксплуатация машин и механизмов</td>
					<xsl:apply-templates select="./Building/MachinesTotal" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2 italic" colspan="10">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">эксплуатация машин и механизмов без учета
						доплат к оплате труда машинистов</td>
					<xsl:apply-templates select="./Building/Machines" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent3 italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent3" colspan="7">оплата труда машинистов (ОТм)</td>
					<xsl:apply-templates select="./Building/MachinistSalary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">доплаты к оплате труда машинистов</td>
					<xsl:apply-templates select="./Building/MachinistSalaryExtra"
						mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">материальные ресурсы</td>
					<xsl:apply-templates select="./Building/Materials/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2 italic" colspan="10">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">материальные ресурсы без учета
						дополнительной перевозки</td>
					<xsl:apply-templates select="./Building/Materials/Price" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">дополнительная перевозка материальных
						ресурсов</td>
					<xsl:apply-templates select="./Building/Materials/Transport"
						mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">перевозка</td>
					<xsl:apply-templates select="./Building/Transport" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего ФОТ (справочно)</td>
					<xsl:apply-templates select="./Building/Salary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего накладные расходы</td>
					<xsl:apply-templates select="./Building/Overhead" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего сметная прибыль</td>
					<xsl:apply-templates select="./Building/Profit" mode="SummaryElement"/>
				</tr>
			</xsl:if>

			<xsl:if test="Mounting/Total/PriceCurrent != 0">
				<tr>
					<td colspan="12">&#160;</td>
				</tr>
				<tr class="bold">
					<td colspan="2"/>
					<td class="left bold" colspan="7">ВСЕГО монтажные работы</td>
					<xsl:apply-templates select="./Mounting/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<xsl:if test="$IndexType = 'Индексы к СМР'">
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">монтажные работы без учета перевозки, в том
							числе дополнительной</td>
						<xsl:apply-templates select="./Mounting/Price" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="12">&#160;</td>
					</tr>
				</xsl:if>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего прямые затраты</td>
					<xsl:apply-templates select="./Mounting/Direct" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">оплата труда (ОТ)</td>
					<xsl:apply-templates select="./Mounting/WorkersSalary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">эксплуатация машин и механизмов</td>
					<xsl:apply-templates select="./Mounting/MachinesTotal" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2 italic" colspan="10">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">эксплуатация машин и механизмов без учета
						доплат к оплате труда машинистов</td>
					<xsl:apply-templates select="./Mounting/Machines" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent3 italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent3" colspan="7">оплата труда машинистов (ОТм)</td>
					<xsl:apply-templates select="./Mounting/MachinistSalary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">доплаты к оплате труда машинистов</td>
					<xsl:apply-templates select="./Mounting/MachinistSalaryExtra"
						mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">материальные ресурсы</td>
					<xsl:apply-templates select="./Mounting/Materials/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2 italic" colspan="10">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">материальные ресурсы без учета
						дополнительной перевозки</td>
					<xsl:apply-templates select="./Mounting/Materials/Price" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">дополнительная перевозка материальных
						ресурсов</td>
					<xsl:apply-templates select="./Mounting/Materials/Transport"
						mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">перевозка</td>
					<xsl:apply-templates select="./Mounting/Transport" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего ФОТ (справочно)</td>
					<xsl:apply-templates select="./Mounting/Salary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего накладные расходы</td>
					<xsl:apply-templates select="./Mounting/Overhead" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего сметная прибыль</td>
					<xsl:apply-templates select="./Mounting/Profit" mode="SummaryElement"/>
				</tr>
			</xsl:if>

			<xsl:if test="Equipment/Total/PriceCurrent != 0">
				<tr>
					<td colspan="12">&#160;</td>
				</tr>
				<tr class="bold">
					<td colspan="2"/>
					<td class="left bold" colspan="7">ВСЕГО оборудование</td>
					<xsl:apply-templates select="./Equipment/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">оборудование без учета дополнительной
						перевозки</td>
					<xsl:apply-templates select="./Equipment/Price" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">дополнительная перевозка оборудования</td>
					<xsl:apply-templates select="./Equipment/Transport" mode="SummaryElement"/>
				</tr>
			</xsl:if>

			<xsl:if test="OtherTotal/PriceCurrent != 0">
				<tr>
					<td colspan="12">&#160;</td>
				</tr>
				<tr class="bold">
					<td colspan="2"/>
					<td class="left bold" colspan="7">ВСЕГО прочие затраты</td>
					<xsl:apply-templates select="./OtherTotal" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">прочие затраты</td>
					<xsl:apply-templates select="./Other" mode="SummaryElement"/>
				</tr>
				<xsl:if test="$IndexType = 'Индексы к СМР'">
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">прочие работы без учета перевозки, в том числе
							дополнительной</td>
						<xsl:apply-templates select="./OtherWorks/Price" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="12">&#160;</td>
					</tr>
				</xsl:if>
				<xsl:if test="$IndexType = 'Индексы к элементам прямых затрат'">
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">прочие работы</td>
						<xsl:apply-templates select="./OtherWorks/Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="12">&#160;</td>
					</tr>
				</xsl:if>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего прямые затраты</td>
					<xsl:apply-templates select="./OtherWorks/Direct" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">оплата труда (ОТ)</td>
					<xsl:apply-templates select="./OtherWorks/WorkersSalary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">эксплуатация машин и механизмов</td>
					<xsl:apply-templates select="./OtherWorks/MachinesTotal" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2 italic" colspan="10">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">эксплуатация машин и механизмов без учета
						доплат к оплате труда машинистов</td>
					<xsl:apply-templates select="./OtherWorks/Machines" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent3 italic" colspan="7">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent3" colspan="7">оплата труда машинистов (ОТм)</td>
					<xsl:apply-templates select="./OtherWorks/MachinistSalary" mode="SummaryElement"
					/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">доплаты к оплате труда машинистов</td>
					<xsl:apply-templates select="./OtherWorks/MachinistSalaryExtra"
						mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">материальные ресурсы</td>
					<xsl:apply-templates select="./OtherWorks/Materials/Total" mode="SummaryElement"
					/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2 italic" colspan="10">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">материальные ресурсы без учета
						дополнительной перевозки</td>
					<xsl:apply-templates select="./OtherWorks/Materials/Price" mode="SummaryElement"
					/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="7">дополнительная перевозка материальных
						ресурсов</td>
					<xsl:apply-templates select="./OtherWorks/Materials/Transport"
						mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="7">перевозка</td>
					<xsl:apply-templates select="./OtherWorks/Transport" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">всего ФОТ (справочно)</td>
					<xsl:apply-templates select="./OtherWorks/Salary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего накладные расходы</td>
					<xsl:apply-templates select="./OtherWorks/Overhead" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="7">Всего сметная прибыль</td>
					<xsl:apply-templates select="./OtherWorks/Profit" mode="SummaryElement"/>
				</tr>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="Restoration/RestorationElement/Total">
					<tr>
						<td colspan="12">&#160;</td>
					</tr>
					<tr class="bold">
						<td colspan="2"/>
						<td class="left bold" colspan="7">ВСЕГО ремонтно-реставрационные работы</td>
						<xsl:apply-templates select="./Restoration/RestorationElement/Total"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="7">
							<i>в том числе</i>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">ремонтно-реставрационные работы в
							базисном уровне цен 1984 года с пересчетом в уровень цен
							сметно-нормативной базы 2001 года</td>
						<xsl:apply-templates select="./Restoration/Restoration1984"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">ремонтно-реставрационные работы в уровне
							цен сметно-нормативной базы 2001 года с пересчетом в текущий уровень
							цен</td>
						<xsl:apply-templates select="./Restoration/Restoration2001"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="12">&#160;</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">Всего прямые затраты</td>
						<xsl:apply-templates select="./Summary/Direct" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="7">
							<i>в том числе</i>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">оплата труда (ОТ)</td>
						<xsl:apply-templates select="./Summary/WorkersSalary" mode="SummaryElement"
						/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">эксплуатация машин и механизмов</td>
						<xsl:apply-templates select="./Summary/MachinesTotal" mode="SummaryElement"
						/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="7">
							<i>в том числе</i>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">оплата труда машинистов (ОТм)</td>
						<xsl:apply-templates select="./Summary/MachinistSalary"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">материальные ресурсы</td>
						<xsl:apply-templates select="./Summary/Materials/Total"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">Всего ФОТ (справочно)</td>
						<xsl:apply-templates select="./Summary/Salary" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">Всего накладные расходы</td>
						<xsl:apply-templates select="./Summary/Overhead" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">Всего сметная прибыль</td>
						<xsl:apply-templates select="./Summary/Profit" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold" colspan="7">ВСЕГО прочие затраты</td>
						<xsl:apply-templates select="./Other" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold" colspan="7">ВСЕГО по смете</td>
						<xsl:apply-templates select="./Summary/Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold italic" colspan="10">Справочно</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">материальные ресурсы, отсутствующие в
							ФРСН</td>
						<xsl:apply-templates select="./Summary/Materials/External"
							mode="SummaryElement"/>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td colspan="12">&#160;</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold" colspan="7">ВСЕГО по смете</td>
						<xsl:apply-templates select="./Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">Всего прямые затраты</td>
						<xsl:apply-templates select="./Summary/Direct" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="7">
							<i>в том числе</i>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">оплата труда (ОТ)</td>
						<xsl:apply-templates select="./Summary/WorkersSalary" mode="SummaryElement"
						/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">эксплуатация машин и механизмов</td>
						<xsl:apply-templates select="./Summary/MachinesTotal" mode="SummaryElement"
						/>
					</tr>
					<xsl:if test="$IndexType = 'Индексы к СМР'">
						<tr>
							<td colspan="2"/>
							<td class="left indent2 italic" colspan="7">
								<i>в том числе</i>
							</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left indent2" colspan="7">оплата труда машинистов (ОТм)</td>
							<xsl:apply-templates select="./Summary/MachinistSalary"
								mode="SummaryElement"/>
						</tr>
					</xsl:if>
					<xsl:if test="$IndexType = 'Индексы к элементам прямых затрат'">
						<tr>
							<td colspan="2"/>
							<td class="left indent2 italic" colspan="7">
								<i>в том числе</i>
							</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left indent2" colspan="7">эксплуатация машин и механизмов без
								учета доплат к оплате труда машинистов</td>
							<xsl:apply-templates select="./Summary/Machines" mode="SummaryElement"/>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left indent3 italic" colspan="7">
								<i>в том числе</i>
							</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left indent3" colspan="7">оплата труда машинистов (ОТм)</td>
							<xsl:apply-templates select="./Summary/MachinistSalary"
								mode="SummaryElement"/>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left indent3" colspan="7">доплаты к оплате труда
								машинистов</td>
							<xsl:apply-templates select="./Summary/MachinistSalaryExtra"
								mode="SummaryElement"/>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">материальные ресурсы</td>
						<xsl:apply-templates select="./Summary/Materials/Total"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="10">
							<i>в том числе</i>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">материальные ресурсы без учета
							дополнительной перевозки</td>
						<xsl:apply-templates select="./Summary/Materials/Price"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">дополнительная перевозка материальных
							ресурсов</td>
						<xsl:apply-templates select="./Summary/Materials/Transport"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">перевозка</td>
						<xsl:apply-templates select="./Summary/Transport" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">Всего ФОТ (справочно)</td>
						<xsl:apply-templates select="./Summary/Salary" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">Всего накладные расходы</td>
						<xsl:apply-templates select="./Summary/Overhead" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">Всего сметная прибыль</td>
						<xsl:apply-templates select="./Summary/Profit" mode="SummaryElement"/>
					</tr>
					<tr class="bold">
						<td colspan="2"/>
						<td class="left" colspan="7">Всего оборудование</td>
						<xsl:apply-templates select="./Equipment/Total" mode="SummaryElement"/>
					</tr>
					<xsl:if test="$IndexType = 'Индексы к элементам прямых затрат'">
						<tr>
							<td colspan="2"/>
							<td class="left indent italic" colspan="7">
								<i>в том числе</i>
							</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left indent" colspan="7">оборудование без учета
								дополнительной перевозки</td>
							<xsl:apply-templates select="./Equipment/Price" mode="SummaryElement"/>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left indent" colspan="7">дополнительная перевозка
								оборудования</td>
							<xsl:apply-templates select="./Equipment/Transport"
								mode="SummaryElement"/>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="7">Всего прочие затраты</td>
						<xsl:apply-templates select="./OtherTotal" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="12">&#160;</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold italic" colspan="10">Справочно</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">материальные ресурсы, отсутствующие в
							ФРСН</td>
						<xsl:apply-templates select="./Summary/Materials/External"
							mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="7">оборудование, отсутствующее в ФРСН</td>
						<xsl:apply-templates select="./Equipment/External" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="4">затраты труда рабочих</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(Summary/LaborCosts)'/>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="4">затраты труда машинистов</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(Summary/MachinistLaborCosts)'/>
						</td>
					</tr>
					<xsl:if test="Commissioning/Idle/TotalBase != 0">
						<tr>
							<td colspan="12">&#160;</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left bold " colspan="7">ПНР «вхолостую»</td>
							<td class="bold">
								<xsl:value-of select='util:formatNumberWithZeroCheck(Commissioning/Idle/TotalBase)'/>
							</td>
							<td/>
							<td class="bold">
								<xsl:value-of select='util:formatNumberWithZeroCheck(Commissioning/Idle/TotalCur)'/>
							</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left italic" colspan="10">
								<i>в том числе</i>
							</td>
						</tr>
						<xsl:apply-templates select="Commissioning/Idle/Item" mode="comissioning"/>
					</xsl:if>
					<xsl:if test="Commissioning/UnderLoad/TotalBase != 0">
						<tr>
							<td colspan="2"/>
							<td class="left bold" colspan="7">ПНР «под нагрузкой»</td>
							<td class="bold">
								<xsl:value-of select='util:formatNumberWithZeroCheck(Commissioning/UnderLoad/TotalBase)'/>
							</td>
							<td/>
							<td class="bold">
								<xsl:value-of select='util:formatNumberWithZeroCheck(Commissioning/UnderLoad/TotalCur)'/>
							</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left italic" colspan="10">
								<i>в том числе</i>
							</td>
						</tr>
						<xsl:apply-templates select="Commissioning/UnderLoad/Item"
							mode="comissioning"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</tbody>
	</xsl:template>

	<!-- ПНР -->
	<xsl:template match="Item" mode="comissioning">
		<tr>
			<td/>
			<td style="text-align:left">
				<xsl:value-of select="Code"/>
			</td>
			<td style="text-align:left">
				<xsl:value-of select="Name"/>
			</td>
			<td>%</td>
			<td/>
			<td/>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(Quantity)'/>
			</td>
			<td/>
			<td/>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(BasePrice)'/>
			</td>
			<td/>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(CurrentPrice)'/>
			</td>
		</tr>
	</xsl:template>

	<!-- Позиция / свободная строка -->
	<xsl:template match="Items/FreeString">
		<xsl:param name="IndexType" select="0"/>
		<tr>
			<td colspan="12" class="left bbottom">
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>

	<!-- Разделы ВСЕ / свободная строка -->
	<xsl:template match="Sections/FreeString">
		<xsl:param name="IndexType" select="0"/>
		<tr>
			<td colspan="2"/>
			<td colspan="10" class="btop left">
				<xsl:value-of select="."/>
			</td>
		</tr>

	</xsl:template>

	<!-- Раздел (по каждому разделу / свободная строка -->
	<xsl:template match="Section/FreeString">
		<xsl:param name="IndexType" select="0"/>
		<tr>
			<td colspan="2"/>
			<td colspan="10" class="bbottom left">
				<xsl:value-of select="."/>
			</td>
		</tr>

	</xsl:template>

	<!-- Раздел -->
	<xsl:template match="Sections/Section">
		<xsl:param name="IndexType" select="0"/>
		<tbody>
			<tr>
				<td class="tborder center" colspan="12" id="{concat('Section',Code)}">
					<xsl:if test="Name = ''">
						<xsl:attribute name="class">center fieldError</xsl:attribute>
						<xsl:attribute name="title">Не заполнено название раздела</xsl:attribute>
					</xsl:if>
					<b>
						<xsl:value-of select="concat('Раздел: ', Code, ' ', Name)"/>
					</b>
				</td>
			</tr>
			<xsl:apply-templates select="Items/*">
				<xsl:with-param name="IndexType" select="$IndexType"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="SectionPrice" mode="Common">
				<xsl:with-param name="SectionCode" select="Code"/>
				<xsl:with-param name="SectionName" select="Name"/>
			</xsl:apply-templates>



		</tbody>
	</xsl:template>

	<!-- Концевик раздела  -->
	<xsl:template match="SectionPrice" mode="Common">
		<xsl:param name="SectionCode" select="0"/>
		<xsl:param name="SectionName" select="''"/>
		<tr>
			<td colspan="12">&#160;</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="7">Итого прямые затраты по Разделу <xsl:value-of
				select="concat($SectionCode, ' ', $SectionName)"/></td>
			<xsl:apply-templates select="./Summary/Direct" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent italic" colspan="7">
				<i>в том числе</i>
			</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="7">оплата труда (ОТ)</td>
			<xsl:apply-templates select="./Summary/WorkersSalary" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="7">эксплуатация машин и механизмов</td>
			<xsl:apply-templates select="./Summary/MachinesTotal" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent2 italic" colspan="7">
				<i>в том числе</i>
			</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent2" colspan="7">эксплуатация машин и механизмов без учета доплат к
				оплате труда машинистов</td>
			<xsl:apply-templates select="./Summary/Machines" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent3 italic" colspan="7">
				<i>в том числе</i>
			</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent3" colspan="7">оплата труда машинистов (ОТм)</td>
			<xsl:apply-templates select="./Summary/MachinistSalary" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent2" colspan="7">доплаты к оплате труда машинистов</td>
			<xsl:apply-templates select="./Summary/MachinistSalaryExtra" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="7">материальные ресурсы</td>
			<xsl:apply-templates select="./Summary/Materials/Total" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent2 italic" colspan="10">
				<i>в том числе</i>
			</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent2" colspan="7">материальные ресурсы без учета дополнительной
				перевозки</td>
			<xsl:apply-templates select="./Summary/Materials/Price" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent2" colspan="7">дополнительная перевозка материальных ресурсов</td>
			<xsl:apply-templates select="./Summary/Materials/Transport" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="7">перевозка</td>
			<xsl:apply-templates select="./Summary/Transport" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="7">Итого ФОТ</td>
			<xsl:apply-templates select="./Summary/Salary" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="7">Итого накладные расходы</td>
			<xsl:apply-templates select="./Summary/Overhead" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="7">Итого сметная прибыль</td>
			<xsl:apply-templates select="./Summary/Profit" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="7">Итого оборудование</td>
			<xsl:apply-templates select="./Equipment/Total" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent italic" colspan="10">
				<i>в том числе</i>
			</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="7">оборудование без учета дополнительной перевозки</td>
			<xsl:apply-templates select="./Equipment/Price" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="7">дополнительная перевозка оборудования</td>
			<xsl:apply-templates select="./Equipment/Transport" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="7">Итого прочие затраты</td>
			<xsl:apply-templates select="./OtherTotal" mode="SummaryElement"/>
		</tr>

		<tr>
			<td colspan="2"/>
			<td class="left bold" colspan="7">Итого по Разделу <xsl:value-of
				select="concat($SectionCode, ' ', $SectionName)"/></td>
			<xsl:apply-templates select="./Total" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="10">
				<i>в том числе</i>
			</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="7">материальные ресурсы, отсутствующие в ФРСН</td>
			<xsl:apply-templates select="./Summary/Materials/External" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="7">оборудование, отсутствующее в ФРСН</td>
			<xsl:apply-templates select="./Equipment/External" mode="SummaryElement"/>
		</tr>



		<xsl:apply-templates select="Sections/FreeString"/>


	</xsl:template>


	
	<!-- Позиция сметы -->
	<xsl:template match="Item">
		<xsl:param name="IndexType" select="0"/>
		<xsl:apply-templates select="Cost">
			<xsl:with-param name="IndexType" select="$IndexType"/>
		</xsl:apply-templates>
		
				
		<xsl:apply-templates select="Material | Equipment | Transport | Machine | Other" mode="ext"/>
		<xsl:if test="Cost or Machine">
			<xsl:apply-templates select="Resources/Material | Resources/Equipment" mode="item">
				<xsl:with-param name="CostNum" select="Cost/Num"/>
				<xsl:with-param name="IndexType" select="$IndexType"/>
			</xsl:apply-templates>
			<xsl:if test="Cost">
				<tr>
					<td/>
					<td/>
					<td class="left">ФОТ</td>
					<td/>
					<td/>
					<td/>
					<td/>
					<td/>
					<td/>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Cost/Totals/Base/Salary)'/>
					</td>
					<td/>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Cost/Totals/Current/Salary)'/>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="Machine">
				<tr>
					<td/>
					<td/>
					<td class="left">ОТм</td>
					<td/>
					<td/>
					<td/>
					<td/>
					<td/>
					<td/>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Machine/MachinistSalary)'/>
					</td>
					<td/>
					<td/>
				</tr>
			</xsl:if>
			<xsl:if test="./Overheads">
				<tr>
					<td/>
					<td class="left">
						<xsl:value-of select="./Overheads/Reason"/>
						<xsl:if test="./Overheads/Coefficients">_<xsl:apply-templates
								select="Overheads/Coefficients" mode="codes2"/></xsl:if>
					</td>
					<td class="left">НР <i>(<xsl:value-of select="./Overheads/Name"/>)</i></td>
					<td class="center">%</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Overheads/Value)'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Overheads/Coefficients/Final)'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Overheads/ValueTotal)'/>
					</td>
					<td/>
					<td/>
					<td><xsl:choose>
						
						<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Overheads/PriceBase1984)'/>
						</xsl:when>
						
						<xsl:otherwise>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Overheads/PriceBase)'/>
						</xsl:otherwise>
					</xsl:choose>
						
					</td>
					<td/>
					<td>
						<xsl:choose>
							
							<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
								<xsl:value-of select='util:formatNumberWithZeroCheck(./Overheads/PriceBase)'/>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:value-of select='util:formatNumberWithZeroCheck(./Overheads/PriceCur)'/>
							</xsl:otherwise>
						</xsl:choose>
						
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="./Profits">
				<tr>
					<td/>
					<td class="left">
						<xsl:value-of select="./Profits/Reason"/>
						<xsl:if test="./Profits/Coefficients">_<xsl:apply-templates
								select="Profits/Coefficients" mode="codes2"/></xsl:if>
					</td>
					<td class="left">СП <i>(<xsl:value-of select="./Profits/Name"/>)</i></td>
					<td class="center">%</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Profits/Value)'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Profits/Coefficients/Final)'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Profits/ValueTotal)'/>
					</td>
					<td/>
					<td/>
					<td>
						<xsl:choose>
							
							<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
								<xsl:value-of select='util:formatNumberWithZeroCheck(./Profits/PriceBase1984)'/>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:value-of select='util:formatNumberWithZeroCheck(./Profits/PriceBase)'/>
							</xsl:otherwise>
						</xsl:choose>
						
					</td>
					<td/>
					<td>
						<xsl:choose>
							
							<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
								<xsl:value-of select='util:formatNumberWithZeroCheck(./Profits/PriceBase)'/>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:value-of select='util:formatNumberWithZeroCheck(./Profits/PriceCur)'/>
							</xsl:otherwise>
						</xsl:choose>
						
					</td>
				</tr>
			</xsl:if>
		</xsl:if>
		<tr>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop bold left">Всего по позиции</td>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop bold">
				<xsl:choose>
					
					<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base1984)'/>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base)'/>
					</xsl:otherwise>
				</xsl:choose>
				
			</td>
			<td class="btop"/>
			<td class="btop bold">
				<xsl:choose>
					
					<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base)'/>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Current)'/>
					</xsl:otherwise>
				</xsl:choose>
				
			</td>
		</tr>
	</xsl:template>

	<!-- Расценка -->
	<xsl:template match="Cost">
		<xsl:param name="IndexType" select="0"/>
		<xsl:variable name="q" select='util:formatNumberWithZeroCheck(./Quantity)'/>
		<xsl:variable name="qt" select='util:formatNumberWithZeroCheck(./QuantityTotal)'/>
		<xsl:variable name="cls"/>
		<tr>
			<td class="center">
				<xsl:value-of select="./Num"/>
			</td>
			<td id="{concat('Cost',Num)}">
				<xsl:if test="Code = ''">
					<xsl:attribute name="class">fieldError</xsl:attribute>
					<xsl:attribute name="title">Не указан шифр позиции</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="concat(./Prefix, ' ', ./Code)"/>
			</td>
			<td class="left" style="width:100%" id="{concat('Name',Num)}">
				<xsl:if test="Name = ''">
					<xsl:attribute name="class">left fieldError</xsl:attribute>
					<xsl:attribute name="title">Не указано наименование позиции</xsl:attribute>
				</xsl:if>
				<div>
					<xsl:value-of select="./Name"/>
				</div>
			</td>
			<td class="center" id="{concat('Unit',Num)}">
				<xsl:if test="Unit = ''">
					<xsl:attribute name="class">center fieldError</xsl:attribute>
					<xsl:attribute name="title">Не указана единица измерения</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="Unit"/>
			</td>
			<td id="{concat('Quantity',Num)}">
				<xsl:if test="Quantity = 0">
					<xsl:attribute name="class">center fieldError</xsl:attribute>
					<xsl:attribute name="title">Не указан объем</xsl:attribute>
				</xsl:if>
				<xsl:value-of select='util:formatNumberWithZeroCheck(Quantity)'/>
			</td>
			<td>
				<xsl:value-of
					select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "Объем"]/CoefValue)'/>
			</td>
			<td id="{concat('QuantityTotal',Num)}">
				<xsl:if test="QuantityTotal = 0">
					<xsl:attribute name="class">center fieldError</xsl:attribute>
					<xsl:attribute name="title">Не указан объем всего</xsl:attribute>
				</xsl:if>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./QuantityTotal)'/>
			</td>
			<td/>
			<td/>
			<td/>
			<td/>
		</tr>
		
		<xsl:if test="../QTF">
			<tr>
				<td/>
				
				<td class="left" colspan="12">
					<xsl:value-of select="../QTF/FileNameQTF"/>
					<xsl:text>. Пункт - </xsl:text>
					<xsl:for-each select="../QTF">
						<xsl:for-each select="NumQTF">
							<xsl:value-of select="."/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
						<xsl:if test="position() != last()">
							<xsl:text>; </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
		
		<xsl:apply-templates select="./Coefficients/Coefficient" mode="incost"/>
		
		<xsl:if test="./Coefficients/Final/Values/Value[normalize-space()]">	
		<tr >
			<td/>
			<td/>
			<td class="btop left bold italic">Результирующие коэффициенты:
			</td>
			<td/>
			<td/>
			<td/>
			<td/>
			<td/>
			<td/>
			<td/>
			<td/>
			<td/>
		</tr>
		<tr>
			
				<td/>
				<td/>
				<td class="left italic bold" colspan="2">
					<xsl:for-each select="./Coefficients/Final/Values/Value">
						<xsl:choose>
							<xsl:when test="Target = 'ОТМ'">
								<xsl:text>ОТм</xsl:text> <!-- Замена 'ОТМ' на 'ОТм' -->
							</xsl:when>
							<xsl:when test="Target = 'МАТ'">
								<xsl:text>М</xsl:text> <!-- Замена 'МАТ' на 'М' -->
							</xsl:when>
							<xsl:when test="Target = 'ЗТМ'">
								<xsl:text>ЗТм</xsl:text> <!-- Замена 'ЗТМ' на 'ЗТм' -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select='Target'/> <!-- Вывод значения, если ни одно условие не выполнено -->
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text> </xsl:text> <!-- Пробел между Target и Formula -->
						<xsl:value-of select="Formula"/>
						<br/>
					</xsl:for-each>
				</td>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
			
		</tr>
		</xsl:if>
		
		
		<xsl:choose>
			<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
				<xsl:if test="./PerUnit/Base1984/WorkersSalary != 0">
					<tr>
						<td/>
						<td>1</td>
						<td class="left">ОТ</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base1984/WorkersSalary)'/>
						</td>
						<td>
							<xsl:value-of
								select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "ОТ"]/CoefValue)'/> 
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base1984/WorkersSalary)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Values/Value[./Target = "ОТ"]/Final)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/WorkersSalary)'/>
						</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="./PerUnit/Base/WorkersSalary != 0">
					<tr>
						<td/>
						<td>1</td>
						<td class="left">ОТ</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base/WorkersSalary)'/>
						</td>
						<td>
							<xsl:value-of
								select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "ОТ"]/CoefValue)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/WorkersSalary)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Values/Value[./Target = "ОТ"]/Final)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Current/WorkersSalary)'/>
						</td>
					</tr>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>


		<xsl:choose>
			<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
				
					<tr>
						<td/>
						<td>2</td>
						<td class="left">ЭМ</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base1984/Machines)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "ЭМ"]/CoefValue)' />
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base1984/Machines)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Values/Value[./Target = "ЭМ"]/Final)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/Machines)'/>
						</td>
					</tr>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="./PerUnit/Base/Machines != 0">
					<tr>
						<td/>
						<td>2</td>
						<td class="left">ЭМ</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base/Machines)'/>
						</td>
						<td>
							<xsl:value-of
								select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "ЭМ"]/CoefValue)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/Machines)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Values/Value[./Target = "ЭМ"]/Final)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Current/Machines)'/>
						</td>
					</tr>
				
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
		
		<xsl:choose>
			<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
				
				<xsl:if test="./PerUnit/Base1984/MachinistSalary != 0">
					<tr>
						<td/>
						<td>3</td>
						<td class="left">в т.ч. ОТм</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base1984/MachinistSalary)'/>
						</td>
						<td>
							<xsl:value-of
								select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "ОТМ"]/CoefValue)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base1984/MachinistSalary)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Values/Value[./Target = "ОТМ"]/Final)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/MachinistSalary)'/>
						</td>
					</tr>
				</xsl:if>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="./PerUnit/Base/MachinistSalary != 0">
					<tr>
						<td/>
						<td>3</td>
						<td class="left">в т.ч. ОТм</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base/MachinistSalary)'/>
						</td>
						<td>
							<xsl:value-of
								select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "ОТМ"]/CoefValue)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/MachinistSalary)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Values/Value[./Target = "ОТМ"]/Final)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Current/MachinistSalary)'/>
						</td>
					</tr>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
				
				<xsl:if test="./PerUnit/Base1984/Materials != 0">
					<tr>
						<td/>
						<td>4</td>
						<td class="left">М</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base1984/Materials)'/>
						</td>
						<td>
							<xsl:value-of
								select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "МАТ"]/CoefValue)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base1984/Materials)'/>
						</td>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/Materials)'/>
						</td>
					</tr>
				</xsl:if>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="./PerUnit/Base/Materials != 0">
					<tr>
						<td/>
						<td>4</td>
						<td class="left">М</td>
						<td/>
						<td/>
						<td/>
						<td/>
						<td>
							<xsl:value-of select="./PerUnit/Base/Materials"/>
						</td>
						<td>
							<xsl:value-of
								select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "МАТ"]/CoefValue)'/>
						</td>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/Materials)'/>
						</td>
						<td/>
						<td>
							<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Current/Materials)'/>
						</td>
					</tr>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
		
		<xsl:apply-templates select="Resources" mode="cost"/>
		<xsl:if test="./PerUnit/Natural/LaborCosts != 0">
			<tr>
				<td/>
				<td/>
				<td class="left">ЗТ</td>
				<td class="center">чел.-ч</td>
				<td>
					<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Natural/LaborCosts)'/>
				</td>
				<td>
					<xsl:value-of
						select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "ЗТ"]/CoefValue)'/>
				</td>
				<td>
					<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Natural/LaborCosts)'/>
				</td>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
			</tr>
		</xsl:if>
		<xsl:if test="./PerUnit/Natural/MachinistLaborCosts != 0">
			<tr>
				<td/>
				<td/>
				<td class="left">ЗТм</td>
				<td class="center">чел.-ч</td>
				<td>
					<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Natural/MachinistLaborCosts)'/>
				</td>
				<td>
					<xsl:value-of
						select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "ЗТМ"]/CoefValue)'/>
				</td>
				<td>
					<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Natural/MachinistLaborCosts)'/>
				</td>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
			</tr>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
				<tr>
					<td/>
					<td/>
					<td class="btop left">Итого по расценке</td>
					<td class="btop"/>
					<td class="btop"/>
					<td class="btop"/>
					<td class="btop"/>
					<td class="btop">
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base1984/Direct)'/>
					</td>
					<td class="btop"/>
					<td class="btop">
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base1984/Direct)'/>
					</td>
					<td class="btop"/>
					<td class="btop"><xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/Direct)'/>

					</td>
				</tr>	
				
				
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td/>
					<td/>
					<td class="btop left">Итого по расценке</td>
					<td class="btop"/>
					<td class="btop"/>
					<td class="btop"></td>
					<td class="btop"/>
					<td class="btop">
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PerUnit/Base/Direct)'/>
					</td>
					<td class="btop"/>
					<td class="btop">
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Totals/Base/Direct)'/>
					</td>
					<td class="btop"/>
					<td class="btop"/>
				</tr>	
				
			</xsl:otherwise>
		</xsl:choose>
		
		
		
		
		<xsl:if test="../Resources/Machine/Num != 0">
			<tr>
				<td><xsl:value-of select="../../../Code"/>.<xsl:value-of select="../Resources/Machine/Num"/></td>
				<td ><xsl:value-of select="../Resources/Machine/Code"/></td>
				<td ><xsl:value-of select="../Resources/Machine/Name"/></td>
				<td class="center"><xsl:value-of select="../Resources/Machine/Unit"/></td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/Consumption)'/></td>
				<td></td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/ConsumptionTotal)'/></td>	
				<td></td>
				<td></td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/Machinist/PriceTotalBase)'/>
</td>
				<td></td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/Machinist/PriceTotalCur)'/>
</td>
				
			</tr>
			
			<tr>
				<td></td>
				<td >2</td>
				<td class="left">ЭМ</td>
				<td class="center"></td>
				<td ></td>
				<td></td>
				<td ></td>	
				<td></td>
				<td></td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/PriceTotalBase)'/>
</td>
				<td></td>
				<td ></td>
				
			</tr>
			
			<tr>
				<td></td>
				<td >3</td>
				<td class="left">в т.ч. ОТм</td>
				<td class="center"></td>
				<td ></td>
				<td></td>
				<td ></td>	
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/Machinist/PricePerUnitBase)'/>
</td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/Machinist/Coefficients//Final/Values/Value/CoefValue)'/>
</td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/Machinist/PriceTotalBase)'/>
</td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/Machinist/Index/Value/Final)'/>
</td>
				<td ><xsl:value-of select='util:formatNumberWithZeroCheck(../Resources/Machine/Machinist/PriceTotalCur)'/>
</td>
				
			</tr>
		</xsl:if>
		
	</xsl:template>

	<!-- Перевозка материалов и оборудования -->
	<xsl:template match="Transport" mode="transport">
		<xsl:param name="ResNum"/>
		<xsl:param name="ResCode"/>
		<tr>
			<td class="center">
				<xsl:value-of select="concat($ResNum, '.', Num)"/>
			</td>
			<td class="left breakword" style="max-width: 100px;">
				<xsl:value-of select='concat($ResCode, "_", ./Code)'/>
			</td>
			<td class="left">
				<xsl:value-of select="./Name"/>
			</td>
			<td class="center">
				<xsl:value-of select="./Unit"/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Consumption)'/>
			</td>
			<td>
				<xsl:value-of
					select='./Coefficients/Final/Values/Value[./Target = "Расход"]/CoefValue'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./ConsumptionTotal)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase)'/>
			</td>
			<td>
				<xsl:value-of
					select='./Coefficients/Final/Values/Value[./Target = "Стоимость"]/CoefValue'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalBase)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Value/Final)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalCur)'/>
			</td>
		</tr>
	</xsl:template>

	<!-- Ресурсы расценки -->
	<xsl:template match="Material | Equipment | Transport | Machine" mode="cost">
		<tr>
			<td/>
			<td style="max-width: 100px; word-wrap: break-word;" class="right">
				<xsl:value-of select="./Code"/>
			</td>
			<td class="left">
				<xsl:value-of select="./Name"/>
			</td>
			<td class="center">
				<xsl:value-of select="./Unit"/>
			</td>
			<td>
				<xsl:if test="Consumption = 0">
					<span>П</span>
				</xsl:if>
				<xsl:if test="Consumption != 0">
					<xsl:value-of select='util:formatNumberWithZeroCheck(./Consumption)'/>
				</xsl:if>
			</td>
			<td>
				<xsl:value-of
					select='./Coefficients/Final/Values/Value[./Target = "Расход"]/CoefValue'/>
			</td>
			<td>
				<xsl:if test="ConsumptionTotal = 0">
					<span>П</span>
				</xsl:if>
				<xsl:if test="ConsumptionTotal != 0">
					<xsl:value-of select='util:formatNumberWithZeroCheck(./ConsumptionTotal)'/>
				</xsl:if>
			</td>
			<xsl:choose>
				<xsl:when test="starts-with(Code, 'ТЦ_')">
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur)'/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase)'/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<td>
				<xsl:value-of
					select='./Coefficients/Final/Values/Value[./Target = "Стоимость"]/CoefValue'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalBase)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Value/Final)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalCur)'/>
			</td>
			<xsl:apply-templates select="./Transport" mode="transport">
				<xsl:with-param name="ResCode" select="./Code"/>
			</xsl:apply-templates>
		</tr>
		<xsl:apply-templates select="./Coefficients/Coefficient" mode="incost"/>
	</xsl:template>

	<!-- Замененные ресурсы -->
	<xsl:template match="Material | Equipment | Transport | Machine" mode="item">
		<xsl:param name="CostNum" select="0"/>
		<xsl:param name="IndexType" select="0"/>
		<tr>
			<td class="center">
				<xsl:value-of select="concat($CostNum, '.', Num)"/>
			</td>
			<td class="left breakword" style="max-width: 100px;">
				<xsl:value-of select="./Code"/>
			</td>
			<td class="left">
				<xsl:value-of select="./Name"/>
			</td>
			<td class="center">
				<xsl:value-of select="./Unit"/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Consumption)'/>
			</td>
			<td>
				<xsl:value-of
					select='./Coefficients/Final/Values/Value[./Target = "Расход"]/CoefValue'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./ConsumptionTotal)'/>
			</td>
			<xsl:choose>
				<xsl:when test="/Construction/Object/Estimate/EstimateType = 'Реставрация'">
					<td>
						<xsl:choose>
							<xsl:when test="starts-with(Code, 'ТЦ_')">
								<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur1984)'/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase1984)'/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:value-of select='./Coefficients/Final/Values/Value[./Target = "Стоимость"]/CoefValue'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalBase1984)'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Index1984/Value/Final)'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalBase)'/>
					</td>
					
					<xsl:if test="./PricePerUnitBase &gt; 0 or ./PricePerUnitCur &gt; 0">
						<tr>
							<td></td>
							<td/>
							<td>
								<xsl:choose>
									<xsl:when test="./PricePerUnitBase &gt; 0 and string-length(./PricePerUnitBase1984Formula) &gt; 0  ">
										<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase1984Formula)'/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur1984Formula)'/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td/>
							<td/>
							<td/>
							<td/>
							<td><xsl:choose>
								<!-- Если данные из первого узла присутствуют, выводим их -->
								<xsl:when test="./PricePerUnitCur">
									<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur)'/>
								</xsl:when>
								<!-- Если данные из первого узла отсутствуют, выводим данные из второго узла -->
								<xsl:otherwise>
									<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase)'/>
								</xsl:otherwise>
							</xsl:choose>
							</td>
							<td/>
							<td/>
							<td/>
							<td/>
						</tr>
					</xsl:if>
					
					
					
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:choose>
							<xsl:when test="starts-with(Code, 'ТЦ_')">
								<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur)'/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase)'/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<xsl:value-of select='./Coefficients/Final/Values/Value[./Target = "Стоимость"]/CoefValue'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalBase)'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Value/Final)'/>
					</td>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalCur)'/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			
		</tr>
		<xsl:apply-templates select="./Coefficients/Coefficient" mode="incost"/>
		<xsl:apply-templates select="./Transport" mode="transport">
			<xsl:with-param name="ResNum" select="concat($CostNum, '.', Num)"/>
			<xsl:with-param name="ResCode" select="./Code"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Ресурсные позиции -->
	<xsl:template match="Material | Equipment | Transport | Machine | Other" mode="ext">
		<tr>
			<td class="center">
				<xsl:value-of select="./Num"/>
			</td>
			<td class="left breakword" style="max-width: 100px;">
				<xsl:value-of select="./Code"/>
			</td>
			<td class="left">
				<xsl:value-of select="./Name"/>
			</td>
			<td class="center">
				<xsl:value-of select="./Unit"/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Consumption)'/>
			</td>
			<td>
				<xsl:value-of select='./Coefficients/Final/Values/Value[./Target = "Расход"]/CoefValue'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./ConsumptionTotal)'/>
			</td>
			<xsl:choose>
				<xsl:when test="starts-with(Code, 'ТЦ_')">
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur)'/>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td>
						<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase)'/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<td>
				<xsl:value-of
					select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = "Стоимость"]/CoefValue)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalBase)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Value/Final)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalCur)'/>
			</td>
		</tr>
		
		<xsl:if test="../QTF">
			<tr>
				<td/>
				
				<td class="left" colspan="12">
					<xsl:value-of select="../QTF/FileNameQTF"/>
					<xsl:text>. Пункт - </xsl:text>
					<xsl:for-each select="../QTF">
						<xsl:for-each select="NumQTF">
							<xsl:value-of select="."/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
						<xsl:if test="position() != last()">
							<xsl:text>; </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>
		</xsl:if>
		
		<xsl:apply-templates select="./Coefficients/Coefficient" mode="incost"/>
		<xsl:apply-templates select="./Transport" mode="transport">
			<xsl:with-param name="ResNum" select="Num"/>
			<xsl:with-param name="ResCode" select="./Code"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Описание коэффициентов -->
	<xsl:template match="Coefficients/Coefficient" mode="names">
		<div class="italic">
			<div class="inline" style="display:block; border-top:1px dashed black">
				<xsl:apply-templates select="Values/Value" mode="coefDescr"/>
			</div>
			<div class="inline" style="display:block;">
				<xsl:value-of select="concat('&quot;', Name, '&quot;')"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Coefficients/Coefficient" mode="incost">
		<tr>
			<td class="center"/>
			<td>
				<xsl:value-of select="./Reason"/>
			</td>
			<td class="left italic" colspan="10">
				<xsl:value-of select="Name"/>
				<br/>
				<xsl:apply-templates select="Values/Value" mode="coefDescr"/>
			</td>
		</tr>
	</xsl:template>


	<!-- Коды коэффициентов для НР и СП -->
	<xsl:template match="Coefficients" mode="codes2">
		<xsl:for-each select="Coefficient">
			<xsl:value-of select="Reason"/>
			<xsl:if test="position() != last()">,</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- Коды коэффициентов 
	<xsl:template match="Coefficients/Coefficient" mode="codes">
		<div class="italic">
			<div class="inline" style="display:block; border-top:1px dashed black"><xsl:value-of select="concat('[',Reason,']')"/></div>
		</div>
	</xsl:template>
	-->

	<!-- Значения коэффициентов в описании -->
	<xsl:template match="Value" mode="coefDescr">
		<xsl:value-of select="concat(Target, '=', CoefValue, '; ')"/>
	</xsl:template>

	<!-- Шаблон форматно-логического контроля документа -->
	<xsl:template match="Construction" mode="validate">
		<div id="reportDiv" style="display:none">
			<div class="report">
				<h3>Результаты проверки файла:</h3>
				<ul>
					<xsl:if test="not(Object/Estimate/Num) or (Object/Estimate/Num = '')">
						<li class="err">
							<a id="erEstimateNum" href="EstimateNum"
								onclick="window.opener.document.getElementById(this.href).scrollIntoView(true); window.opener.focus(); return false;"
								>blank</a>
						</li>
						<script>
	            			s='Не указан номер локального сметного расчета'; 
	            			EstimateNum.title=s; 
	            			EstimateNum.classList.add("fieldError"); 
	            			erEstimateNum.innerHTML=s;
            		</script>
					</xsl:if>
					<xsl:if test="not(Meta/Soft/Name) or (Meta/Soft/Name = '')">
						<li class="err">
							<a id="erSoftName" href="SoftName"
								onclick="window.opener.document.getElementById(this.href).scrollIntoView(true); window.opener.focus(); return false;"
								>blank</a>
						</li>
						<script>

	            			s='Не указано название програмного продукта'; 
	            			SoftName.title=s; 
	            			SoftName.classList.add("fieldError"); 
	            			erSoftName.innerHTML=s; 

            		</script>
					</xsl:if>
					<xsl:if
						test="not(Object/Estimate/Legal/Main/Name) or (Object/Estimate/Legal/Main/Name = '')">
						<li class="err">
							<a id="erNormativeName" href="#"
								onclick="window.opener.document.getElementById(this.id.substr(2)).scrollIntoView(true); window.opener.focus(); return false;"
								>blank</a>
						</li>
						<script>

	            			s='Не указано наименование редакции сметных нормативов'; 
	            			LegalMainName.title=s; 
	            			LegalMainName.classList.add("fieldError"); 
	            			erNormativeName.innerHTML=s;

            		</script>
					</xsl:if>
					<xsl:if
						test="not(Object/Estimate/Legal/Main/Num) or (Object/Estimate/Legal/Main/Num = '')">
						<li class="err">
							<a id="erNormativeName" href="#"
								onclick="window.opener.document.getElementById(this.id.substr(2).scrollIntoView(true); window.opener.focus(); return false;"
								>blank</a>
						</li>
						<script> 
	            			s='Не указан регистрационный номер сметного норматива и дата его включения в Федеральный реестр сметных нормативов'; 
	            			LegalMainName.title=s; 
	            			LegalMainName.classList.add("fieldError"); 
	            			erNormativeLegal.innerHTML=s;

            		</script>
					</xsl:if>

					<xsl:for-each select="Object/Estimate/Sections/Section">
						<xsl:for-each select="Items/Item">
							<xsl:if test="Cost">
								<xsl:if test="not(Cost/Code) or (Cost/Code = '')">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.parent.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of
											select="concat('Не указан шифр позиции ', Cost/Num)"/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/Name) or (Cost/Name = '')">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of
											select="concat('Не указано наименование позиции ', Cost/Num)"
										/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/Unit) or (Cost/Unit = '')">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of
											select="concat('Не указана единица измерения расценки ', Cost/Num)"
										/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/Quantity) or (Cost/Quantity = 0)">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of
											select="concat('Не указано количество в расценке ', Cost/Num)"
										/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/QuantityTotal) or (Cost/QuantityTotal = 0)">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of
											select="concat('Не указано количество всего в расценке ', Cost/Num)"
										/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/PerUnit/*)">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of
											select="concat('Не заполнены показатели на единицу измерения в расценке ', Cost/Num)"
										/>
									</li>
								</xsl:if>
								<xsl:for-each select="Cost/Resources/*">
									<xsl:if test="not(Code) or (Code = '')">
										<li class="err">
											<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.parent.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
											<xsl:value-of
												select="concat('Не указан код ресурса', ../../Cost/Num)"
											/>
										</li>
									</xsl:if>
									<xsl:if test="not(Name) or (Name = '')">
										<li class="err">
											<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
											<xsl:value-of
												select="concat('Не указано наименование ресурса ', ../../Num)"
											/>
										</li>
									</xsl:if>
									<xsl:if test="not(Unit) or (Unit = '')">
										<li class="err">
											<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
											<xsl:value-of
												select="concat('Не указана единица измерения ресурса ', ../../Num)"
											/>
										</li>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</ul>
			</div>
		</div>
		<script>
			report = window.open(
				"",
				"report",
				"left=0, top=0, width=500, scrollbars, resizable" //resizable,
			  );
			  report.document.title = 'Результаты проверки файла локального сметного расчета';
			  report.document.body.innerHTML = styles.outerHTML + reportDiv.innerHTML; 
		</script>
	</xsl:template>
</xsl:stylesheet>
