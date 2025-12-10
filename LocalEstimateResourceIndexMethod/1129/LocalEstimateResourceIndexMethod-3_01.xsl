<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="http://www.gge.ru/utils" exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<!-- Возвращает строку или пусто. Аргумент теперь допускает последовательность. -->
	<xsl:function name="util:formatNumberWithZeroCheck" as="xs:string?">
		<xsl:param name="number" as="item()*"/>
		
		<!-- Берём первый атомизированный элемент из последовательности -->
		<xsl:variable name="n" select="(data($number))[1]"/>
		
		<xsl:choose>
			<!-- Пусто или NaN -->
			<xsl:when test="empty($n) or not(number($n) = number($n))">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="formattedNumber" select="format-number(number($n), '#,##0.00')"/>
				<xsl:variable name="translatedNumber" select="translate($formattedNumber, ',', ' ')"/>
				<xsl:value-of select="translate($translatedNumber, '.', ',')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="util:formatNumberNoRounding" as="xs:string?">
		<xsl:param name="number" as="item()*"/>
		<xsl:variable name="n" select="(data($number))[1]"/>
		
		<xsl:choose>
			<xsl:when test="empty($n) or not(number($n) = number($n))">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="formattedNumber" select="format-number(number($n), '#,##0.####################')"/>
				<xsl:variable name="translatedNumber" select="translate($formattedNumber, ',', ' ')"/>
				<xsl:value-of select="translate($translatedNumber, '.', ',')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<xsl:function name="util:formatNumberWithSevenDecimals" as="xs:string?">
		<xsl:param name="number" as="item()*"/>
		<xsl:variable name="n" select="(data($number))[1]"/>
		
		<xsl:choose>
			<xsl:when test="empty($n) or not(number($n) = number($n))">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="formattedNumber" select="format-number(number($n), '#,##0.#######')"/>
				<xsl:variable name="translatedNumber" select="translate($formattedNumber, ',', ' ')"/>
				<xsl:value-of select="translate($translatedNumber, '.', ',')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<!-- Главный шаблон и описание стилей CSS -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<style type="text/css" id="styles"> 
                    h1 { font-family: Times New Roman; font-size: 12pt; font-weight:bold; text-align:center; width:100%; margin-top: 2em; }
                    body,p,td { font-family: Times New Roman; font-size: 10pt; margin:0;}
                    
                    div.heading-left2 { margin-left:1.7em; display:flex; width:30%; margin-top: 0.5em; min-height: 1em;}
                    div.heading-left2 .headingvalue { border-bottom: 1px solid black; flex: 1; }

					div.heading-left3 { margin-left:1.7em; display:flex; width:50%; margin-top: 0.5em; min-height: 1em;}
                    div.heading-left3 .headingvalue { border-bottom: 1px solid black; flex: 1; }
                    
                    div.helptext { text-align:center; width:100%; margin-top:0;}
                    
                    div.headingname { white-space: nowrap; margin-right:0.3em; margin-left:0.3em; flex-grow: *; min-height: 1em;}
                    div.headingnametop { width:50%; margin-right:0.3em; margin-left:0.3em; flex-grow: *; min-height: 1em;}
                    
                    div.heading-left { display:flex; width:50%; margin-bottom: 0.5em; min-height: 1em;}
                    div.heading-left .headingvalue { border-bottom: 1px solid black; flex-grow: 2;}
                    
                    div.spacer {flex: 1; }

                    div.report { margin-bottom: 2em; margin-bottom: 2em; border-bottom:2px solid black; padding:0.5em 2em;}
                    div.report h3 {font-size: 120%; font-weight; bold}

                    div.heading {margin-right:2em; margin-left:2em; display:flex; margin-top: 1em; }
                    div.heading .headingvalue { border-bottom: 1px solid black; width:100%; min-height: 1em;}
                     
                    div.headingblock { display:flex; flex-direction: column; flex:3; margin-top:2em}
                    
                    .fieldError { color: red; }
                    td.fieldError { border: 1px solid red; }
                    div.fieldError .headingvalue { border-bottom: 1px solid black; flex-grow: 2;}                     

					.main { margin: 2em; }
                    .center {text-align:center;}
                    .right {text-align:right;}
                    .left {text-align:left;}
                    .leftmargin { padding-left:3em;}
                    .nowrap {white-space: nowrap;}
                    .top {vertical-align: top; }
					.italic {font-style: italic; }
					.inline {display: inline; }
					.breakword {word-wrap: break-word; }
					.indent {padding-left: 2em;}
					.indent2 {padding-left: 4em;}
					
                    .err { color:red; text-decoration: underline }
                    .err A { color:red; text-decoration: underline }
                    
                    table {border-collapse: collapse; width:100%; margin:2em 0; }
                    th {border: 1px solid black; padding: 0.5em; vertical-align: top;}
					td {border: 0px; padding: 0.2em 0.5em; vertical-align: top; text-align:right}
					td.tborder {border: 1px solid black}
					td.btop {border-top: 1px solid black}
					td.bbottom {border-bottom: 1px solid black;}
					td.bold {font-weight: bold}
					
		.even { background-color: #f2f2f2; } /* Светло-серый цвет */
		.odd { background-color: #ffffff; }  /* Белый цвет */
					

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
			
			<div class="heading-left2">
				<xsl:text>Дата и время выгрузки файла из сметного программного комплекса: </xsl:text>
				<xsl:value-of
					select="concat(substring(ExportDateTime, 9, 2), '.', substring(ExportDateTime, 6, 2), '.', substring(ExportDateTime, 1, 4), ' ', substring(ExportDateTime, 12, 5))"
				/>
			</div>
			
			<div class="heading" id="SoftName">
				<div class="headingnametop">Наименование программного продукта</div>
				<div class="headingvalue">
					<xsl:value-of select="concat(Meta/Soft/Name, ' ', Meta/Soft/Version)"/>
				</div>
			</div>
			<div class="heading" id="NormativeName">
				<div class="headingnametop">Наименование редакции сметных нормативов</div>
				<div class="headingvalue" id="LegalMainName">
					<xsl:value-of select="Object/Estimate/Legal/Main/Name"/>
					<xsl:value-of select="Object/Estimate/Legal/Metodology/Name"/>
					<xsl:value-of select="Object/Estimate/Legal/Overheads/Name"/>
					<xsl:value-of select="Object/Estimate/Legal/Profits/Name"/>
				</div>
			</div>
			<div class="heading" id="NormativeName">
				<div class="headingnametop">Реквизиты приказа Минстроя России об утверждении
					дополнений и изменений к сметным нормативам</div>
				<div class="headingvalue">
					<xsl:value-of select="Object/Estimate/Legal/Main/Orders"/>
					<xsl:text>;&#160;</xsl:text>
					<xsl:value-of select="Object/Estimate/Legal/Metodology/Orders"/>
					<xsl:text>;&#160;</xsl:text>
					<xsl:value-of select="Object/Estimate/Legal/Overheads/Orders"/>
					<xsl:text>;&#160;</xsl:text>
					<xsl:value-of select="Object/Estimate/Legal/Profits/Orders"/>
				</div>
			</div>
			<div class="heading" id="NormativeName">
				<div class="headingnametop">Реквизиты письма Минстроя России об индексах изменения
					сметной стоимости строительства, включаемые в федеральный реестр сметных
					нормативов и размещаемые в федеральной государственной информационной системе
					ценообразования в строительстве, подготовленного в соответствии пунктом 85
					Методики расчета индексов изменения сметной стоимости строительства,
					утвержденной приказом Министерства строительства и жилищно-коммунального
					хозяйства Российской Федерации от 5 июня 2019 г. № 326/пр 1</div>
				<div class="headingvalue">
					<xsl:value-of select="Object/Estimate/Legal/Indexes/Name"/>
					<xsl:text>;&#160;</xsl:text>
					<xsl:for-each select="Object/Estimate/Legal/Indexes">
						<xsl:value-of select="Orders"/>
						<xsl:if test="not(position() = last())">
							<xsl:text>,&#160;</xsl:text>
						</xsl:if>
					</xsl:for-each>
					
				</div>
			</div>
			<div class="heading" id="NormativeName">
				<div class="headingnametop">Реквизиты нормативного правового акта об утверждении
					оплаты труда, утверждаемый в соответствии с пунктом 22(1) Правилами мониторинга
					цен, утвержденными постановлением Правительства Российской Федерации от 23
					декабря 2016 г. № 1452</div>
				<div class="headingvalue">
					<xsl:value-of select="Object/Estimate/Salary"/>
				</div>
			</div>
			
			<div class="heading" id="NormativeName">
				<div class="headingnametop">Обоснование принятых текущих цен на строительные ресурсы</div>
				<div class="headingvalue">
					ФГИС ЦС&#160;
					<xsl:variable name="rawIndustry" select="Object/Estimate/Industry"/>
					<xsl:variable name="industryAbbreviation" select="normalize-space($rawIndustry)"/>
					
					<xsl:choose>
						<xsl:when test="$industryAbbreviation = 'АЛР'">
							АКЦИОНЕРНАЯ КОМПАНИЯ "АЛРОСА" (ПУБЛИЧНОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО)
						</xsl:when>
						<xsl:when test="$industryAbbreviation = 'РЖД'">
							ОТКРЫТОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО "РОССИЙСКИЕ ЖЕЛЕЗНЫЕ ДОРОГИ"
						</xsl:when>
						<xsl:when test="$industryAbbreviation = 'РСС'">
							ПУБЛИЧНОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО "ФЕДЕРАЛЬНАЯ СЕТЕВАЯ КОМПАНИЯ - РОССЕТИ"
						</xsl:when>
						<xsl:when test="$industryAbbreviation = 'РСТ'">
							ГОСУДАРСТВЕННАЯ КОРПОРАЦИЯ ПО АТОМНОЙ ЭНЕРГИИ "РОСАТОМ"
						</xsl:when>
						<xsl:when test="$industryAbbreviation = 'ТРН'">
							ПУБЛИЧНОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО "ТРАНСНЕФТЬ"
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$industryAbbreviation"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
			
			<div class="heading" id="NormativeName">
				<div class="headingnametop">Наименование субъекта Российской Федерации</div>
				<div class="headingvalue">
					<xsl:value-of select="Object/Estimate/Region/RegionName"/>
				</div>
			</div>
			<div class="heading" id="NormativeName">
				<div class="headingnametop">Наименование зоны субъекта Российской Федерации</div>
				<div class="headingvalue">
					<xsl:value-of select="Object/Estimate/Region/SubRegion/SubRegionName"/>
				</div>
			</div>

			<div class="heading">
				<div class="headingvalue center">
					<xsl:value-of select="Name"/>
				</div>
			</div>
			<div class="helptext">(наименование стройки)</div>

			<div class="heading">
				<div class="headingvalue center">
					<xsl:value-of select="Object/Name"/>
				</div>
			</div>
			<div class="helptext">(наименование объекта капитального строительства)</div>

			<h1 id="EstimateNum">ЛОКАЛЬНЫЙ СМЕТНЫЙ РАСЧЕТ (СМЕТА) №<xsl:value-of select="Object/Estimate/Num"/></h1>

			<div class="heading">
				<div class="headingvalue center">
					<xsl:value-of select="Object/Estimate/Name"/>
				</div>
			</div>
			<div class="helptext">(наименование работ и затрат)</div>

			<div class="heading-left">
				<div class="headingname">Составлен</div>
				<div class="headingvalue center">ресурсно-индексным</div>
				<div class="headingname">методом</div>
			</div>
			<div class="heading-left">
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
			<div class="heading-left" style="margin-top: 0;">
				<div class="helptext">(техническая документация)</div>
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
								<xsl:variable name="day">
									<xsl:choose>
										<xsl:when test="Object/Estimate/PriceLevelBase/Day">
											<xsl:value-of select="format-number(Object/Estimate/PriceLevelBase/Day, '00')"/>
										</xsl:when>
										<xsl:otherwise>01</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:variable name="month">
									<xsl:choose>
										<xsl:when test="Object/Estimate/PriceLevelBase/Month">
											<xsl:value-of select="format-number(Object/Estimate/PriceLevelBase/Month, '00')"/>
										</xsl:when>
										<xsl:when test="Object/Estimate/PriceLevelBase/Quarter">
											<xsl:choose>
												<xsl:when test="Object/Estimate/PriceLevelBase/Quarter = '1'">01</xsl:when>
												<xsl:when test="Object/Estimate/PriceLevelBase/Quarter = '2'">04</xsl:when>
												<xsl:when test="Object/Estimate/PriceLevelBase/Quarter = '3'">07</xsl:when>
												<xsl:when test="Object/Estimate/PriceLevelBase/Quarter = '4'">10</xsl:when>
												<xsl:otherwise>01</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>01</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:variable name="year">
									<xsl:choose>
										<xsl:when test="Object/Estimate/PriceLevelBase/Year">
											<xsl:value-of select="Object/Estimate/PriceLevelBase/Year"/>
										</xsl:when>
										<xsl:otherwise>0000</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:value-of select="concat($day, '.', $month, '.', $year)"/>
								)
							</xsl:if>
							
							
							
						</div>
					</div>
					<div class="heading">
						<div class="headingname">
							<b>Сметная стоимость</b>
						</div>
						<div class="headingvalue right">
							<xsl:if test="Object/Estimate/EstimatePrice/Total != 0"> 
								<xsl:value-of select="format-number(Object/Estimate/EstimatePrice/Total div 1000, '0.00')"/>
							</xsl:if>
							
						</div>
						<div class="headingname">тыс. руб.</div>
					</div>
					<div class="heading leftmargin">
						<div class="headingname italic">в том числе:</div>
					</div>
					<div class="heading leftmargin">
						<div class="headingname">
							<b>строительных работ</b>
						</div>
						<div class="headingvalue right">
							<xsl:if test="Object/Estimate/EstimatePrice/Building/Total != 0">
								
								<xsl:value-of select="format-number(Object/Estimate/EstimatePrice/Building/Total div 1000, '0.00')"/>
							</xsl:if>
						</div>
						<div class="headingname">тыс. руб.</div>
					</div>
					<div class="heading leftmargin">
						<div class="headingname">
							<b>монтажных работ</b>
						</div>
						<div class="headingvalue right">
							<xsl:if test="Object/Estimate/EstimatePrice/Mounting/Total != 0">
								
								<xsl:value-of select="format-number(Object/Estimate/EstimatePrice/Mounting/Total div 1000, '0.00')"/>
							</xsl:if>
						</div>
						<div class="headingname">тыс. руб.</div>
					</div>
					<div class="heading leftmargin">
						<div class="headingname">
							<b>оборудования</b>
						</div>
						<div class="headingvalue right">
							<xsl:if test="Object/Estimate/EstimatePrice/Equipment/Total != 0">
								
								<xsl:value-of select="format-number(Object/Estimate/EstimatePrice/Equipment/Total div 1000, '0.00')"/>
							</xsl:if>
						</div>
						<div class="headingname">тыс. руб.</div>
					</div>
					<div class="heading leftmargin">
						<div class="headingname">
							<b>прочих затрат</b>
						</div>
						<div class="headingvalue right">
							<xsl:if test="Object/Estimate/EstimatePrice/OtherTotal != 0">
								
								<xsl:value-of select="format-number(Object/Estimate/EstimatePrice/OtherTotal div 1000, '0.00')"/>
							</xsl:if>
						</div>
						<div class="headingname">тыс. руб.</div>
					</div>
				</div>
				<div class="spacer"/>
				<div class="headingblock" style="margin-top: 8em">
					<div class="heading">
						<div class="headingname">Средства на оплату труда рабочих</div>
						<div class="headingvalue right">
							<xsl:if test="Object/Estimate/EstimatePrice/Summary/WorkersSalary != 0">
								
								<xsl:value-of select="format-number(Object/Estimate/EstimatePrice/Summary/WorkersSalary div 1000, '0.00')"/>
							</xsl:if>
						</div>
					</div>
					<div class="heading">
						<div class="headingname">Средства на оплату труда машинистов</div>
						<div class="headingvalue right" style="white-space: nowrap;">
							<xsl:if test="Object/Estimate/EstimatePrice/Summary/MachinistSalary != 0">
								
								<xsl:value-of select="format-number(Object/Estimate/EstimatePrice/Summary/MachinistSalary div 1000, '0.00')"/>
							</xsl:if>
						</div>
					</div>
					<div class="heading">
						<div class="headingname">Нормативные затраты труда рабочих</div>
<!--						<div class="headingvalue right"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Estimate/EstimatePrice/Summary/LaborCosts)"/> чел.-ч.</div>-->
						<div class="headingvalue right"><xsl:value-of select="util:formatNumberNoRounding(Object/Estimate/EstimatePrice/Summary/LaborCosts)"/> чел.-ч.</div>
					</div>
					<div class="heading">
						<div class="headingname">Нормативные затраты труда машинистов</div>
