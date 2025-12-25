<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="http://www.gge.ru/utils" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
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
    
    


    <!-- Функция форматирования даты Approved в стиле «01" января 2023 г.»  -->
    <xsl:function name="util:formatDate">
        <xsl:param name="date" as="xs:string"/>
        <xsl:variable name="monthNames" select="'января февраля марта апреля мая июня июля августа сентября октября ноября декабря'"/>
        <xsl:variable name="day" select="substring($date, 9, 2)"/>
        <xsl:variable name="month" select="number(substring($date, 6, 2))"/>
        <xsl:variable name="monthName" select="tokenize($monthNames, ' ')[$month]"/>
        <xsl:variable name="year" select="substring($date, 1, 4)"/>
        <xsl:value-of select="concat($day, '&quot; ', $monthName, ' ', $year, ' г.')"/>
    </xsl:function>

    <!-- Функция для форматирования чисел с проверкой на 0 -->
    <xsl:function name="util:formatNumberWithZeroCheck" as="xs:string">
        <xsl:param name="number" as="xs:double?"/>
        <xsl:value-of select="util:formatNumberWithZeroCheck($number, 2)"/>
    </xsl:function>

    <xsl:function name="util:formatNumberWithZeroCheck" as="xs:string">
        <xsl:param name="number" as="xs:double?"/>
        <xsl:param name="decimalPlaces" as="xs:integer"/>

        <xsl:variable name="decimalPlacesValue" select="$decimalPlaces"/>

        <xsl:choose>
            <xsl:when test="not($number) or $number = 0">
                <xsl:text>0,00</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="formatPattern">
                    <xsl:text>#,##0</xsl:text>
                    <xsl:if test="$decimalPlacesValue &gt; 0">
                        <xsl:text>.</xsl:text>
                        <xsl:for-each select="1 to $decimalPlacesValue">
                            <xsl:text>#</xsl:text>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:variable>

                <xsl:variable name="formattedNumber">
                    <xsl:value-of select="format-number($number, $formatPattern)"/>
                </xsl:variable>

                <xsl:variable name="translatedThousands">
                    <xsl:value-of select="translate($formattedNumber, ',', ' ')"/>
                </xsl:variable>

                <xsl:variable name="finalNumber">
                    <xsl:value-of select="translate($translatedThousands, '.', ',')"/>
                </xsl:variable>

                <xsl:value-of select="$finalNumber"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:output omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Главный шаблон -->
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <style type="text/css" id="styles"> 
                    h1 { font-family: Times New Roman; font-size: 12pt; font-weight:bold; text-align:center; width:100%; margin-top: 2em; }
                    body,p,td { font-family: Times New Roman; font-size: 10pt; margin:0;}
                    
                    div.heading-left2 { margin-left:1.7em; display:flex; white-space: nowrap;  flex-wrap: nowrap; width:50%; margin-top: 0.5em; min-height: 1em;}
                    div.heading-left2 .headingvalue { border-bottom: 1px solid black; white-space: nowrap; flex: 1; }

                    div.heading-left3 { margin-left:1.7em; display:flex; width:50%; margin-top: 0.5em; min-height: 1em;}
                    div.heading-left3 .headingvalue { border-bottom: 1px solid black; flex: 1; }
                    
                    div.helptext { text-align:center; width:100%; margin-top:0;}
                    
                    div.headingname { white-space: nowrap; margin-right:0.3em; margin-left:0.3em; flex-grow: *; min-height: 1em;}
                    
                    div.heading-left { display:flex; width:50%; margin-bottom: 0.5em; min-height: 1em;}
                    div.heading-left .headingvalue { border-bottom: 1px solid black; flex-grow: 2;}
                    
                    div.spacer {flex: 1;}

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
                    th.chapter {border: none; border-top: 1px solid black; border-bottom: 1px solid black; padding: 0.5em; vertical-align: top;}
                    th.leftborder {border: none; border-top: 1px solid black; border-bottom: 1px solid black; padding: 0.5em; vertical-align: top;}
                    
                    td {border: 0px; padding: 0.2em 0.5em; vertical-align: top; text-align:right}
                    td.tborder {border: 1px solid black}
                    td.btop {border-top: 1px solid black}
                    td.bbottom {border-bottom: 1px solid black}
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

    <!-- Шаблон для Construction -->
    <xsl:template match="Construction" mode="render">
        <div class="main">
            
            <div class="heading-left2">
                <xsl:text>Дата и время выгрузки файла из сметного программного комплекса: </xsl:text>
                <xsl:value-of 
                    select="concat(
                              substring(ExportDateTime, 9, 2), '.', 
                              substring(ExportDateTime, 6, 2), '.', 
                              substring(ExportDateTime, 1, 4), ' ', 
                              substring(ExportDateTime, 12, 5)
                           )" />
            </div>
			
			<table class="req-table" align="center">
				<tr>
					<td width="100">Заказчик</td>
					<td class="bordered" colspan="4" width="100%"><xsl:value-of select="Customer"/></td>
				</tr>
				<tr>
				    <td width="100">Утвержден</td>
					<td class="bordered" colspan="3" width="32%">
						<xsl:variable name="formattedDate" select="util:formatDate(Approved)"/>
						<xsl:value-of select="$formattedDate"/>
					</td>
					<td width="48%"></td>
				</tr>
				<tr>
				    <td class="bold" width="270" colspan="2">Сводный сметный расчет сметной стоимостью</td>
					<td class="bordered right" width="27%">
                        <xsl:value-of select="util:formatNumberWithZeroCheck(Summary/Total, 2)"/>
					</td>
					<td width="5%">тыс. руб.</td>
					<td width="40%"></td>
				</tr>
			</table>
		
            <div class="heading">
                <div class="headingvalue"><xsl:value-of select="StatementDoc"/></div>
            </div>	
            
            <div class="center">(Ссылка на документ об утверждении)</div>
            
            <h1 id="EstimateNum">
                СВОДНЫЙ СМЕТНЫЙ РАСЧЁТ СТОИМОСТИ СТРОИТЕЛЬСТВА № ССРСС-
                <xsl:value-of select="Num"/>
            </h1>
            
            <div class="heading">
                <div class="headingvalue center">
                    <xsl:value-of select="Name"/>
                </div>
            </div>
            <div class="helptext">(наименование)</div>

            
            <!-- Логика вывода цены (дата или квартал) -->
            <div class="heading-left2">
                <div class="headingname">
                    <xsl:if test="PriceLevel">
                        <xsl:choose>
                            <xsl:when test="PriceLevel/BasicPrice = 'false' or PriceLevel/BasicPrice = '0'">
                                <b>Составлен в текущем уровне цен </b>
                                <!-- Вызываем нашу новую/изменённую функцию -->
                                <xsl:value-of 
                                    select="util:formatQuarterDate(
                                               PriceLevel/Year,
                                               PriceLevel/Quarter,
                                               PriceLevel/Month,
                                               PriceLevel/Day
                                           )"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <b>Составлен в базисном уровне цен </b>
                                <!-- Аналогично -->
                                <xsl:value-of 
                                    select="util:formatQuarterDate(
                                               PriceLevel/Year,
                                               PriceLevel/Quarter,
                                               PriceLevel/Month,
                                               PriceLevel/Day
                                           )"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </div>
            </div>
            <!-- /ИЗМЕНЕНО/НОВО -->

            <table>
                <thead>
                    <tr>
                        <th scope="col" rowspan="2">№ п.п.</th>
                        <th scope="col" rowspan="2" nowrap="nowrap">Обоснование</th>
                        <th scope="col" rowspan="2">Наименование глав, объектов капитального строительства, работ и затрат</th>
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

                <!-- Главы -->
                <xsl:apply-templates select="Chapter1" mode="Chapter"/>
                <xsl:apply-templates select="Chapter2" mode="Chapter"/>
                <xsl:apply-templates select="Chapter3" mode="Chapter"/>
                <xsl:apply-templates select="Chapter4" mode="Chapter"/>
                <xsl:apply-templates select="Chapter5" mode="Chapter"/>
                <xsl:apply-templates select="Chapter6" mode="Chapter"/>
                <xsl:apply-templates select="Chapter7" mode="Chapter"/>
                <xsl:apply-templates select="Chapter8" mode="Chapter"/>
                <xsl:apply-templates select="Chapter9" mode="Chapter"/>
                <xsl:apply-templates select="Chapter10" mode="Chapter"/>
                <xsl:apply-templates select="Chapter11" mode="Chapter"/>
                <xsl:apply-templates select="Chapter12" mode="Chapter"/>
                <xsl:apply-templates select="Chapter13" mode="Chapter"/>
                <xsl:apply-templates select="Chapter14" mode="Chapter"/>

                <!-- Итого по сводному сметному расчету -->
                <tr>
                    <td class="center bold"></td>
                    <td class="left bold btop bbottom" colspan="2">
                        ВСЕГО ПО СВОДНОМУ СМЕТНОМУ РАСЧЕТУ
                    </td>
                    <td class="bold btop bbottom">
                        <xsl:value-of select="util:formatNumberWithZeroCheck(Summary/Building)"/>
                    </td>
                    <td class="bold btop bbottom">
                        <xsl:value-of select="util:formatNumberWithZeroCheck(Summary/Mounting)"/>
                    </td>
                    <td class="bold btop bbottom">
                        <xsl:value-of select="util:formatNumberWithZeroCheck(Summary/Equipment)"/>
                    </td>
                    <td class="bold btop bbottom">
                        <xsl:value-of select="util:formatNumberWithZeroCheck(Summary/Other)"/>
                    </td>
                    <td class="bold btop bbottom">
                        <xsl:value-of select="util:formatNumberWithZeroCheck(Summary/Total)"/>
                    </td>
                </tr>

                <!-- Итого по этапам (SubSummaryStageALL) -->
                <xsl:apply-templates select="SubSummaryStageALL">
                    <xsl:with-param name="chapter" select="ALL" tunnel="yes"/>
                </xsl:apply-templates>
            </table>
			
			<table class="sign-table" align="left">
				<tr>
					<td colspan="2" width="32%">Руководитель проектной организации</td>
					<td class="centered bordered" colspan="3" width="68%"><xsl:value-of select="Signatures/ProjectOrg/Name"/></td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td class="centered helptext" colspan="3">[подпись (инициалы, фамилия)]</td>
				</tr>
				
				<tr>
					<td colspan="2" width="32%">Главный инженер проекта</td>
					<td class="centered bordered" colspan="3" width="68%"><xsl:value-of select="Signatures/ChiefProjectEngineer/Name"/></td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td class="centered helptext" colspan="3">[подпись (инициалы, фамилия)]</td>
				</tr>
				
				<tr>
					<td width="10%">Начальник</td>
					<td class="centered bordered" colspan="2" width="37%">
						<xsl:value-of select="Signatures/Chief/Department"/>
					</td>
					<td class="centered" width="8%">отдела</td>
					<td class="centered bordered" width="45%">
						<xsl:value-of select="Signatures/Chief/Name"/>
					</td>
				</tr>
				<tr>
					<td width="10%"></td>
					<td class="centered helptext" colspan="2">[наименование]</td>
					<td width="8%"></td>
					<td class="centered helptext">[подпись (инициалы, фамилия)]</td>
				</tr>
				
				<tr>
					<td width="10%">Заказчик</td>
					<td class="centered bordered" colspan="4" width="90%">
						<xsl:value-of select="Signatures/Customer/Position"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="Signatures/Customer/Name"/>
					</td>
				</tr>
				<tr>
					<td></td>
					<td class="centered helptext" colspan="4">[должность, подпись (инициалы, фамилия)]</td>
				</tr>
			</table>	       
        </div>
    </xsl:template>

    <!-- Шаблон для глав (Chapter1..Chapter14) -->
    <xsl:template match="Chapter1 | Chapter2 | Chapter3 | Chapter4 | Chapter5 | Chapter6 | Chapter7 | Chapter8 | Chapter9 | Chapter10 | Chapter11 | Chapter12 | Chapter13 | Chapter14" mode="Chapter">
        <xsl:variable name="context" select="."/> 
        <xsl:variable name="chapter" select="number(substring-after(name(), 'Chapter'))"/>

        <!-- Если сумма по главе = 0, то пропускаем -->
        <xsl:choose>
            <xsl:when test="./Summary/Total != 0">
                
                <!-- Получаем название главы: сначала см. CustomerNameChapter, иначе ConstantNameChapter -->
                <xsl:variable name="chapterName">
                    <xsl:choose>
                        <xsl:when test="normalize-space($context/ChapterName/CustomerNameChapter)">
                            <xsl:value-of select="$context/ChapterName/CustomerNameChapter"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$context/ChapterName/ConstantNameChapter"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="chapterPrefix">
                    <xsl:choose>
                        <xsl:when test="($chapter >= 1) and ($chapter &lt;= 12)">
                            <xsl:text>Глава </xsl:text><xsl:value-of select="$chapter"/><xsl:text>.  </xsl:text>
                        </xsl:when>
                        <xsl:when test="$chapter > 12"/>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="chapterSummaryText">
                    <xsl:choose>
                        <xsl:when test="($chapter >= 1) and ($chapter &lt;= 12)">
                            <xsl:text>Итого по главе: </xsl:text>
                            <xsl:value-of select="$chapter"/>
                            <xsl:text>. "</xsl:text>
                            <xsl:value-of select="$chapterName"/>
                            <xsl:text>"</xsl:text>
                        </xsl:when>
                        <xsl:when test="$chapter > 12">
                            <xsl:text>Итого "</xsl:text>
                            <xsl:value-of select="$chapterName"/>
                            <xsl:text>"</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>

                <xsl:if test="sum(.//Total) != 0">
                    <tr>
                        <th class="chapter left" colspan="8">
                            <xsl:value-of select="$chapterPrefix"/> 
                            <xsl:value-of select="$chapterName"/>
                        </th>
                    </tr>

                    <!-- Группируем по StageName -->
                    <xsl:for-each-group select="$context/*[self::LocalEstimate or self::ObjectEstimate or self::Calculation or self::Addition]" group-by="StageName">
                        <xsl:sort select="current-grouping-key()" data-type="number" order="ascending"/>

                        <!-- Если StageID != 0, выводим заголовок этапа -->
                        <xsl:if test="not(current-group()/StageID = 0)">
                            <tr>
                                <td class="bbottom left btop" colspan="8">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </td>
                            </tr>
                        </xsl:if>

                        <!-- Обрабатываем элементы внутри группы -->
                        <xsl:apply-templates select="current-group()" mode="Rows">
                            <xsl:with-param name="chapter" select="$chapter" tunnel="yes"/>
                            <xsl:with-param name="chapterName" select="$chapterName" tunnel="yes"/>
                            <xsl:with-param name="chapterSummaryText" select="$chapterSummaryText" tunnel="yes"/>
                        </xsl:apply-templates>
                    </xsl:for-each-group>

                    <!-- Addition без StageNum -->
                    <xsl:for-each select="$context/Addition[not(StageNum)]">
                        <tr>
                            <td class="center"><xsl:value-of select="Num"/></td>
                            <td class="center"><xsl:value-of select="Reason"/></td>
                            <td class="left"><xsl:value-of select="Name"/></td>
                            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Building)"/></td>
                            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Mounting)"/></td>
                            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Equipment)"/></td>
                            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Other)"/></td>
                            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Total)"/></td>
                        </tr>
                    </xsl:for-each>

                    <!-- Итого по главе -->
                    <xsl:apply-templates select="$context/Summary" mode="Summary">
                        <xsl:with-param name="chapter" select="$chapter" tunnel="yes"/>
                        <xsl:with-param name="chapterName" select="$chapterName" tunnel="yes"/>
                        <xsl:with-param name="chapterSummaryText" select="$chapterSummaryText" tunnel="yes"/>
                    </xsl:apply-templates>

                    <!-- Связанные этапы -->
                    <xsl:apply-templates select="$context/RelatedStage">
                        <xsl:with-param name="chapter" select="$chapter" tunnel="yes"/>
                        <xsl:with-param name="chapterName" select="$chapterName" tunnel="yes"/>
                    </xsl:apply-templates>

                    <!-- Промежуточный итог по главам -->
                    <xsl:apply-templates select="$context/SubSummary" mode="Rows">
                        <xsl:with-param name="chapter" select="$chapter" tunnel="yes"/>
                        <xsl:with-param name="chapterName" select="$chapterName" tunnel="yes"/>
                        <xsl:with-param name="chapterSummaryText" select="$chapterSummaryText" tunnel="yes"/>
                    </xsl:apply-templates>

                    <!-- Итого по этапу -->
                    <xsl:apply-templates select="$context/SubSummaryStage">
                        <xsl:with-param name="chapter" select="$chapter" tunnel="yes"/>
                        <xsl:with-param name="chapterName" select="$chapterName" tunnel="yes"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Шаблон для RelatedStage -->
    <xsl:template match="RelatedStage">
        <xsl:param name="chapter" tunnel="yes"/>
        <xsl:param name="chapterName" tunnel="yes"/>
        <xsl:param name="numSummaryValue" tunnel="yes" />

        <tr>
            <td class="left italic">
                <xsl:value-of select="../Summary/NumSummary"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="StageID"/>
            </td>
            <td class="left italic" colspan="2">
                в т.ч. по  Этапу <xsl:value-of select="StageID"/>:
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Building)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Mounting)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Equipment)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Other)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Total)"/>
            </td>
        </tr>
    </xsl:template>

    <!-- Итого по главе (Summary) -->
    <xsl:template match="Summary" mode="Summary">
        <xsl:param name="chapter" tunnel="yes"/>
        <xsl:param name="chapterName" tunnel="yes"/>
        <xsl:param name="chapterSummaryText" tunnel="yes"/>
        <xsl:param name="numSummaryValue" tunnel="yes" />

        <tr>
            <td class="center bold">
                <xsl:value-of select="NumSummary"/>
            </td>
            <td class="left bold" colspan="2">
                <xsl:value-of select="$chapterSummaryText"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Building)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Mounting)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Equipment)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Other)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Total)"/>
            </td>
        </tr>
    </xsl:template>

    <!-- Шаблон для SubSummaryStage (отдельный этап) -->
    <xsl:template match="SubSummaryStage">
        <xsl:param name="chapter" tunnel="yes"/>
        <xsl:param name="chapterName" tunnel="yes"/>

        <tr>
            <td class="center bold"/>
            <td class="left italic" colspan="2">
                Итого по главам 1-<xsl:value-of select="$chapter"/>
                <xsl:text> (этап </xsl:text>
                <xsl:value-of select="StageID"/>
                <xsl:text>)</xsl:text>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Building)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Mounting)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Equipment)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Other)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Total)"/>
            </td>
        </tr>
    </xsl:template>

    <!-- Шаблон для SubSummaryStageALL (итог по всему сводному сметному) -->
    <xsl:template match="SubSummaryStageALL">
        <xsl:param name="chapter" tunnel="yes"/>
        <xsl:param name="chapterName" tunnel="yes"/>

        <tr>
            <td class="center bold"/>
            <td class="left italic" colspan="2">
                Итого по сводному сметному расчету (этап 
                <xsl:value-of select="StageID"/>
                ):
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Building)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Mounting)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Equipment)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Other)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(StageTotal/Total)"/>
            </td>
        </tr>
    </xsl:template>

    <!-- Строки глав -->
    <xsl:template name="LocalEstimate" match="LocalEstimate | ObjectEstimate | Calculation | Addition" mode="Rows">
        <xsl:param name="chapter" tunnel="yes"/>
        <xsl:param name="chapterName" tunnel="yes"/>
        <xsl:param name="chapterSummaryText" tunnel="yes"/>
        
        <xsl:variable name="numSummaryValue" select="Num"/>

        <tr>
            <td class="center"><xsl:value-of select="Num"/></td>
            <td class="center"><xsl:value-of select="Reason"/></td>
            <td class="left"><xsl:value-of select="Name"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Building)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Mounting)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Equipment)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Other)"/></td>
            <td class="bold"><xsl:value-of select="util:formatNumberWithZeroCheck(Total)"/></td>
        </tr>
    </xsl:template>

    <!-- Промежуточный итог SubSummary -->
    <xsl:template match="SubSummary" mode="Rows">
        <xsl:param name="chapter" tunnel="yes"/>
        <xsl:param name="chapterName" tunnel="yes"/>
        <xsl:param name="chapterSummaryText" tunnel="yes"/>

        <tr>
            <td class="center bold"/>
            <td class="left bold">
                <xsl:choose>
                    <xsl:when test="$chapter = 13">
                        Итого по главам
                    </xsl:when>
                    <xsl:otherwise>
                        Итого по главам 1-<xsl:value-of select="$chapter"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        	<td></td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Building)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Mounting)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Equipment)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Other)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Total)"/>
            </td>
        </tr>
    </xsl:template>

    <!-- Итог по главе (Summary) в режиме Rows -->
    <xsl:template match="Summary" mode="Rows">
        <xsl:param name="chapter" tunnel="yes"/>
        <xsl:param name="chapterName" tunnel="yes"/>
        <xsl:param name="chapterSummaryText" tunnel="yes"/>

        <tr>
            <td class="center bold"/>
            <td class="left bold" colspan="2">
                <xsl:value-of select="$chapterSummaryText"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Building)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Mounting)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Equipment)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Other)"/>
            </td>
            <td class="bold">
                <xsl:value-of select="util:formatNumberWithZeroCheck(Total)"/>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
