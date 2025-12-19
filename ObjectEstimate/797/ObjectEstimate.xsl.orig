<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:util="http://www.gge.ru/utils"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8"  indent="yes"/>
    <xsl:strip-space elements="*"/>
   
   
    <xsl:function name="util:formatNumberWithZeroCheck">
        <xsl:param name="number"/>
        <xsl:param name="decimalPlaces" as="xs:integer"/>
        
        <!-- Если строка пустая или не число (NaN) — возвращаем исходное значение -->
        <xsl:choose>
            <xsl:when test="
                normalize-space(string($number)) = '' 
                or number($number) != number($number)
                ">
                <xsl:value-of select="string($number)"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Количество десятичных знаков по умолчанию — 2 -->
                <xsl:variable name="decimalPlacesValue" 
                    select="if (not($decimalPlaces)) then 2 else $decimalPlaces"/>
                
                <!-- Строим шаблон форматирования, например "#,##0.00" -->
                <xsl:variable name="formatPattern">
                    <xsl:text>#,##0.</xsl:text>
                    <xsl:for-each select="1 to $decimalPlacesValue">
                        <xsl:text>0</xsl:text>
                    </xsl:for-each>
                </xsl:variable>
                
                <!-- Форматируем число -->
                <xsl:variable name="formattedNumber" 
                    select="format-number($number, $formatPattern)"/>
                
                <!-- Заменяем разделитель групп разрядов (запятую) на пробел -->
                <xsl:variable name="translatedNumber" 
                    select="translate($formattedNumber, ',', ' ')"/>
                
                <!-- Заменяем десятичную точку на запятую -->
                <xsl:variable name="finalNumber" 
                    select="translate($translatedNumber, '.', ',')"/>
                
                <xsl:value-of select="$finalNumber"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    
   
    <!-- Функция для форматирования даты/квартала с полной защитой от пустых значений -->
    <xsl:function name="util:formatQuarterDate">
        <!-- Параметры функции -->
        <xsl:param name="year" as="xs:string"/>
        <xsl:param name="quarter" as="xs:string"/>
        <xsl:param name="month" as="xs:string?"/>
        <xsl:param name="day" as="xs:string?"/>
        
        <!-- Значения по умолчанию, если параметры пустые -->
        <xsl:variable name="defaultYear" select="if (string-length($year) > 0) then $year else 'Не указано'"/>
        <xsl:variable name="defaultQuarter" select="if (string-length($quarter) > 0) then $quarter else '0'"/>
        <xsl:variable name="defaultMonth" select="if (string-length($month) > 0) then $month else '01'"/>
        <xsl:variable name="defaultDay" select="if (string-length($day) > 0) then $day else '01'"/>
        
        <!-- Массив с названиями кварталов -->
        <xsl:variable name="quarterNames" select="('I квартал', 'II квартал', 'III квартал', 'IV квартал')"/>
        
        <!-- Проверка и выбор названия квартала -->
        <xsl:variable name="quarterIndex" select="number($defaultQuarter)"/>
        <xsl:variable name="quarterName" 
            select="if($quarterIndex &gt;= 1 and $quarterIndex &lt;= 4) 
            then $quarterNames[$quarterIndex] 
            else 'Неизвестный квартал'"/>
        
        <!-- Логика форматирования -->
        <xsl:choose>
            <!-- Если указаны месяц и день -->
            <xsl:when test="string-length($defaultMonth) > 0 and string-length($defaultDay) > 0">
                <xsl:value-of select="concat(format-number(number($defaultDay), '00'), '.', format-number(number($defaultMonth), '00'), '.', $defaultYear)"/>
            </xsl:when>
            <!-- Если указан только квартал -->
            <xsl:when test="string-length($defaultQuarter) > 0 and $defaultQuarter != '0'">
                <xsl:value-of select="concat($quarterName, ' ', $defaultYear)"/>
            </xsl:when>
            <!-- Если указано только год -->
            <xsl:when test="string-length($defaultYear) > 0 and $defaultYear != 'Не указано'">
                <xsl:value-of select="$defaultYear"/>
            </xsl:when>
            <!-- Если ничего не указано -->
            <xsl:otherwise>
                <xsl:text>Дата не указана</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
	
    
    <!-- Удалены шаблоны get-quarter-name и get-month-name, так как теперь используется функция -->

    <!-- Главный шаблон и описание стилей CSS -->
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <style type="text/css" id="styles"> 
                    h1 { font-family: Times New Roman; font-size: 12pt; font-weight:bold; text-align:center; width:100%; margin-top: 2em; }
                    body,p,td { font-family: Times New Roman; font-size: 10pt; margin:0;}
                    
                    div.heading-left2 { margin-left:1.7em; display:flex; width:50%; margin-top: 2em; min-height: 1em; }
                    div.heading-left2 .headingvalue { border-bottom: 1px solid black; flex: 1;  line-height: 0.5em;}

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
                    
                    .err { color:red; text-decoration: underline }
                    .err A { color:red; text-decoration: underline }
                    
                    table {border-collapse: collapse; width:100%; margin:2em 0; }
                    th {border: 1px solid black; padding: 0.5em; vertical-align: top;}
                    th.chapter {border: none; border-top: 1px solid black; border-bottom: 1px solid black; padding: 0.5em; vertical-align: top;}
                    td {border: 0px; padding: 0.2em 0.5em; vertical-align: top; text-align:right}
                    td.tborder {border: 1px solid black}
                    td.btop {border-top: 1px solid black}
                    td.bold {font-weight: bold}
					
					.req-table {
					width: 98%;
					border-collapse: collapse;
					margin-left : 1.5em;
					margin-top : 1em;
					}
					
					.req-table td {
					padding: 12px 2px 1px 2px;
					vertical-align: top;
					text-align: left;
					font-weight: normal; /* Убираем жирный шрифт */
					}
					
					.total-table {
					width: 98%;
					border-collapse: collapse;
					margin-left : 1.5em;
					margin-top : 1em;
					}
					
					.total-table td {
					padding: 12px 2px 1px 2px;
					vertical-align: bottom;
					text-align: left;
					font-weight: normal; /* Убираем жирный шрифт */
					}
					
					.sign-table {
					width: 50%;
					border-collapse: collapse;
					margin-left : 2em;
					margin-top : 0.5em;
					}					
					
					.sign-table td {
					padding: 10px 2px 1px 2px;
					vertical-align: top;
					text-align: left;
					font-weight: normal; /* Убираем жирный шрифт */
					}
					
					td.bordered {
					border-bottom: 1px solid black; /* Добавляем нижнюю границу только второму столбцу */
					}
					
					td.helptext {
					padding-top: 1px;
					}
					
					td.centered {
					text-align: center;
					}
					
					td.bold {
					font-weight: bold;
					}
					
					td.right {
					text-align: right;
					}
					
					td.leftindent {
					text-indent: 2em;
					}
                </style>
            </head>
        	<body>
            	<xsl:apply-templates select="Construction" mode="render"/>
            </body>
        </html>        
    </xsl:template>
    
    <!-- Стройка -->
    <xsl:template match="Construction" mode="render"> 
        <div class="main">
            <div class="heading-left2 nowrap">
                <xsl:text>Дата и время выгрузки файла из сметного программного комплекса: </xsl:text>
                <xsl:value-of select="concat(substring(ExportDateTime, 9, 2), '.', substring(ExportDateTime, 6, 2), '.', substring(ExportDateTime, 1, 4), ' ', substring(ExportDateTime, 12, 5))" />
            </div>
            
            <div class="heading">
                <div class="headingvalue center"><xsl:value-of select="Name"/></div>
            </div>
            <div class="helptext">(наименование стройки)</div>
            
            <div class="heading">
                <div class="headingvalue center"><xsl:value-of select="Object/Name"/></div>
            </div>
            <div class="helptext">(наименование объекта капитального строительства)</div>
            
            
            <h1 id="EstimateNum">ОБЪЕКТНЫЙ СМЕТНЫЙ РАСЧЕТ (СМЕТА) № ОС-<xsl:value-of select="Object/Num"/></h1>
			
			<table class="req-table" align="center">
				<tr>
					<td width="100">Основание</td>
					<td class="bordered centered"><xsl:value-of select="Object/Reason"/></td>
				</tr>
				<tr>
				    <td width="100"></td>
					<td class="centered helptext">(проектная и (или) иная техническая документация)</td>
				</tr>
			</table>	
			
			<table class="total-table" align="center">
				<tr>					
					<td class="bold" width="15%">Сметная стоимость</td>
					<td width="20%"></td>
					<td class="bold bordered right" colspan="3">
					    <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Summary/Total, 2)'/>
					</td>
					<td class="bold" width="5%">тыс. руб.</td>
				</tr>
				<tr>					
					<td colspan="2">Расчетный измеритель объекта капитального строительства</td>
					<td class="centered bordered" width="30%">
					    <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Quantity, 2)'/>
					</td>
					<td width="4%"></td>
					<td class="centered bordered" colspan="2">
					    <xsl:value-of select='util:formatNumberWithZeroCheck(Object/QuantityUnit, 2)'/>
					</td>
				</tr>
				<tr>					
					<td colspan="2"></td>
					<td width="30%" class="centered helptext">(количество)</td>
					<td width="4%"></td>
					<td colspan="2" class="centered helptext">(измеритель)</td>
				</tr>
				<tr>					
					<td colspan="2">Показатель единичной стоимости на расчетный измеритель объекта капитального строительства</td>
					<td class="bordered right" colspan="3">
					    <xsl:value-of select='util:formatNumberWithZeroCheck(Object/PricePerUnit, 2)'/>
					</td>
					<td width="5%">тыс. руб.</td>
				</tr>
				<tr>					
					<td colspan="6">
						<b>Составлен в ценах по состоянию на</b>&#160;&#160;&#160;
						<!-- Вместо вызовов шаблонов, используем функцию -->
						<xsl:if test="Object/PriceLevel">
							<xsl:value-of select="util:formatQuarterDate(
								Object/PriceLevel/Year, 
								if (Object/PriceLevel/Quarter) then Object/PriceLevel/Quarter else '0', 
								if (Object/PriceLevel/Month) then Object/PriceLevel/Month else '01', 
								if (Object/PriceLevel/Day) then Object/PriceLevel/Day else '01'
								)"/>
						</xsl:if>
					</td>
				</tr>
			</table>
            
            <table>
                <thead>
                    <tr>
                        <th scope="col" rowspan="2">№ п.п.</th>
                        <th scope="col" rowspan="2" nowrap="nowrap">Обоснование</th>
                        <th scope="col" rowspan="2">Наименование локальных сметных расчетов (смет), затрат</th>
                        <th colspan="5">Сметная стоимость, тыс.руб.</th>
                    </tr>
                    <tr>
                        <th scope="col">строительных (ремонтно-строительных, ремонтно-реставрационных) работ</th>
                        <th scope="col">монтажных работ</th>
                        <th scope="col">оборудования</th>
                        <th scope="col">прочих затрат</th>
                        <th scope="col">всего</th>
                    </tr>
                    <tr>
                        <td class="tborder center" width="1em">1</td>
                        <td class="tborder center" width="15%">2</td>
                        <td class="tborder center" width="35%">3</td>
                        <td class="tborder center" width="10%">4</td>
                        <td class="tborder center" width="10%">5</td>
                        <td class="tborder center" width="10%">6</td>
                        <td class="tborder center" width="10%">7</td>
                        <td class="tborder center" width="10%">8</td>
                    </tr>
                </thead>
                <xsl:apply-templates select="Object/LocalEstimate"/>
                <xsl:apply-templates select="Object/SubSummary1"/>
                <xsl:apply-templates select="Object/TempBuildings"/>
                <xsl:apply-templates select="Object/SubSummary2"/>
                <xsl:apply-templates select="Object/Additions"/>
                <xsl:apply-templates select="Object/SubSummary3"/>
                <xsl:apply-templates select="Object/Extra"/>
                <xsl:apply-templates select="Object/SubSummary4"/>
                
                <tr>
                    <td colspan="2"></td>
                    <td class="left bold">ВСЕГО</td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Summary/Building, 2)'/>
                    </td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Summary/Mounting, 2)'/>
                    </td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Summary/Equipment, 2)'/>
                    </td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Summary/Other, 2)'/>
                    </td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Summary/Total, 2)'/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"></td>
                    <td class="left" colspan="6"><i>в том числе:</i></td>
                </tr>
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">ОТ</td>
                    <td colspan="4"></td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Summary/WorkersSalary, 2)'/>
                    </td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">ЭМ</td>
                    <td colspan="4"></td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Summary/Machines, 2)'/>
                    </td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent2"><i>в том чисте ОТм</i></td>
                    <td colspan="4"></td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Summary/MachinistSalary, 2)'/>
                    </td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">М</td>
                    <td colspan="4"></td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Summary/Materials, 2)'/>
                    </td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">Перевозка</td>
                    <td colspan="4"></td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Summary/TransportTotal, 2)'/>
                    </td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">НР</td>
                    <td colspan="4"></td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Summary/Overhead, 2)'/>
                    </td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">СП</td>
                    <td colspan="4"></td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Summary/Profit, 2)'/>
                    </td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">оборудование</td>
                    <td colspan="4"></td>
                    <td class="bold"> <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Equipment/Total, 2)'/></td> 
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">прочие затраты</td>
                    <td colspan="4"></td>
                    <td class="bold">
                        <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Details/Other, 2)'/>
                    </td>
                </tr>				
            </table>
			
			<table class="sign-table" align="left">
				<tr>
					<td colspan="2" width="24%">Главный инженер проекта</td>
					<td class="centered bordered" colspan="3" width="78%"><xsl:value-of select="Object/Signatures/ChiefProjectEngineer/Name"/></td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td class="centered helptext" colspan="3">[подпись (инициалы, фамилия)]</td>
				</tr>
				
				<tr>
					<td width="10%">Начальник</td>
					<td class="centered bordered" colspan="2" width="45%">
						<xsl:value-of select="Object/Signatures/Chief/Name"/>
					</td>
					<td class="centered" width="8%">отдела</td>
					<td class="centered bordered" width="37%"><xsl:value-of select="Object/Signatures/Chief/Department"/></td>
				</tr>
				<tr>
					<td width="10%"></td>
					<td class="centered helptext" colspan="2">[подпись (инициалы, фамилия)]</td>
					<td width="8%"></td>
					<td class="centered helptext">[наименование]</td>
				</tr>
				
				<tr>
					<td width="10%">Составил</td>
					<td class="centered bordered" colspan="4" width="90%">
						<xsl:value-of select="Object/Signatures/Composer/Position"/> 
						<xsl:value-of select="Object/Signatures/Composer/Name"/>
					</td>
				</tr>
				<tr>
					<td width="10%"></td>
					<td class="centered helptext" colspan="4" width="90%">[должность, подпись (инициалы, фамилия)]</td>
				</tr>
				
				<tr>
					<td width="10%">Проверил</td>
					<td class="centered bordered" colspan="4" width="90%">
						<xsl:value-of select="Object/Signatures/Verifier/Position"/> 
						<xsl:value-of select="Object/Signatures/Verifier/Name"/>
					</td>
				</tr>
				<tr>
					<td width="10%"></td>
					<td class="centered helptext" colspan="4" width="90%">[должность, подпись (инициалы, фамилия)]</td>
				</tr>
			</table>	
        </div>
    </xsl:template>
    
    <!-- Строки --> 
    <xsl:template match="LocalEstimate | TempBuildings | Additions  | Extra">
        <xsl:param name="type" select="0"/>
        <tr>
            <td class="center"><xsl:value-of select="Num"/></td>
            <td class="center"><xsl:value-of select="Reason"/></td>
            <td class="left">
                <xsl:value-of select="Name"/> 
                <xsl:if test="Percent">
                    (<xsl:value-of select="Name"/>%)
                </xsl:if>
            </td>
            <td> 
                <xsl:value-of select='util:formatNumberWithZeroCheck(Building, 2)'/> 
            </td>
            <td>
                <xsl:value-of select='util:formatNumberWithZeroCheck(Mounting, 2)'/>
            </td>
            <td>
                <xsl:value-of select='util:formatNumberWithZeroCheck(Equipment, 2)'/>
            </td>
            <td>
                <xsl:value-of select='util:formatNumberWithZeroCheck(Other, 2)'/>
            </td>
            <td>
                <xsl:value-of select='util:formatNumberWithZeroCheck(Total, 2)'/>
            </td>
        </tr>
    </xsl:template>
    
    <!-- Итоги -->
    <xsl:template match="*[contains(name(), 'SubSummary')]">
        <xsl:param name="type" select="0"/>
        <tr>
            <td class="center"></td>
            <td class="center"></td>
            <td class="left bold">Итого</td>
            <td class="bold">
<!--                <xsl:value-of select="Building"/>-->
                <xsl:value-of select='util:formatNumberWithZeroCheck(Building, 2)'/>
            </td>
            <td class="bold"><xsl:value-of select='util:formatNumberWithZeroCheck(Mounting, 2)'/>
            </td>
            <td class="bold">
                <xsl:value-of select='util:formatNumberWithZeroCheck(Equipment, 2)'/>
            </td>
            <td class="bold">
                <xsl:value-of select='util:formatNumberWithZeroCheck(Other, 2)'/>
            </td>
            <td class="bold">
                <xsl:value-of select='util:formatNumberWithZeroCheck(Total, 2)'/>
            </td>
        </tr>
    </xsl:template>
    
</xsl:stylesheet>