<!--						<div class="headingvalue right"><xsl:value-of select="format-number(Object/Estimate/EstimatePrice/Summary/MachinistLaborCosts, '0.00')"/> чел.-ч.</div>-->
						<div class="headingvalue right"><xsl:value-of select="util:formatNumberNoRounding(Object/Estimate/EstimatePrice/Summary/MachinistLaborCosts)"/> чел.-ч.</div>
					</div>
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
		<table>
			<thead>
				<tr>
					<th scope="col" rowspan="2">№ п.п.</th>
					<th scope="col" rowspan="2" nowrap="nowrap">Обоснование</th>
					<th scope="col" rowspan="2">Наименование работ и затрат</th>
					<th scope="col" rowspan="2">Единица измерения</th>
					<th colspan="3">Количество</th>
					<th colspan="5">Сметная стоимость, руб. </th>
				</tr>
				<tr>
					<th scope="col">на единицу измерения</th>
					<th scope="col">коэффи-циенты</th>
					<th scope="col">всего с учетом коэффи-циента</th>
					<th scope="col">на единицу измерения в базисном уровне цен</th>
					<th scope="col">индекс</th>
					<th scope="col">на единицу измерения в текущем уровне цен</th>
					<th scope="col">коэффи-циенты</th>
					<th scope="col">всего в текущем уровне цен</th>
				</tr>
				<tr>
					<td class="tborder center">1</td>
					<td class="tborder center">2</td>
					<td class="tborder center">3</td>
					<td class="tborder center">4</td>
					<td class="tborder center">5</td>
					<td class="tborder center">6</td>
					<td class="tborder center">7</td>
					<td class="tborder center">8</td>
					<td class="tborder center">9</td>
					<td class="tborder center">10</td>
					<td class="tborder center">11</td>
					<td class="tborder center">12</td>
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
		<br/>
		<br/>
		
	</xsl:template>

	<!-- Концевик сметы -->
	<xsl:template match="EstimatePrice" mode="Common">
		<xsl:param name="IndexType" select="0"/>
		<tbody>
			<tr>
				<td style="border-top:1px solid black"> </td>
				<td style="border-top:1px solid black"> </td>
				<td colspan="10" class="bold left" style="border-top:1px solid black;">ИТОГИ ПО СМЕТЕ</td>
			</tr>

			<xsl:if test="Building/Total != 0">
				<tr>
					<td colspan="12"> </td>
				</tr>
				<tr class="bold">
					<td colspan="2"/>
					<td class="left bold" colspan="9">ВСЕГО строительные работы</td>
					<xsl:apply-templates select="./Building/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left italic" colspan="9">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего прямые затраты</td>
					<xsl:apply-templates select="./Building/Direct" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent italic" colspan="9">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">оплата труда (ОТ)</td>
					<xsl:apply-templates select="./Building/WorkersSalary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">эксплуатация машин и механизмов</td>
					<xsl:apply-templates select="./Building/Machines" mode="SummaryElement"/>
				</tr>
				<xsl:if test="number(./Building/MachinistSalary) &gt; 0">
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">оплата труда машинистов (ОТм)</td>
						<xsl:apply-templates select="./Building/MachinistSalary" mode="SummaryElement"/>
					</tr>
				</xsl:if>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">материальные ресурсы</td>
					<xsl:apply-templates select="./Building/Materials/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">перевозка</td>
					<xsl:apply-templates select="./Building/Transport" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего ФОТ</td>
					<xsl:apply-templates select="./Building/Salary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего накладные расходы</td>
					<xsl:apply-templates select="./Building/Overhead" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего сметная прибыль</td>
					<xsl:apply-templates select="./Building/Profit" mode="SummaryElement"/>
				</tr>
			</xsl:if>

			<xsl:if test="Mounting/Total != 0">
				<tr>
					<td colspan="12"> </td>
				</tr>
				<tr class="bold">
					<td colspan="2"/>
					<td class="left bold" colspan="9">ВСЕГО монтажные работы</td>
					<xsl:apply-templates select="./Mounting/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left italic" colspan="9">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего прямые затраты</td>
					<xsl:apply-templates select="./Mounting/Direct" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent italic" colspan="9">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">оплата труда (ОТ)</td>
					<xsl:apply-templates select="./Mounting/WorkersSalary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">эксплуатация машин и механизмов</td>
					<xsl:apply-templates select="./Mounting/Machines" mode="SummaryElement"/>
				</tr>
				<xsl:if test="number(./Mounting/MachinistSalary) &gt; 0">
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">оплата труда машинистов (ОТм)</td>
						<xsl:apply-templates select="./Mounting/MachinistSalary" mode="SummaryElement"/>
					</tr>
				</xsl:if>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">материальные ресурсы</td>
					<xsl:apply-templates select="./Mounting/Materials/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">перевозка</td>
					<xsl:apply-templates select="./Mounting/Transport" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего ФОТ</td>
					<xsl:apply-templates select="./Mounting/Salary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего накладные расходы</td>
					<xsl:apply-templates select="./Mounting/Overhead" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего сметная прибыль</td>
					<xsl:apply-templates select="./Mounting/Profit" mode="SummaryElement"/>
				</tr>
			</xsl:if>

			<xsl:if test="Equipment/Total != 0">
				<tr>
					<td colspan="12"> </td>
				</tr>
				<tr class="bold">
					<td colspan="2"/>
					<td class="left bold" colspan="9">ВСЕГО оборудование</td>
					<xsl:apply-templates select="./Equipment/Total" mode="SummaryElement"/>
				</tr>
			</xsl:if>

			<xsl:if test="OtherTotal != 0">
				<tr>
					<td colspan="12"> </td>
				</tr>
				<tr class="bold">
					<td colspan="2"/>
					<td class="left bold" colspan="9">ВСЕГО прочие затраты</td>
					<xsl:apply-templates select="./OtherTotal" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left italic" colspan="9">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">прочие затраты</td>
					<xsl:apply-templates select="./Other" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">прочие работы</td>
					<xsl:apply-templates select="./OtherWorks/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего прямые затраты</td>
					<xsl:apply-templates select="./OtherWorks/Direct" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent italic" colspan="9">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">оплата труда (ОТ)</td>
					<xsl:apply-templates select="./OtherWorks/WorkersSalary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">эксплуатация машин и механизмов</td>
					<xsl:apply-templates select="./OtherWorks/Machines" mode="SummaryElement"/>
				</tr>
				<xsl:if test="number(./OtherWorks/MachinistSalary) &gt; 0">
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">оплата труда машинистов (ОТм)</td>
						<xsl:apply-templates select="./OtherWorks/MachinistSalary" mode="SummaryElement"/>
					</tr>
				</xsl:if>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">материальные ресурсы</td>
					<xsl:apply-templates select="./OtherWorks/Materials/Total" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2 italic" colspan="10">
						<i>в том числе</i>
					</td>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="9">материальные ресурсы без учета дополнительной перевозки</td>
					<xsl:apply-templates select="./OtherWorks/Materials/Price" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent2" colspan="9">дополнительная перевозка материальных ресурсов</td>
					<xsl:apply-templates select="./OtherWorks/Materials/Transport" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left indent" colspan="9">перевозка</td>
					<xsl:apply-templates select="./OtherWorks/Transport" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">всего ФОТ (справочно)</td>
					<xsl:apply-templates select="./OtherWorks/Salary" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего накладные расходы</td>
					<xsl:apply-templates select="./OtherWorks/Overhead" mode="SummaryElement"/>
				</tr>
				<tr>
					<td colspan="2"/>
					<td class="left" colspan="9">Всего сметная прибыль</td>
					<xsl:apply-templates select="./OtherWorks/Profit" mode="SummaryElement"/>
				</tr>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="Restoration/RestorationElement/Total != 0">
					<tr>
						<td colspan="12"> </td>
					</tr>
					<tr class="bold">
						<td colspan="2"/>
						<td class="left bold" colspan="9">ВСЕГО ремонтно-реставрационные работы</td>
						<xsl:apply-templates select="./Restoration/RestorationElement/Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="9">
							<i>в том числе</i>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">ремонтно-реставрационные работы в базисном уровне цен 1984 года с пересчетом в уровень цен сметно-нормативной базы 2001 года</td>
						<xsl:apply-templates select="./Restoration/RestorationElement/Restoration1984" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">ремонтно-реставрационные работы в уровне цен сметно-нормативной базы 2001 года с пересчетом в текущий уровень цен</td>
						<xsl:apply-templates select="./Restoration/RestorationElement/Restoration2001" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="12"> </td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">Всего прямые затраты</td>
						<xsl:apply-templates select="./Summary/Direct" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="9">
							<i>в том числе</i>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">оплата труда (ОТ)</td>
						<xsl:apply-templates select="./Summary/WorkersSalary" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">эксплуатация машин и механизмов</td>
						<xsl:apply-templates select="./Summary/Machines" mode="SummaryElement"/>
					</tr>
					<xsl:if test="number(./Summary/MachinistSalary) &gt; 0">
						<tr>
							<td colspan="2"/>
							<td class="left indent italic" colspan="9">
								<i>в том числе</i>
							</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left indent" colspan="9">оплата труда машинистов (ОТм)</td>
							<xsl:apply-templates select="./Summary/MachinistSalary" mode="SummaryElement"/>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">материальные ресурсы</td>
						<xsl:apply-templates select="./Summary/Materials/Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="9">Всего ФОТ (справочно)</td>
						<xsl:apply-templates select="./Summary/Salary" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="9">Всего накладные расходы</td>
						<xsl:apply-templates select="./Summary/Overhead" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="9">Всего сметная прибыль</td>
						<xsl:apply-templates select="./Summary/Profit" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold" colspan="9">ВСЕГО прочие затраты</td>
						<xsl:apply-templates select="./Other" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold" colspan="9">ВСЕГО по смете</td>
						<xsl:apply-templates select="./Summary/Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold italic" colspan="10">Справочно</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">материальные ресурсы, отсутствующие в ФРСН</td>
						<xsl:apply-templates select="./Summary/Materials/External" mode="SummaryElement"/>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td colspan="12"> </td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold" colspan="9">ВСЕГО по смете</td>
						<xsl:apply-templates select="./Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="9">Всего прямые затраты</td>
						<xsl:apply-templates select="./Summary/Direct" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="9">
							<i>в том числе</i>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">оплата труда (ОТ)</td>
						<xsl:apply-templates select="./Summary/WorkersSalary" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">эксплуатация машин и механизмов</td>
						<xsl:apply-templates select="./Summary/Machines" mode="SummaryElement"/>
					</tr>
					<xsl:if test="number(./Summary/MachinistSalary) &gt; 0">
						<tr>
							<td colspan="2"/>
							<td class="left indent" colspan="9">оплата труда машинистов (ОТм)</td>
							<xsl:apply-templates select="./Summary/MachinistSalary" mode="SummaryElement"/>
						</tr>
					</xsl:if>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">материальные ресурсы</td>
						<xsl:apply-templates select="./Summary/Materials/Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="10">
