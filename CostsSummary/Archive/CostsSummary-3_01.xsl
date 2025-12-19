<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
	<xsl:output omit-xml-declaration="yes" encoding="UTF-8"  indent="yes"/>
	<xsl:strip-space elements="*"/>
	
	<!-- Главный шаблон и описание стилей CSS -->
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <style type="text/css" id="styles"> 
                    h1 { font-family: Times New Roman; font-size: 12pt; font-weight:bold; text-align:center; width:100%; margin-top: 1em; }
                    body,p,td { font-family: Times New Roman; font-size: 10pt; margin:0;}
                
                    
                    div.heading-left2 { margin-left:1.7em; display:flex; width:30%; margin-top: 2em; min-height: 1em; flex-wrap: nowrap; white-space: nowrap; min-width: max-content; }
                    div.heading-left2 .headingvalue { border-bottom: 1px solid black; flex: 1 1 auto; line-height: 0.5em; white-space: nowrap; min-width: max-content; }

					div.heading-left3 { margin-left:1.7em; display:flex; width:50%; margin-top: 2em; min-height: 1em;}
					div.heading-left3 .headingvalue { border-bottom: 1px solid black; flex: 1; line-height: 0.5em;}
                    
                    div.helptext { text-align:center; width:100%; margin-top:0;}
                    
                    div.headingname { white-space: nowrap; margin-right:0.3em; margin-left:0.3em; flex-grow: *; min-height: 1em; line-height: 0.5em;}
                    
                    div.heading-left { display:flex; width:50%; margin-bottom: 0.5em; min-height: 1em;}
                    div.heading-left .headingvalue { border-bottom: 1px solid black; flex-grow: 2;}
                    
                    div.spacer {flex: 1; }

                    div.report { margin-bottom: 2em; margin-bottom: 2em; border-bottom:2px solid black; padding:0.5em 2em;}
                    div.report h3 {font-size: 120%; font-weight; bold}

                    div.heading {margin-right:2em; margin-left:2em; display:flex; }
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
					.b {font-weight:bold}
					
                    .err { color:red; text-decoration: underline }
                    .err A { color:red; text-decoration: underline }
                    
                    table {border-collapse: collapse; width:100%; margin:0em 1em 2em 1em; }
                    th {
                    	font-weight: normal; 
                    	border: 1px solid black; 
                    	padding: 0.5em; 
                    	vertical-align: center; 
                    	text-align:center; 
                    	align:center
                   	}
                   	.rotate {
	                   	writing-mode: vertical-rl;
	                   	text-orientation: mixed;
	                   	text-align: center;
	                   	transform: rotateZ(180deg);
	                   	font-size: 80%;
                   	}                       	
                    td {border: 1px solid black; padding: 0.2em 0.5em; vertical-align: top; text-align:left}

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
			<xsl:otherwise>error: <xsl:value-of select="$quarter"/> </xsl:otherwise>
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
			<xsl:otherwise>error: <xsl:value-of select="$month"/> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Стройка -->
	<xsl:template match="Construction" mode="render"> 
		<div class="main">
			
				<div class="heading-left2">
					<xsl:text>Дата и время выгрузки файла из сметного программного комплекса: </xsl:text>
					<xsl:value-of select="concat(substring(ExportDateTime, 9, 2), '.', substring(ExportDateTime, 6, 2), '.', substring(ExportDateTime, 1, 4), ' ', substring(ExportDateTime, 12, 5))" />
				</div>
			
			<div class="heading"><div class="headingname">Заказчик</div><div class="headingvalue center"><xsl:value-of select="Customer"/></div></div>
			<div class="heading" style="margin-top: 0;"><div class="helptext">(наименование организации)</div></div>

			<div class="heading-left2"><div class="headingname">Утверждена</div><div class="headingvalue center"><xsl:value-of select="concat(substring(Approved,9,2),'.',substring(Approved,6,2),'.',substring(Approved,1,4))"/> г.</div></div>

			<div class="heading-left2"><div class="headingname"><b>Сводка затрат в сумме</b></div><div class="headingvalue center"><b><xsl:value-of select="Summary"/> тыс. руб.</b></div></div>
			<br/>
			<div class="heading"><div class="headingvalue center"><xsl:value-of select="ApprovedDoc"/></div></div>
			<div class="heading" style="margin-top: 0;"><div class="helptext">(ссылка на документ об утверждении)</div></div>

			<div class="heading-left2"><div class="headingname"><xsl:value-of select="concat(substring(ApprovedDate,9,2),'.',substring(ApprovedDate,6,2),'.',substring(ApprovedDate,1,4))"/> г.</div></div>

			<h1 id="EstimateNum">СВОДКА ЗАТРАТ</h1>
			
			<div class="heading center">
				<div class="headingvalue center"><xsl:value-of select="ConstructionSite"/></div>
			</div>
			<div class="helptext">(наименование стройки)</div>
			
			<div class="heading-left2"><div class="headingname">Составлена в текущем уровне цен</div><div class="headingvalue center">
				<xsl:if test="PriceLevel/Quarter"><xsl:call-template name="get-quarter-name"><xsl:with-param name="quarter" select="PriceLevel/Quarter"/></xsl:call-template></xsl:if>
				<xsl:if test="PriceLevel/Month"><xsl:call-template name="get-month-name"><xsl:with-param name="month" select="PriceLevel/Month"/></xsl:call-template></xsl:if>
				<xsl:value-of select="PriceLevel/Year"/> г.
			</div></div>
			
			<div class="heading-left2"><div class="headingname"><b>Таблица 1</b></div></div>
			
			<table>
				<thead>
					<tr>
						<th scope="col" rowspan="2">№ п.п.</th>
						<th scope="col" rowspan="2">Наименование затрат</th>
						<th scope="col" colspan="3">Сметная стоимость, тыс. руб.</th>	
					</tr>
					<tr>
						<th scope="col">объектов производственного назначения</th>	
						<th scope="col">объектов непроизводственного назначения</th>	
						<th scope="col">всего</th>	
					</tr>
					<tr>
						<td class="center" style="width:1em">1</td>
						<td class="center" style="width:40%">2</td>
						<td class="center" style="width:20%">3</td>
						<td class="center" style="width:20%">4</td>
						<td class="center" style="width:20%">5</td>
					</tr>
				</thead>
				<tbody>
				<tr>
					<td class="left">1</td>
					<td class="left">&#160;<b>Сметная стоимость:</b></td>
					<td class="right"><xsl:value-of select="Costs/Estimate/Production"/></td>
					<td class="right"><xsl:value-of select="Costs/Estimate/NotProduction"/></td>
					<td class="right"><xsl:value-of select="Costs/Estimate/Total"/></td>
				</tr>
				<tr>
					<td class="left">1.1</td>
					<td class="left">&#160;&#160;&#160;&#160;&#160;строительных и монтажных работ</td>
					<td class="right"><xsl:value-of select="Costs/Building/Production"/></td>
					<td class="right"><xsl:value-of select="Costs/Building/NotProduction"/></td>
					<td class="right"><xsl:value-of select="Costs/Building/Total"/></td>
				</tr>
				<tr>
					<td class="left">1.2</td>
					<td class="left">&#160;&#160;&#160;&#160;&#160;оборудования</td>
					<td class="right"><xsl:value-of select="Costs/Equipment/Production"/></td>
					<td class="right"><xsl:value-of select="Costs/Equipment/NotProduction"/></td>
					<td class="right"><xsl:value-of select="Costs/Equipment/Total"/></td>
				</tr>
				<tr>
					<td class="left">1.3</td>
					<td class="left">&#160;&#160;&#160;&#160;&#160;прочих затрат</td>
					<td class="right"><xsl:value-of select="Costs/Other/Production"/></td>
					<td class="right"><xsl:value-of select="Costs/Other/NotProduction"/></td>
					<td class="right"><xsl:value-of select="Costs/Other/Total"/></td>
				</tr>
				<tr>
					<td class="left">2</td>
					<td class="left">&#160;<b>Сметная стоимость всего,</b><br/><i>в том числе</i></td>
					<td class="right"><xsl:value-of select="Costs/EstimateTotal/Production"/></td>
					<td class="right"><xsl:value-of select="Costs/EstimateTotal/NotProduction"/></td>
					<td class="right"><xsl:value-of select="Costs/EstimateTotal/Total"/></td>
				</tr>
				<tr>
					<td class="left">2.1</td>
					<td class="left">&#160;&#160;&#160;&#160;&#160;НДС</td>
					<td class="right"><xsl:value-of select="Costs/EstimateTotalVAT/Production"/></td>
					<td class="right"><xsl:value-of select="Costs/EstimateTotalVAT/NotProduction"/></td>
					<td class="right"><xsl:value-of select="Costs/EstimateTotalVAT/Total"/></td>
				</tr>
				</tbody>
			</table>

			<div class="heading-left3"><div class="headingname">Руководитель проектной организации</div><div class="headingvalue center"><xsl:value-of select="Signatures/ProjectOrg/Name"/></div></div>
			<div class="heading-left3" style="margin-top: 0;"><div class="helptext center">[подпись (инициалы, фамилия)]</div></div>
			<p></p>
			<div class="heading-left3"><div class="headingname">Главный инженер проекта</div><div class="headingvalue center"><xsl:value-of select="Signatures/ChiefProjectEngineer/Name"/></div></div>
			<div class="heading-left3" style="margin-top: 0;"><div class="helptext center">[подпись (инициалы, фамилия)]</div></div>
			<p></p>
			<div class="heading-left3"><div class="headingname">Начальник</div><div class="headingvalue center"><xsl:value-of select="Signatures/Chief/Name"/></div> <div class="headingname"> отдела</div><div class="headingvalue"><xsl:value-of select="Signatures/Chief/Department"/></div></div>
			<div class="heading-left3" style="margin-top: 0;"><div class="helptext center">[подпись (инициалы, фамилия)]</div><div class="helptext">[наименование]</div></div>
			<p></p>
			<div class="heading-left3"><div class="headingname">Заказчик</div><div class="headingvalue"><xsl:value-of select="Signatures/Customer/Position"/> <xsl:value-of select="Signatures/Customer/Name"/></div></div>
			<div class="heading-left3" style="margin-top: 0;"><div class="helptext">[должность, подпись (инициалы, фамилия)]</div></div>
			<p></p>
			
			<xsl:if test="Table">
				<div class="heading-left2"  style="page-break-before: always;"><div class="headingname"><b>Таблица 2</b></div></div>
				<table>
					<thead>
						<tr>
							<th scope="col" rowspan="4">№ п.п.</th>
							<th scope="col" rowspan="4">Обоснование</th>
							<th scope="col" rowspan="4">Наименование локальных сметных расчетов (смет), затрат</th>	
							<th scope="col" colspan="11">Сметная стоимость, руб.</th>
							<th scope="col" colspan="2">Затраты труда, чел.-ч</th>
						</tr>
						<tr>
							<th scope="col" rowspan="3">Прямые затраты</th>	
							<th scope="col" colspan="5"><i>в том числе</i></th>	
							<th scope="col" rowspan="3">Оборудование</th>	
							<th scope="col" rowspan="3">ФОТ</th>	
							<th scope="col" rowspan="3">НР</th>	
							<th scope="col" rowspan="3">СП</th>	
							<th scope="col" rowspan="3">Итого</th>	
							<th scope="col" rowspan="3">рабочих</th>	
							<th scope="col" rowspan="3">машинистов</th>	
						</tr>
						<tr>
							<th scope="col" rowspan="2">оплата труда рабочих</th>	
							<th scope="col" colspan="2">стоимость эксплуатации машин и механизмов</th>	
							<th scope="col" rowspan="2">материальные ресурсы</th>	
							<th scope="col" rowspan="2">перевозка</th>	
						</tr>					
						<tr>
							<th scope="col">всего</th>	
							<th scope="col"><i>в том числе</i> оплата труда машинистов</th>	
						</tr>					
						<tr>
							<td class="center" style="width:1em">1</td>
							<td class="center">2</td>
							<td class="center">3</td>
							<td class="center">4</td>
							<td class="center">5</td>
							<td class="center">6</td>
							<td class="center">7</td>
							<td class="center">8</td>
							<td class="center"></td>
							<td class="center">9</td>
							<td class="center">10</td>
							<td class="center">11</td>
							<td class="center">12</td>
							<td class="center">13</td>
							<td class="center">14</td>
							<td class="center">15</td>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select="Table"/>
					</tbody>
				</table>
					
				<div class="heading-left3"><div class="headingname">Составил</div><div class="headingvalue"><xsl:value-of select="Signatures/ComposeFIO"/></div></div>
				<div class="heading-left3" style="margin-top: 0;"><div class="helptext">[должность, подпись (инициалы, фамилия)]</div></div>
				<p></p>
				<div class="heading-left3"><div class="headingname">Проверил</div><div class="headingvalue"><xsl:value-of select="Signatures/VerifyFIO"/></div></div>
				<div class="heading-left3" style="margin-top: 0;"><div class="helptext">[должность, подпись (инициалы, фамилия)]</div></div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="LocalEstimate">
		<tr>
			<td class="center"><xsl:value-of select="Num"/></td>
			<td class="center"><a href="{Link}"><xsl:value-of select="Link"/></a></td>
			<td class="left"><xsl:value-of select="Name"/></td>
			<td class="right"><xsl:value-of select="Direct"/></td>
			<td class="right"><xsl:value-of select="WorkerSalary"/></td>
			<td class="right"><xsl:value-of select="Machines"/></td>
			<td class="right"><xsl:value-of select="MachinistSalary"/></td>
			<td class="right"><xsl:value-of select="Materials"/></td>
			<td class="right"><xsl:value-of select="Transport"/></td>
			<td class="right"><xsl:value-of select="Equipment"/></td>
			<td class="right"><xsl:value-of select="Salary"/></td>
			<td class="right"><xsl:value-of select="Overhead"/></td>
			<td class="right"><xsl:value-of select="Profit"/></td>
			<td class="right"><xsl:value-of select="Total"/></td>
			<td class="right"><xsl:value-of select="LaborCosts"/></td>
			<td class="right"><xsl:value-of select="MachinistLaborCosts"/></td>
		</tr>
	</xsl:template>
	
	<xsl:template match="Totals">
		<tr>
			<td></td>
			<td></td>
			<td class="center b">Всего:</td>
			<td class="right b"><xsl:value-of select="Direct"/></td>
			<td class="right b"><xsl:value-of select="WorkerSalary"/></td>
			<td class="right b"><xsl:value-of select="Machines"/></td>
			<td class="right b"><xsl:value-of select="MachinistSalary"/></td>
			<td class="right b"><xsl:value-of select="Materials"/></td>
			<td class="right b"><xsl:value-of select="Transport"/></td>
			<td class="right b"><xsl:value-of select="Equipment"/></td>
			<td class="right b"><xsl:value-of select="Salary"/></td>
			<td class="right b"><xsl:value-of select="Overhead"/></td>
			<td class="right b"><xsl:value-of select="Profit"/></td>
			<td class="right b"><xsl:value-of select="Total"/></td>
			<td class="right b"><xsl:value-of select="LaborCosts"/></td>
			<td class="right b"><xsl:value-of select="MachinistLaborCosts"/></td>
		</tr>
	</xsl:template>	
</xsl:stylesheet>
