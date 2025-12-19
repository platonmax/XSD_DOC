<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:util="http://www.gge.ru/utils"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output omit-xml-declaration="yes" encoding="UTF-8"  indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Универсальное форматирование чисел: пустые значения не трогаем, иначе ставим пробелы в разрядах и запятую как разделитель дробной части -->
    <xsl:function name="util:formatNumberWithZeroCheck">
        <xsl:param name="number"/>
        <xsl:param name="decimalPlaces" as="xs:integer"/>
        
        <xsl:choose>
            <xsl:when test="normalize-space(string($number)) = '' or number($number) != number($number)">
                <xsl:value-of select="string($number)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="decimalPlacesValue" select="if (not($decimalPlaces)) then 2 else $decimalPlaces"/>
                <xsl:variable name="formatPattern">
                    <xsl:text>#,##0.</xsl:text>
                    <xsl:for-each select="1 to $decimalPlacesValue">
                        <xsl:text>0</xsl:text>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="formattedNumber" select="format-number($number, $formatPattern)"/>
                <xsl:variable name="translatedNumber" select="translate($formattedNumber, ',', ' ')"/>
                <xsl:variable name="finalNumber" select="translate($translatedNumber, '.', ',')"/>
                <xsl:value-of select="$finalNumber"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Функция для форматирования даты/квартала -->
	<xsl:function name="util:formatQuarterDate">
		<xsl:param name="year" as="xs:string"/>
		<xsl:param name="quarter" as="xs:string"/>
		<xsl:param name="month" as="xs:string?"/>
		<xsl:param name="day" as="xs:string?"/>
		
		<xsl:variable name="quarterNames" select="('I квартал', 'II квартал', 'III квартал', 'IV квартал')"/>
		<xsl:variable name="quarterName" select="$quarterNames[number($quarter)]"/>
		
		<xsl:choose>
			<xsl:when test="string-length(if($month) then $month else '') &gt; 0 
				and string-length(if($day) then $day else '') &gt; 0">
				<xsl:value-of select="concat(format-number(number($day), '00'), '.', format-number(number($month), '00'), '.', $year)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($quarterName, ' ', $year)"/>
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
                    
                    div.heading-left2 { margin-left:1.7em; display:flex; width:30%; margin-top: 2em; min-height: 1em; }
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

            <div class="heading">
                Основание<div class="headingvalue center"><xsl:value-of select="Object/Reason"/></div>
            </div>
            <div class="helptext">(проектная и (или) иная техническая документация)</div>

            <div class="heading">
                <nobr><b>Сметная стоимость</b>&#160;&#160;&#160;</nobr> 
                <div class="headingvalue right"><b>
    <xsl:value-of select='util:formatNumberWithZeroCheck(Object/Summary/Total, 2)'/>
                    </b>
                </div>
                <nobr>&#160;&#160;&#160;<b>тыс. руб.</b></nobr>
            </div>			
            <br/>
            <div class="heading">
                <div style="width:30%;">
                    Расчетный измеритель объекта капитального строительства&#160;&#160;&#160;
                </div>
                <div style="width:35%;">
                    <div class="headingvalue right" style="width:100%; text-align:center;">
                        <xsl:value-of select="Object/Quantity"/>
                    </div>
                    <div class="helptext">(количество)</div>
                </div>&#160;&#160;&#160;
                <div style="width:35%;">
                    <div class="headingvalue right" style="width:100%; text-align:center;">
                        <xsl:value-of select="Object/QuantityUnit"/>
                    </div>
                    <div class="helptext">(измеритель)</div>
                </div>
            </div>
            <div class="heading">
                <div style="width:35%;">
                Показатель единичной стоимости на расчетный измеритель объекта капитального строительства&#160;&#160;&#160;
                </div>
    <div class="headingvalue right" style="width:65%; display:flex;"><span style="align-self: flex-end;	width: 100%;"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/PricePerUnit, 2)"/></span></div>&#160;&#160;&#160;
                <div style="display:flex;"><span style="align-self: flex-end;	width: 100%;"><nobr>тыс.руб.</nobr></span></div>	
            </div>
            <br/>
            <div class="heading">
                <b>Составлен в ценах по состоянию на</b>&#160;&#160;&#160;
                <!-- ИЗМЕНЕНО/НОВО: Вместо вызовов шаблонов, используем функцию -->
                <xsl:if test="Object/PriceLevel">
                    <xsl:value-of select="util:formatQuarterDate(
                                                Object/PriceLevel/Year, 
                                                Object/PriceLevel/Quarter, 
                                                Object/PriceLevel/Month, 
                                                Object/PriceLevel/Day
                                            )"/>
                </xsl:if>
                <!-- /ИЗМЕНЕНО/НОВО -->
            </div>
            
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
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Summary/Building, 2)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Summary/Mounting, 2)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Summary/Equipment, 2)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Summary/Other, 2)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Summary/Total, 2)"/></td>
                </tr>
                <tr>
                    <td colspan="2"></td>
                    <td class="left" colspan="6"><i>в том числе:</i></td>
                </tr>
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">ОТ</td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Summary/WorkersSalary, 2)"/></td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">ЭМ</td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Summary/Machines, 2)"/></td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent2"><i>в том чисте ОТм</i></td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Summary/MachinistSalary, 2)"/></td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">М</td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Summary/Materials, 2)"/></td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">Перевозка</td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Summary/TransportTotal, 2)"/></td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">НР</td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Summary/Overhead, 2)"/></td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">СП</td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Summary/Profit, 2)"/></td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">оборудование</td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Equipment/Total, 2)"/></td>
                </tr>				
                <tr>
                    <td colspan="2"></td>
                    <td class="left indent">прочие затраты</td>
                    <td colspan="4"></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Object/Details/Other, 2)"/></td>
                </tr>				
            </table>
            <div class="heading-left3">
                <div class="headingname">Главный инженер проекта</div>
                <div class="headingvalue center"><xsl:value-of select="Object/Signatures/ChiefProjectEngineer/Name"/></div>
            </div>
            <div class="heading-left3" style="margin-top: 0;">
                <div class="helptext center">[подпись (инициалы, фамилия)]</div>
            </div>
            <p></p>
            <div class="heading-left3">
                <div class="headingname">Начальник</div>
                <div class="headingvalue center"><xsl:value-of select="Object/Signatures/Chief/Name"/></div>
                <div class="headingname"> отдела</div>
                <div class="headingvalue  center"><xsl:value-of select="Object/Signatures/Chief/Department"/></div>
            </div>
            <div class="heading-left3" style="margin-top: 0;">
                <div class="helptext center">[подпись (инициалы, фамилия)]</div>
                <div class="helptext">[наименование]</div>
            </div>
            <p></p>
            <div class="heading-left3">
                <div class="headingname">Составил</div>
                <div class="headingvalue center">
                    <xsl:value-of select="Object/Signatures/Composer/Position"/> 
                    <xsl:value-of select="Object/Signatures/Composer/Name"/>
                </div>
            </div>
            <div class="heading-left3" style="margin-top: 0;">
                <div class="helptext">[должность, подпись (инициалы, фамилия)]</div>
            </div>
            <p></p>
            <div class="heading-left3">
                <div class="headingname">Проверил</div>
                <div class="headingvalue center">
                    <xsl:value-of select="Object/Signatures/Verifier/Position"/> 
                    <xsl:value-of select="Object/Signatures/Verifier/Name"/>
                </div>
            </div>
            <div class="heading-left3" style="margin-top: 0;">
                <div class="helptext">[должность, подпись (инициалы, фамилия)]</div>
            </div>
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
            <td><xsl:value-of select="util:formatNumberWithZeroCheck(Building, 2)"/></td>
            <td><xsl:value-of select="util:formatNumberWithZeroCheck(Mounting, 2)"/></td>
            <td><xsl:value-of select="util:formatNumberWithZeroCheck(Equipment, 2)"/></td>
            <td><xsl:value-of select="util:formatNumberWithZeroCheck(Other, 2)"/></td>
            <td><xsl:value-of select="util:formatNumberWithZeroCheck(Total, 2)"/></td>
        </tr>
    </xsl:template>
    
    <!-- Итоги -->
    <xsl:template match="*[contains(name(), 'SubSummary')]">
        <xsl:param name="type" select="0"/>
        <tr>
            <td class="center"></td>
            <td class="center"></td>
            <td class="left bold">Итого</td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Building, 2)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Mounting, 2)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Equipment, 2)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Other, 2)"/></td>
        <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Total, 2)"/></td>
        </tr>
    </xsl:template>
    
</xsl:stylesheet>