<!--							<i>в том числе</i>-->
						</td>
					</tr>
					<!--<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">материальные ресурсы без учета дополнительной перевозки</td>
						<xsl:apply-templates select="./Summary/Materials/Price" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">дополнительная перевозка материальных ресурсов</td>
						<xsl:apply-templates select="./Summary/Materials/Transport" mode="SummaryElement"/>
					</tr>-->
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">перевозка</td>
						<xsl:apply-templates select="./Summary/Transport" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="9">Всего ФОТ </td>
						<xsl:apply-templates select="./Summary/Salary" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="9">Всего накладные расходы</td>
						<xsl:apply-templates select="./Summary/Overhead" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="9">Всего сметная прибыль</td>
						<xsl:apply-templates select="./Summary/Profit" mode="SummaryElement"/>
					</tr>
					<tr class="bold">
						<td colspan="2"/>
						<td class="left" colspan="9">Всего оборудование</td>
						<xsl:apply-templates select="./Equipment/Total" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent italic" colspan="9">
							<!--<i>в том числе</i>-->
						</td>
					</tr>
					<!--<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">оборудование без учета дополнительной перевозки</td>
						<xsl:apply-templates select="./Equipment/Price" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">дополнительная перевозка оборудования</td>
						<xsl:apply-templates select="./Equipment/Transport" mode="SummaryElement"/>
					</tr>-->
					<tr>
						<td colspan="2"/>
						<td class="left" colspan="9">Всего прочие затраты</td>
						<xsl:apply-templates select="./OtherTotal" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="12"> </td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left bold italic" colspan="10">Справочно</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">материальные ресурсы, отсутствующие в ФРСН</td>
						<xsl:apply-templates select="./Summary/Materials/External" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="9">оборудование, отсутствующее в ФРСН</td>
						<xsl:apply-templates select="./Equipment/External" mode="SummaryElement"/>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="4">затраты труда рабочих</td>
						<td>
							<xsl:value-of select="Summary/LaborCosts"/>
						</td>
					</tr>
					<tr>
						<td colspan="2"/>
						<td class="left indent" colspan="4">затраты труда машинистов</td>
						<td>
							<xsl:value-of select="Summary/MachinistLaborCosts"/>
						</td>
					</tr>
					<xsl:if test="Commissioning/Idle/Total != 0">
						<tr>
							<td colspan="12"> </td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left bold " colspan="9">ПНР «вхолостую»</td>
							<td class="bold">
								<xsl:value-of select="Commissioning/Idle/Total"/>
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
					<xsl:if test="Commissioning/UnderLoad/Total != 0">
						<tr>
							<td colspan="2"/>
							<td class="left bold " colspan="9">ПНР «под нагрузкой»</td>
							<td class="bold"> 
								<xsl:value-of select="Commissioning/UnderLoad/Total"/>
							</td>
						</tr>
						<tr>
							<td colspan="2"/>
							<td class="left italic" colspan="10">
								<i>в том числе</i>
							</td>
						</tr>
						<xsl:apply-templates select="Commissioning/UnderLoad/Item" mode="comissioning"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</tbody>
	</xsl:template>

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
				<xsl:value-of select="Quantity"/>
			</td>
			<td/>
			<td/>
			<td/>
			<td/>
			<td>
				<xsl:value-of select="CurrentPrice"/>
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
		<tbody>
			<tr>
				<td class="tborder left" colspan="12" id="{concat('Section',Code)}">
					<xsl:if test="Name = ''">
						<xsl:attribute name="class">left fieldError</xsl:attribute>
						<xsl:attribute name="title">Не заполнено название раздела</xsl:attribute>
					</xsl:if>
					<b>
						<xsl:value-of select="concat('Раздел: ', Code, ' ', Name)"/>
					</b>
				</td>
			</tr>
				<xsl:apply-templates select="Items/*"/> 
			<xsl:apply-templates select="SectionPrice">
				<xsl:with-param name="SectionCode" select="Code"/>
				<xsl:with-param name="SectionName" select="Name"/>
			</xsl:apply-templates>
				<!--<tr> 
				<td class="btop  left" colspan="12">
					<xsl:value-of select="./FreeString"/>
				</td>-->
			<!--</tr>-->	
		</tbody>
	</xsl:template>

	<!-- Значения в итогах -->
	<xsl:template match="*" mode="SummaryElement">
		<td>
			<xsl:if test=". != 0">
				<xsl:value-of select="."/>
			</xsl:if>
		</td>
	</xsl:template>

	<!-- Концевик раздела -->
	<xsl:template match="SectionPrice">
		<xsl:param name="SectionCode" select="0"/>
		<xsl:param name="SectionName" select="1"/>
		<tr>
			<td colspan="2"/>
			<td class="left bold" colspan="9">Итого прямые затраты по разделу <xsl:value-of select="$SectionCode"/>.<xsl:value-of select="$SectionName"/></td>
			<xsl:apply-templates select="Summary/Direct" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent italic" colspan="10">
				<i>в том числе</i>
			</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="9">оплата труда (ОТ)</td>
			<xsl:apply-templates select="Summary/WorkersSalary" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="9">эксплуатация машин и механизмов</td>
			<xsl:apply-templates select="Summary/Machines" mode="SummaryElement"/>
		</tr>
		<xsl:if test="number(Summary/MachinistSalary) &gt; 0">
			<tr>
				<td colspan="2"/>
				<td class="left indent" colspan="9">оплата труда машинистов (ОТм)</td>
				<xsl:apply-templates select="Summary/MachinistSalary" mode="SummaryElement"/>
			</tr>
		</xsl:if>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="9">материальные ресурсы </td>
			<xsl:apply-templates select="Summary/Materials/Total" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="9">перевозка</td>
			<xsl:apply-templates select="Summary/Transport" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="9">Итого ФОТ</td>
			<xsl:apply-templates select="Summary/Salary" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="9">Итого накладные расходы</td>
			<xsl:apply-templates select="Summary/Overhead" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="9">Итого сметная прибыль</td>
			<xsl:apply-templates select="Summary/Profit" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="9">Итого оборудование</td>
			<xsl:apply-templates select="Summary/Equipment/Total" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left" colspan="9">Итого прочие затраты</td>
			<xsl:apply-templates select="Summary/OtherTotal" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left bold" colspan="9">Итого по разделу <xsl:value-of select="$SectionCode"/>.<xsl:value-of select="$SectionName"/></td>
			<xsl:apply-templates select="Total" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left bold" colspan="9">Справочно</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="9">материальные ресурсы, отсутствующие в ФРСН</td>
			<xsl:apply-templates select="./Summary/Materials/External" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="9">оборудование, отсутствующее в ФРСН</td>
			<xsl:apply-templates select="./Equipment/External" mode="SummaryElement"/>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="4">затраты труда рабочих</td>
			<td>
				<xsl:value-of select="Summary/LaborCosts"/>
			</td>
		</tr>
		<tr>
			<td colspan="2"/>
			<td class="left indent" colspan="4">затраты труда машинистов</td>
			<td>
				<xsl:value-of select="Summary/MachinistLaborCosts"/>
			</td>
		</tr>
	</xsl:template>

	<!-- Позиция сметы -->
	<xsl:template match="Item">
		<xsl:param name="IndexType" select="0"/>
		<xsl:apply-templates select="Cost"/>
		<xsl:apply-templates select="Machine | Material | Equipment | Transport | Other" mode="ext"/>
		<xsl:if test="Cost or Machine">
			<xsl:apply-templates select="Resources/Machine | Resources/Material | Resources/Equipment" mode="item">
				<xsl:with-param name="CostNum" select="Cost/Num"/>
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
				<td/>
				<td/>
				<td>
					<xsl:value-of select="./Cost/Totals/Current/Salary"/>
				</td>
			</tr>
			</xsl:if>
			<xsl:if test="number(./Machine/MachinistSalary) &gt; 0">
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
						<xsl:value-of select="./Machine/MachinistSalary"/>
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
						<xsl:if test="./Overheads/Coefficients">_<xsl:apply-templates select="Overheads/Coefficients" mode="codes2"/></xsl:if>
					</td>
					<td class="left">НР <i>(<xsl:value-of select="./Overheads/Name"/>)</i></td>
					<td class="center">%</td>
					<td>
						<xsl:value-of select="./Overheads/Value"/>
					</td>
					<td>
						<xsl:value-of select="./Overheads/Coefficients/Final"/>
					</td>
					<td>
						<xsl:value-of select="./Overheads/ValueTotal"/>
					</td>
					<td/>
					<td/>
					<td/>
					<td/>
					<td>
						<xsl:value-of select="./Overheads/PriceCur"/>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="./Profits">
				<tr>
					<td/>
					<td class="left">
						<xsl:value-of select="./Profits/Reason"/>
						<xsl:if test="./Profits/Coefficients">_<xsl:apply-templates select="Profits/Coefficients" mode="codes2"/></xsl:if>
					</td>
					<td class="left">СП <i>(<xsl:value-of select="./Profits/Name"/>)</i></td>
					<td class="center">%</td>
					<td>
						<xsl:value-of select="./Profits/Value"/>
					</td>
					<td>
						<xsl:value-of select="./Profits/Coefficients/Final"/>
					</td>
					<td>
						<xsl:value-of select="./Profits/ValueTotal"/>
					</td>
					<td/>
					<td/>
					<td/>
					<td/>
					<td>
						<xsl:value-of select="./Profits/PriceCur"/>
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
			<td class="btop">
				<xsl:value-of select="./TotalsUnit/Current"/>
			</td>
			<td class="btop"/>
			<td class="btop bold">
				<xsl:value-of select="./Totals/Current"/>
			</td>
		</tr>
		
		<!-- TODO MAX 
		<tr>
			<td class="btop  left" colspan="12">
				<xsl:value-of select="../FreeString"/>
			</td>
		</tr> -->
		
	</xsl:template>

	<!-- Расценка -->
	<xsl:template match="Cost">
		<xsl:variable name="q" select="./Quantity"/>
		<xsl:variable name="qt" select="./QuantityTotal"/>
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
				<xsl:value-of select="Quantity"/>
			</td>
			<td>
				<xsl:value-of select='./Coefficients/Final[./Scope = "Объем"]/Values/Value[./Target = "Объем"]/CoefValue'/> 
				<xsl:value-of select='./Coefficients/Final/Values/Value[./Target = "Объем"]/CoefValue'/> 
				
				<!--<xsl:variable name="formula" select="QuantityFormula" />
				<xsl:choose>
					<xsl:when test="string-length($formula) > 0">
						
						<xsl:variable name="normalizedFormula" select="translate($formula, ',', '.')" />
						
						
						<xsl:choose>
							<xsl:when test="contains($normalizedFormula, '*')">
								<xsl:variable name="part1" select="substring-before($normalizedFormula, '*')" />
								<xsl:variable name="afterMultiplication" select="substring-after($normalizedFormula, '*')" />
								<xsl:variable name="part2" select="substring-before($afterMultiplication, '/')" />
								<xsl:variable name="divider" select="substring-after($afterMultiplication, '/')" />
								
								
								<xsl:choose>
									<xsl:when test="string-length($divider) > 0">
										<xsl:variable name="result" select="(number($part1) * number($part2)) div number($divider)" />
										<xsl:choose>
											<!-\- Check for NaN using the 'number()' test -\->
											<xsl:when test="not($result != $result)">
												<xsl:value-of select="$result" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:text></xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="result" select="number($part1) * number($part2)" />
										<xsl:choose>
											
											<xsl:when test="not($result != $result)">
												<xsl:value-of select="$result" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:text></xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								
								<xsl:variable name="result" select="number($normalizedFormula)" />
								<xsl:choose>
									<xsl:when test="not($result != $result)">
										<xsl:value-of select="$result" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						
						<xsl:text></xsl:text>
					</xsl:otherwise>
				</xsl:choose>-->
				
				
			</td>
			<td id="{concat('QuantityTotal',Num)}">
				<xsl:if test="QuantityTotal = 0">
					<xsl:attribute name="class">center fieldError</xsl:attribute>
					<xsl:attribute name="title">Не указан объем всего</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="./QuantityTotal"/>
			</td>
			<td/>
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
		
		<xsl:if test="./Coefficients/Final/Values/Value[string-length(Formula) > 0]">	
		<tr >
			<td/>
			<td/>
			<td class="btop bbottom left bold italic" colspan="10">Результирующие коэффициенты:
			</td>
			
		</tr>
			<tr >
			<td/>
			<td/>
			<td class="left bold italic">
				<xsl:variable name="firstWorkerOT" select='./ResourcesInternal/Worker[1]/Coefficients/Final/Values/Value[./Target = "Стоимость"]/Formula' />
				<xsl:variable name="firstWorkerZT" select='./ResourcesInternal/Worker[1]/Coefficients/Final/Values/Value[./Target = "Расход"]/Formula' />
				<!-- Проверяем для Worker -->
				<xsl:for-each select="./ResourcesInternal/Worker[1]/Coefficients/Final/Values/Value">
					<!-- Проверяем значение Target -->
					<xsl:choose>
						<!-- Если значение Target равно 'Стоимость', выводим 'ОТ' -->
						<xsl:when test="Target = 'Стоимость'">
							<!--<xsl:variable name="firstWorkerOT" select="Formula" />-->
							ОТ &#160;</xsl:when>
						<!-- Если значение Target равно 'Расход', выводим 'ЗТ' -->
						<xsl:when test="Target = 'Расход'">
<!--							<xsl:variable name="firstWorkerZT" select="Formula" />-->
							ЗТ &#160;</xsl:when>
					</xsl:choose>
					
					<!-- Проверяем, что Formula не пуст -->
					<xsl:if test="string-length(Formula) &gt; 0">
						<xsl:value-of select="Formula"/><br/>
					</xsl:if>
				</xsl:for-each>
				
				<!-- Проверяем для Machine -->
				<xsl:for-each select="./ResourcesInternal/Machine[1]/Coefficients/Final/Values/Value">
					<!-- Проверяем значение Target -->
					<xsl:choose>
						<!-- Если значение Target равно 'Стоимость', выводим 'ЭМ' -->
						<xsl:when test="Target = 'Стоимость'">ЭМ &#160;</xsl:when>
						<!-- Если значение Target равно 'Расход', выводим 'ЭМ расход' -->
						<xsl:when test="Target = 'Расход'">ЭМ расход &#160;</xsl:when>
					</xsl:choose>
					
					<!-- Проверяем, что Formula не пуст -->
					<xsl:if test="string-length(Formula) &gt; 0">
						<xsl:value-of select="Formula"/><br/>
					</xsl:if>
				</xsl:for-each>
				
				
				
				
				<!-- Машинист-->
				<xsl:for-each select="./ResourcesInternal/Machine[1]/Machinist/Coefficients/Final[1]/Values[1]/Value">
				<!--<xsl:variable name="firstWorkerValue" select="./ResourcesInternal/Worker[1]/Coefficients/Final/Values/Value[1]" />-->
				<xsl:variable name="firstMachinistValue" select="./ResourcesInternal/Machine/Machinist[1]/Coefficients/Final/Values/Value[1]" />
				
				
				<xsl:choose>
					
					<xsl:when test="Target = 'Стоимость'">ОТм&#160; <xsl:value-of select="$firstWorkerOT"/><br/></xsl:when>
					
					<xsl:when test="Target = 'Расход'">ЗТм&#160; <xsl:value-of select="$firstWorkerZT"/><br/></xsl:when>
				</xsl:choose>
<!--				<xsl:choose>-->
					
					
<!--					<xsl:when test="$firstWorkerValue/Target = 'Стоимость'"><xsl:value-of select="$firstWorkerValue/Formula"/><br/></xsl:when>-->
				
<!--					<xsl:when test="$firstMachinistValue/Target = 'Расход'"><xsl:value-of select="$firstMachinistValue/Formula"/><br/></xsl:when>-->
					
				<!--</xsl:choose>-->
				</xsl:for-each>
				
				<!-- Материал-->
				
				<xsl:variable name="firstMaterialValue" select="./ResourcesInternal/Material[1]/Coefficients[1]/Final/Values[1]/Value[1]" />
								
				<xsl:choose>
					
					<xsl:when test="$firstMaterialValue/Target = 'Стоимость'">МР&#160;</xsl:when>
					
					<xsl:when test="$firstMaterialValue/Target = 'Расход'">МР расход&#160;</xsl:when>
				</xsl:choose>
				
				
				
				<xsl:value-of select="$firstMaterialValue/Formula"/><br/>
				
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
		</xsl:if>	
		
		
		

		<xsl:if test="./Totals/Current/WorkersSalary != 0">
			<tr>
				<td/>
				<td>1</td>
				<td class="left">ОТ</td>
				<td/>
				<td/>
				<td/>
				<td>
					<xsl:value-of select="./Totals/Natural/LaborCosts"/>
				</td>
				<td/>
				<td/>
				<td/>
				<td/>
				<td class="bold">
					<xsl:value-of select="./Totals/Current/WorkersSalary"/>
				</td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="ResourcesInternal/Worker" mode="internal"/>
		<xsl:if test="./Totals/Current/Machines != 0">
			<tr>
				<td/>
				<td>2</td>
				<td class="left">ЭМ</td>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td class="bold">
					<xsl:value-of select="./Totals/Current/Machines"/>
				</td>
			</tr>
		</xsl:if>

		<xsl:if test="./Totals/Current/MachinistSalary != 0">
			<tr>
				<td/>
				<td/>
				<td class="left">в т.ч. ОТм</td>
				<td/>
				<td/>
				<td/>
				<td>
					<xsl:value-of select="./Totals/Natural/MachinistLaborCosts"/>
				</td>
				<td/>
				<td/>
				<td/>
				<td/>
				<td>
					<xsl:value-of select="./Totals/Current/MachinistSalary"/>
				</td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="ResourcesInternal/Machine" mode="internal"/>


		<xsl:if test="./Totals/Current/Materials != 0">
			<tr>
				<td/>
				<td>4</td>
				<td class="left">М</td>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td>
					<xsl:value-of select="./Totals/Current/Materials"/>
				</td>
			</tr>
		</xsl:if>
		<xsl:apply-templates select="ResourcesInternal/Material" mode="internal"/>
		<xsl:apply-templates select="Resources" mode="cost"/>
		<xsl:if test="./PerUnit/Natural/LaborCosts != 0">
			<tr>
				<td/>
				<td/>
				<td class="left">ЗТ</td>
				<td class="center">чел.-ч</td>
				<td>
					<xsl:value-of select="./PerUnit/Natural/LaborCosts"/>
				</td>
				<td>
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
							<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
							<xsl:when test="name() = 'Material'">МАТ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
							<xsl:when test="name() = 'Worker'">ЗТ</xsl:when>
							<xsl:when test="name() = 'Material'">Объем</xsl:when>
							<xsl:otherwise>ОТ</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					
					<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = $target]/CoefValue"/>
				</td>
				<td>
					<xsl:value-of select="./Totals/Natural/LaborCosts"/>
				</td>
				<td/>
				<td/>
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
					<xsl:value-of select="./PerUnit/Natural/MachinistLaborCosts"/>
				</td>
				<td>
				
							<xsl:variable name="target">
								<xsl:choose>
									<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
									<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
									<xsl:when test="name() = 'Material'">МАТ</xsl:when>
									<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
									<xsl:when test="name() = 'Worker'">ЗТ</xsl:when>
									<xsl:when test="name() = 'Material'">Объем</xsl:when>
									<xsl:otherwise>ОТ</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
								
							<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = $target]/CoefValue"/>
					
				</td>
				<td>
					<xsl:value-of select="./Totals/Natural/MachinistLaborCosts"/>
				</td>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
			</tr>
		</xsl:if>
		<tr>
			<td/>
			<td/>
			<td class="btop left">Итого прямые затраты</td>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop"/>
			<td class="btop">
				<xsl:value-of select="./Totals/Current/Direct"/>
			</td>
		</tr>
	</xsl:template>

	<!-- Ресурс расценки по норме -->
	<xsl:template match="Material | Machine | Worker" mode="internal">
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

				<xsl:value-of select='util:formatNumberWithSevenDecimals(./Consumption)'/>
				
			</td>
			<td>
				<xsl:variable name="target">
					<xsl:choose>
						<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
						<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
						<xsl:when test="name() = 'Material'">МАТ</xsl:when>
						<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
						<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
						<xsl:when test="name() = 'Material'">Объем</xsl:when>
						<xsl:otherwise>ОТ</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				
				
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = &quot;Расход&quot;]/CoefValue)'/>
<!--				<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = &quot;Расход&quot;]/CoefValue"/>-->
			</td>
			
			<td>

				<xsl:value-of select='util:formatNumberWithSevenDecimals(./ConsumptionTotal)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Value/IndexValue)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = &quot;Стоимость&quot;]/CoefValue)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalCur)'/>
			</td>
		</tr>
		<xsl:apply-templates select="./Machinist" mode="machinist"/>
	</xsl:template>

	<!-- Машинисты по норме -->
	<xsl:template match="Machinist" mode="machinist">
		<tr>
			<td/>
			<td style="max-width: 100px; word-wrap: break-word;" class="right">
				<xsl:value-of select="./Code"/>
			</td>
			<td class="left">ОТм (ЗТм) Средний разряд машинистов <xsl:value-of select="./Grade"/></td>
			<td class="center">
				<xsl:value-of select="./Unit"/>
			</td>
			<td>
<!--				<xsl:value-of select='util:formatNumberWithZeroCheck(./Consumption)'/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./Consumption)'/>
			</td>
			<td> 
				<xsl:variable name="target">
					<xsl:choose>
						<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
						<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
						<xsl:when test="name() = 'Material'">МАТ</xsl:when>
						<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
						<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
						<xsl:when test="name() = 'Material'">Объем</xsl:when>
						<xsl:otherwise>ОТ</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Coefficients[1]/Final/Values/Value[./Target = &quot;Расход&quot;]/CoefValue[1])'/>
			</td>
			<td>
<!--				<xsl:value-of select='util:formatNumberWithZeroCheck(./ConsumptionTotal)'/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./ConsumptionTotal)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Value/IndexValue)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur)'/>
			</td>
			<td>
				
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
							<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
							<xsl:when test="name() = 'Material'">МАТ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
							<xsl:when test="name() = 'Material'">Объем</xsl:when>
							<xsl:otherwise>ОТ</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Coefficients[1]/Final/Values/Value[./Target = &quot;Стоимость&quot;]/CoefValue[1])'/>
				
			</td>
			<td class="bold">
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalCur)'/>
			</td>
		</tr>
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
				<xsl:value-of select="concat($ResCode, &quot; &quot;, ./Code)"/>
			</td>
			<td class="left">
				<xsl:value-of select="./Name"/>
			</td>
			<td class="center">
				<xsl:value-of select="./Unit"/>
			</td>
			<td>
<!--				<xsl:value-of select='util:formatNumberWithZeroCheck(./Consumption)'/>-->
<!--				<xsl:value-of select='util:formatNumberWithSevenDecimals(./Consumption)'/>-->
			</td>
			<td>
				
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
							<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
							<xsl:when test="name() = 'Material'">МАТ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
							<xsl:when test="name() = 'Material'">Объем</xsl:when>
							<xsl:otherwise>ОТ</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Coefficients/Coefficient/Values/Value[./Target = &quot;Расход&quot;]/CoefValue)'/>
				
			</td>
			<td>
<!--			<xsl:value-of select='util:formatNumberWithZeroCheck(./ConsumptionTotal)'/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./ConsumptionTotal)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitBase)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Index/Value/Final)'/>
					
				
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PricePerUnitCur)'/>
			</td>
			<td>
				<xsl:variable name="target">
					<xsl:choose>
						<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
						<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
						<xsl:when test="name() = 'Material'">МАТ</xsl:when>
						<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
						<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
						<xsl:when test="name() = 'Material'">Объем</xsl:when>
						<xsl:otherwise>ОТ</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				
				<xsl:value-of select='util:formatNumberWithZeroCheck(./Coefficients/Final/Values/Value[./Target = &quot;Стоимость&quot;]/CoefValue)'/>
			</td>
			<td>
				<xsl:value-of select='util:formatNumberWithZeroCheck(./PriceTotalCur)'/>
			</td>
		</tr>
	</xsl:template>

	<!-- Ресурсы расценки -->
	<xsl:template match="Material | Equipment | Transport" mode="cost">
		
		<tr >
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
<!--				<xsl:value-of select="./Consumption"/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./Consumption)'/>
			</td>
			<td>
				
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
							<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
							<xsl:when test="name() = 'Material'">МАТ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
							<xsl:when test="name() = 'Material'">Объем</xsl:when>
							<xsl:otherwise>ОТ</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					
					<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = &quot;Расход&quot;]/CoefValue"/>
				
			</td>
			<td>
<!--				<xsl:value-of select="./ConsumptionTotal"/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./ConsumptionTotal)'/>
			</td>
			<td>
				<xsl:value-of select="./PricePerUnitBase"/>
			</td>
			<td>
				<xsl:value-of select="./Index/Value/IndexValue"/>
			</td>
			<td>
				<xsl:value-of select="./PricePerUnitCur"/>
			</td>
			<td>
				
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
							<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
							<xsl:when test="name() = 'Material'">МАТ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
							<xsl:when test="name() = 'Material'">Объем</xsl:when>
							<xsl:otherwise>ОТ</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					
					<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = &quot;Стоимость&quot;]/CoefValue"/>
				
			</td>
			<td>
				<xsl:value-of select="./PriceTotalCur"/>
			</td>
		</tr>
		<xsl:apply-templates select="./Transport" mode="transport">
			<xsl:with-param name="ResCode" select="./Code"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Замененные ресурсы -->
	<xsl:template match="Material | Equipment | Transport" mode="item">
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
<!--				<xsl:value-of select="./Consumption"/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./Consumption)'/>
			</td>
			<td>
				
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
							<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
							<xsl:when test="name() = 'Material'">МАТ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
							<xsl:when test="name() = 'Material'">Объем</xsl:when>
							<xsl:otherwise>ОТ</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					
					<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = &quot;Расход&quot;]/CoefValue"/>
				
			</td>
			<td>
<!--				<xsl:value-of select="./ConsumptionTotal"/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./ConsumptionTotal)'/>
			</td>
			<td>
				<xsl:value-of select="./PricePerUnitBase"/>
			</td>
			<td>
				<xsl:value-of select="./Index/Value/IndexValue"/>
			</td>
			<td>
				<xsl:value-of select="./PricePerUnitCur"/>
			</td>
			<td>
				<xsl:variable name="target">
					<xsl:choose>
						<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
						<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
						<xsl:when test="name() = 'Material'">МАТ</xsl:when>
						<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
						<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
						<xsl:when test="name() = 'Material'">Объем</xsl:when>
						<xsl:otherwise>ОТ</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				
				<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = &quot;Стоимость&quot;]/CoefValue"/>
			</td>
			<td>
				<xsl:value-of select="./PriceTotalCur"/>
			</td>
		</tr>
		
		<xsl:choose>
			<xsl:when test="./Coefficients/Coefficient">
				<tr>
					<!-- кол.1 № п/п — пусто -->
					<td/>
					<!-- кол.2: Шифр (обоснование коэффициента) -->
					<td class="left">
						<xsl:value-of select="./Coefficients/Coefficient/Reason"/>
					</td>
					<!-- кол.3: Наименование коэффициента + расшифровка значений -->
					<td class="left italic" colspan="9">
						<xsl:value-of select="./Coefficients/Coefficient/Name"/>
						<xsl:if test="./Coefficients/Coefficient/Values/Value">
							<br/>
							<xsl:apply-templates select="./Coefficients/Coefficient/Values/Value" mode="coefDescr"/>
						</xsl:if>
					</td>
					<!-- кол.12 — пусто, чтобы сохранить 12 колонок -->
					<td/>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td/><td class="left" colspan="10"/><td/>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
		
		
		<xsl:apply-templates select="./Transport" mode="transport">
			<xsl:with-param name="ResNum" select="concat($CostNum, '.', Num)"/>
			<xsl:with-param name="ResCode" select="./Code"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Ресурсные позиции -->
	<xsl:template match="Machine | Material | Equipment | Transport | Other" mode="ext">
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
<!--				<xsl:value-of select="./Consumption"/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./Consumption)'/>
			</td>
			<td>
				
					<xsl:variable name="target">
						<xsl:choose>
							<xsl:when test="name() = 'Worker'">ОТ</xsl:when>
							<xsl:when test="name() = 'Machine'">ЭМ</xsl:when>
							<xsl:when test="name() = 'Material'">МАТ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ОТМ</xsl:when>
							<xsl:when test="name() = 'Machinist'">ЗТ</xsl:when>
							<xsl:when test="name() = 'Material'">Объем</xsl:when>
							<xsl:otherwise>ОТ</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					
					<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = &quot;Расход&quot;]/CoefValue"/>
				
			</td>
			<td>
<!--				<xsl:value-of select="./ConsumptionTotal"/>-->
				<xsl:value-of select='util:formatNumberWithSevenDecimals(./ConsumptionTotal)'/>
			</td>
			<td>
				<xsl:value-of select="./PricePerUnitBase"/>
			</td>
			<td>
				<xsl:value-of select="./Index/Value/IndexValue"/>
			</td>
			<td>
				<xsl:value-of select="./PricePerUnitCur"/>
			</td>
			<td>
				<xsl:value-of select="./Coefficients/Final/Values/Value[./Target = &quot;Стоимость&quot;]/CoefValue"/>
			</td>
			<td>
				<xsl:value-of select="./PriceTotalCur"/>
			</td>
		</tr>
		
		<xsl:choose>
			<xsl:when test="./Coefficients/Coefficient">
				<tr>
					<td></td> <td class="left" colspan="11">
						<xsl:value-of select="./Coefficients/Coefficient/Reason"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="./Coefficients/Coefficient/Name"/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td></td> <td class="left" colspan="11">
<!--						(Детали коэффициента не найдены для этого ресурса)-->
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
		
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
<!--				<br/> Кол-во =<xsl:value-of select="../../QuantityFormula"/> <xsl:value-of select="' '"/>-->
				<br/>
				<xsl:apply-templates select="Values/Value" mode="coefDescr"/>
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

	</xsl:template>

	<!-- Коды коэффициентов для НР и СП -->
	<xsl:template match="Coefficients" mode="codes2">
		<xsl:for-each select="Coefficient">
			<xsl:value-of select="Reason"/>
			<xsl:if test="position() != last()">,</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<!-- Коды коэффициентов -->
	<xsl:template match="Coefficients/Coefficient" mode="codes">
		<div class="italic">
			<div class="inline" style="display:block; border-top:1px dashed black">
				<xsl:value-of select="concat('[', Reason, ']')"/>
			</div>
		</div>
	</xsl:template>

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
							<a id="erEstimateNum" href="EstimateNum" onclick="window.opener.document.getElementById(this.href).scrollIntoView(true); window.opener.focus(); return false;">blank</a>
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
							<a id="erSoftName" href="SoftName" onclick="window.opener.document.getElementById(this.href).scrollIntoView(true); window.opener.focus(); return false;">blank</a>
						</li>
						<script>
							
							s='Не указано название програмного продукта'; 
							SoftName.title=s; 
							SoftName.classList.add("fieldError"); 
							erSoftName.innerHTML=s; 
							
						</script>
					</xsl:if>
					<xsl:if test="not(Object/Estimate/Legal/Main/Name) or (Object/Estimate/Legal/Main/Name = '')">
						<li class="err">
							<a id="erNormativeName" href="#" onclick="window.opener.document.getElementById(this.id.substr(2)).scrollIntoView(true); window.opener.focus(); return false;">blank</a>
						</li>
						<script>
							
							s='Не указано наименование редакции сметных нормативов'; 
							LegalMainName.title=s; 
							LegalMainName.classList.add("fieldError"); 
							erNormativeName.innerHTML=s;
							
						</script>
					</xsl:if>
					<xsl:if test="not(Object/Estimate/Legal/Main/Num) or (Object/Estimate/Legal/Main/Num = '')">
						<li class="err">
							<a id="erNormativeName" href="#" onclick="window.opener.document.getElementById(this.id.substr(2).scrollIntoView(true); window.opener.focus(); return false;">blank</a>
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
										<xsl:value-of select="concat('Не указан шифр позиции ', Cost/Num)"/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/Name) or (Cost/Name = '')">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of select="concat('Не указано наименование позиции ', Cost/Num)"/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/Unit) or (Cost/Unit = '')">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of select="concat('Не указана единица измерения расценки ', Cost/Num)"/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/Quantity) or (Cost/Quantity = 0)">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of select="concat('Не указано количество в расценке ', Cost/Num)"/>
									</li>
								</xsl:if>
								<xsl:if test="not(Cost/QuantityTotal) or (Cost/QuantityTotal = 0)">
									<li class="err">
										<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
										<xsl:value-of select="concat('Не указано количество всего в расценке ', Cost/Num)"/>
									</li>
								</xsl:if>
								<xsl:for-each select="Cost/Resources/*">
									<xsl:if test="not(Code) or (Code = '')">
										<li class="err">
											<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.parent.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
											<xsl:value-of select="concat('Не указан код ресурса', ../../Cost/Num)"/>
										</li>
									</xsl:if>
									<xsl:if test="not(Name) or (Name = '')">
										<li class="err">
											<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
											<xsl:value-of select="concat('Не указано наименование ресурса ', ../../Num)"/>
										</li>
									</xsl:if>
									<xsl:if test="(not(Unit) or (Unit = '')) and not(starts-with(Code, '999'))">
										<li class="err">
											<!-- a href="#" id="l{concat('Сost',Cost/Num)}" onclick="window.opener.document.getElementById(this.id.substr(1)).scrollIntoView(true); window.opener.focus(); return false;"-->
											<xsl:value-of select="concat('В позиции № ', ../../Num)"/>
											<xsl:value-of select="concat(' не указана единица измерения. Код ресурса:  ', Code)"/>
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
