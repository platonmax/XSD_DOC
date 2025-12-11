<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"	xmlns:util="urn:market-analysis:util:v1"
	exclude-result-prefixes="xs"
	version="2.0">
	<xsl:output omit-xml-declaration="yes" encoding="UTF-8"	indent="yes"/>
	<xsl:function name="util:format-numbers-in-formula" as="xs:string">
		<xsl:param name="formula" as="xs:string?"/>
		
		<xsl:variable name="result">
			<xsl:analyze-string select="$formula" regex="-?\d+(\.\d+)?">
				<xsl:matching-substring>
					<xsl:variable name="raw" select="regex-group(0)"/>
					<xsl:variable name="negative" select="starts-with($raw, '-')"/>
					<xsl:variable name="number" select="replace($raw, '^-', '')"/>
					<xsl:variable name="integer" select="replace($number, '\..*$', '')"/>
					<xsl:variable name="fraction" select="if (contains($number, '.')) then replace($number, '^\d+\.', '') else ''"/>
					
					<!-- Форматируем целую часть вручную, справа налево -->
					<xsl:variable name="len" select="string-length($integer)"/>
					<xsl:variable name="groups" as="xs:string*">
						<xsl:for-each select="reverse(1 to xs:integer(ceiling($len div 3)))">
							<xsl:variable name="start" select="$len - (3 * .) + 1"/>
							<xsl:sequence select="substring($integer, $start, 3)"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="intFormatted" select="string-join($groups, ' ')"/>
					
					<xsl:value-of select="concat(if ($negative) then '-' else '', $intFormatted,
						if ($fraction != '') then concat(',', $fraction) else '')"/>
				</xsl:matching-substring>
				
				<xsl:non-matching-substring>
					<xsl:value-of select="."/>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:variable>
		
		<xsl:sequence select="string-join($result, '')"/>
	</xsl:function>
	
	
	
	
	
	<xsl:function name="util:formatNumberWithZeroCheck">
		<xsl:param name="number"/>
		<xsl:param name="decimalPlaces" as="xs:integer"/>
		
		<xsl:variable name="decimalPlacesValue" select="if (not($decimalPlaces)) then 2 else $decimalPlaces"/>
		
		<xsl:choose>
			<xsl:when test="not($number) or string($number) = 'NaN'">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="formatPattern">
					<xsl:text>#,##0.</xsl:text>
					<xsl:for-each select="1 to $decimalPlacesValue">
						<xsl:text>0</xsl:text>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:variable name="formattedNumber">
					<xsl:value-of select="format-number($number, $formatPattern)"/>
				</xsl:variable>
				
				<xsl:variable name="translatedNumber">
					<xsl:value-of select="translate($formattedNumber, ',', ' ')"/>
				</xsl:variable>
				
				<xsl:variable name="finalNumber">
					<xsl:value-of select="translate($translatedNumber, '.', ',')"/>
				</xsl:variable>
				
				<xsl:value-of select="$finalNumber"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="util:get-month-name" as="xs:string">
		<xsl:param name="monthNumber" as="xs:string"/>
		
		<xsl:choose>
			<xsl:when test="$monthNumber = '01'">январь</xsl:when>
			<xsl:when test="$monthNumber = '02'">февраль</xsl:when>
			<xsl:when test="$monthNumber = '03'">март</xsl:when>
			<xsl:when test="$monthNumber = '04'">апрель</xsl:when>
			<xsl:when test="$monthNumber = '05'">май</xsl:when>
			<xsl:when test="$monthNumber = '06'">июнь</xsl:when>
			<xsl:when test="$monthNumber = '07'">июль</xsl:when>
			<xsl:when test="$monthNumber = '08'">август</xsl:when>
			<xsl:when test="$monthNumber = '09'">сентябрь</xsl:when>
			<xsl:when test="$monthNumber = '10'">октябрь</xsl:when>
			<xsl:when test="$monthNumber = '11'">ноябрь</xsl:when>
			<xsl:when test="$monthNumber = '12'">декабрь</xsl:when>
			<xsl:otherwise>неизвестно</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<xsl:function name="util:removeTrailingZeros">
		<xsl:param name="formattedString" as="xs:string?"/>
		
		<xsl:choose>
			<xsl:when test="not($formattedString) or $formattedString = ''">
				<xsl:value-of select="$formattedString"/>
			</xsl:when>
			<xsl:when test="contains($formattedString, ',')">
				<xsl:choose>
					<xsl:when test="ends-with($formattedString, '0')">
						<xsl:sequence select="util:removeTrailingZeros(substring($formattedString, 1, string-length($formattedString) - 1))"/>
					</xsl:when>
					<xsl:when test="ends-with($formattedString, ',')">
						<xsl:value-of select="substring($formattedString, 1, string-length($formattedString) - 1)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$formattedString"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$formattedString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

	<!-- ========================================================= -->
	<!-- 1. Справочник отраслевых организаций по аббревиатуре       -->
	<!-- ========================================================= -->
	<xsl:function name="util:industry-full-name" as="xs:string">
		<xsl:param name="abbr" as="xs:string?"/>
		
		<xsl:choose>
			<xsl:when test="$abbr = 'РСС'">
				ПУБЛИЧНОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО "ФЕДЕРАЛЬНАЯ СЕТЕВАЯ КОМПАНИЯ – РОССЕТИ"
			</xsl:when>
			<xsl:when test="$abbr = 'АЛР'">
				АКЦИОНЕРНАЯ КОМПАНИЯ "АЛРОСА" (ПУБЛИЧНОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО)
			</xsl:when>
			<xsl:when test="$abbr = 'РЖД'">
				ОТКРЫТОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО "РОССИЙСКИЕ ЖЕЛЕЗНЫЕ ДОРОГИ"
			</xsl:when>
			<xsl:when test="$abbr = 'РСТ'">
				ГОСУДАРСТВЕННАЯ КОРПОРАЦИЯ ПО АТОМНОЙ ЭНЕРГИИ "РОСАТОМ"
			</xsl:when>
			<xsl:when test="$abbr = 'ТРН'">
				ПУБЛИЧНОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО "ТРАНСНЕФТЬ"
			</xsl:when>
			
			<!-- если аббревиатура не найдена — выводим её как есть -->
			<xsl:otherwise>
				<xsl:sequence select="$abbr"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	
	<xsl:strip-space elements="*"/>

    <xsl:decimal-format name="european" decimal-separator="," grouping-separator=" "/>


	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<style type="text/css" id="styles">
					/* Стили CSS остаются без изменений */
					h1 { font-family: Times New Roman; font-size: 12pt; font-weight:bold; text-align:center; width:100%; margin-top: 2em; }
					body,p,td { font-family: Times New Roman; font-size: 10pt; margin:0;}
					.fieldError { color: red; }
					td.fieldError { border: 1px solid red; }
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
					.wrapword {
						white-space: -moz-pre-wrap !important;  /* Mozilla, since 1999 */
						white-space: -webkit-pre-wrap;       /* Chrome  Safari */
						white-space: -pre-wrap;             /* Opera 4-6 */
						white-space: -o-pre-wrap;             /* Opera 7 */
						white-space: pre-wrap;             /* CSS3 */
						word-wrap: break-word;             /* Internet Explorer 5.5+ */
						word-break: break-all;
						white-space: normal;
					}
					.bold-text { font-weight: bold; }
					table {
						border-collapse: collapse; margin:2em 0;
						table-layout: fixed;
						width: 180em; /* Общая ширина таблицы осталась прежней */
					}
					th {
						font-weight: normal;
						font-size: 80%;
						border: 1px solid black;
						padding: 0.5em;
						vertical-align: middle;
						white-space: nowrap;
						line-height:1.1em;
						text-align:center;
					}
					.rotate {
						writing-mode: vertical-rl;
						text-orientation: mixed;
						text-align: center;
						vertical-align: middle;
						transform: rotateZ(180deg);
						font-size: 80%;
					}
					td {border: 1px solid black; padding: 0.2em 0.5em; vertical-align: top; text-align:left}
					td.noborder { border: none !important; }
					td.underline { border: none; border-bottom: 1px solid black; }
                    .section-header {
                        font-weight: bold; background-color: #eeeeee;
                        text-align: left; padding: 0.4em 0.5em;
                    }
                    .section-fsbc-header {
                        font-weight: bold; background-color: #ddeeff;
                        text-align: left; padding: 0.4em 0.5em;
                    }
				</style>
			</head>
			<body>
				<xsl:apply-templates select="MarketAnalysis" mode="render"/>
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
			<xsl:otherwise>неизв.квартал:<xsl:value-of select="$quarter"/> </xsl:otherwise>
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

	<xsl:template match="MarketAnalysis" mode="render">
		<table style="width: 100%; border-collapse: collapse; margin-top: 0.5em; border: none; table-layout: auto;"> <tr>
			<td style="text-align: left; font-family: Times New Roman; font-size: 10pt; border: none;">
				Дата и время выгрузки файла из сметного программного комплекса:
				<xsl:value-of select="concat(substring(ExportDateTime, 9, 2), '.', substring(ExportDateTime, 6, 2), '.', substring(ExportDateTime, 1, 4), ' ', substring(ExportDateTime, 12, 5))"/>
			</td>
		</tr>
		</table>
		<table style="width: 100%; border-collapse: collapse; table-layout: auto;">
			<tr>
				<td style="text-align: center; font-family: Times New Roman; font-size: 12pt; font-weight: bold; padding-top: 0.5em; padding-bottom: 1em; border: none;"> Сводная таблица результатов конъюнктурного анализа
				</td>
			</tr>
			
			<tr>
				<td class="underline" style="padding: 4px; text-align: center;">
					<xsl:value-of select="ObjectName"/>
				</td>
			</tr>
			
			<tr>
				<td style="text-align: center; font-family: Times New Roman; font-size: 10pt; border-top: 1px solid black; border-left: none; border-right: none; border-bottom: none; padding: 0.2em;">
					(наименование объекта капитального строительства)
				</td>
			</tr>
		</table>
		<table style="border-collapse: collapse; margin-left: auto; margin-right: 5%; width: auto; margin-top: 0.5em; table-layout: auto;"> <tr>
			<td class="noborder" style="text-align: right; padding: 4px; white-space: nowrap;">
				Уровень цен составления сметной документации
			</td>
			<td class="underline" style="padding: 4px; text-align: center;">
				<xsl:call-template name="get-quarter-name">
					<xsl:with-param name="quarter" select="PriceLevel/Quarter"/>
				</xsl:call-template>
				<xsl:value-of select="PriceLevel/Year"/> г.
			</td>
		</tr>
			<tr>
				<td class="noborder" style="text-align: right; padding: 4px; white-space: nowrap;">
					Наименование субъекта Российской Федерации
				</td>
				<td class="underline" style="padding: 4px; text-align: center;">
					<xsl:value-of select="Region/RegionName"/>
				</td>
			</tr>
			<tr>
				<td class="noborder" style="text-align: right; padding: 4px; white-space: nowrap;">
					Ценовая зона субъекта Российской Федерации
				</td>
				<td class="underline" style="padding: 4px; text-align: center;">
					<xsl:value-of select="Region/SubRegion/SubRegionCode"/>
				</td>
			</tr>
			<xsl:if test="normalize-space(Industry)">
				<tr>
					<td class="noborder"
						style="text-align: right; padding: 4px; white-space: nowrap;">
						Отраслевая организация
					</td>
					<td class="underline" style="padding: 4px; text-align: center;">
						<xsl:value-of select="util:industry-full-name(Industry)"/>
					</td>
				</tr>
			</xsl:if>
		</table>

		<table>
			<colgroup>
				<col style="width: 3em" />    
				<col style="width: 15em" />   
				<col style="width: 20em" />   
				<col style="width: 20em" />   
				<col style="width: 5em" />    
				<col style="width: 5em" />    
				<col style="width: 6em" />    
				<col style="width: 7em" />    
				<col style="width: 7em" />   
				<col style="width: 4.5em" />  
				<col style="width: 4.5em" />    
				<col style="width: 6em" />    
				<col style="width: 5em" />   
				<col style="width: 6em" />    
				<col style="width: 5em" />    
				<col style="width: 6em" />    
				<col style="width: 5em" />    
				<col style="width: 5em" />    
				<col style="width: 6em" />   
				<col style="width: 6em" />   
				<col style="width: 12em" />   
				<col style="width: 5em" />    
				<col style="width: 8em" />    
				<col style="width: 8em" />   
				<col style="width: 18em" />   
				<col style="width: 18em" />   
				<col style="width: 5em" />    
			</colgroup>
            <thead>
				<tr>
					<th class="rotate" rowspan="2">Номер по порядку</th> 
					<th class="rotate" rowspan="2">Код строительного ресурса</th> 
					<th class="rotate" rowspan="2">Наименование ресурса, затрат в соответствии с проектной документацией</th> 
					<th class="rotate" rowspan="2">Полное наименование ресурса,<br/> затрат в обосновывающем документе</th>
					<th class="rotate" rowspan="2">Единица измерения ресурса, затрат в соответствии с проектной документацией</th> 
					<th class="rotate" rowspan="2">Единица измерения ресурса, затрат в обосновывающем документе</th> 
					<th class="rotate" rowspan="2">Текущая отпускная цена за единицу измерения в<br/> обосновывающем документе с учетом НДС, рублей</th> 
					<th class="rotate" rowspan="2">Текущая отпускная цена за единицу измерения<br/>в обосновывающем документе без НДС, рублей /<br/>Сметная цена строительного ресурса в базисном или текущем уровне цен,<br/> размещенная в ФГИС ЦС, применяемая при РИМ, рублей</th> 
					<th class="rotate" rowspan="2">Месяц и год составления обосновывающего документа /<br/> Квартал (для сметных цен строительных ресурсов в текущем уровне цен <br/>и индексов по ГОСР, размещенных в ФГИС ЦС, применяемых при РИМ)</th> 
					<th class="rotate" rowspan="2">Индекс фактической инфляции / Индекс по ГОСР</th> 
					<th class="rotate" rowspan="2">Коэффициент пересчета в единицу измерения в соответствии с графой 5</th> 
					<th class="rotate" rowspan="2">Текущая отпускная цеена за единицу измерения без НДС, <br/> рублей в соответствии с графой 5 в уровне цен<br/> составления сметной документации</th> 
					<th class="rotate" style="white-space: wrap;" colspan="2">Затраты на перевозку</th> 
					<th class="rotate" style="white-space: wrap;" colspan="2">Заготовительно-<br/>складские расходы</th> 
					<th class="rotate" style="white-space: nowrap;" colspan="3">Дополнительные затраты, предусмотренные пунктами<br/> 88, 117, 119–121 Методики </th> 
					<th class="rotate" rowspan="2">Сметная цена без НДС, рублей за единицу измерения в соответствии с графой 5</th> 
					<th class="rotate" rowspan="2">Полное и (или) сокращенное (при наличии) наименования производителя (поставщика)</th> 
					<th class="rotate" rowspan="2">Страна производителя оборудования, производственного<br/> и хозяйственного инвентаря</th> 
					<th class="rotate" rowspan="2">КПП организации</th> <th class="rotate" rowspan="2">ИНН организации</th> 
					<th class="rotate" rowspan="2">Гиперссылка на веб-сайт производителя/поставщика</th> 
					<th class="rotate" rowspan="2">Населенный пункт расположения склада производителя (поставщика)</th> 
					<th class="rotate" rowspan="2">Статус организации (Производитель(1); Поставщик (2)</th> </tr>
				<tr>
					<th>%</th> <th class="rotate" > рублей за единицу измерения<br/>в соответствии с графой 5 без учета НДС</th> 
					<th>%</th> 
					<th>руб.</th> 
					<th class="rotate">Наименование затрат</th> 
					<th>%</th> 
					<th>руб.</th> 
				</tr>
				<tr>
					<th style="font-size:80%;">1</th> <th style="font-size:80%;">2</th> <th style="font-size:80%;">3</th>
					<th style="font-size:80%;">4</th> <th style="font-size:80%;">5</th> <th style="font-size:80%;">6</th>
					<th style="font-size:80%;">7</th> <th style="font-size:80%;">8</th> <th style="font-size:80%;">9</th>
					<th style="font-size:80%;">10</th> <th style="font-size:80%;">11</th> <th style="font-size:80%;">12</th>
					<th style="font-size:80%;">13</th> <th style="font-size:80%;">14</th> <th style="font-size:80%;">15</th>
					<th style="font-size:80%;">16</th> <th style="font-size:80%;">17</th> <th style="font-size:80%;">18</th>
					<th style="font-size:80%;">19</th> <th style="font-size:80%;">20</th> <th style="font-size:80%;">21</th>
					<th style="font-size:80%;">22</th> <th style="font-size:80%;">23</th> <th style="font-size:80%;">24</th>
					<th style="font-size:80%;">25</th> <th style="font-size:80%;">26</th> <th style="font-size:80%;">27</th>
				</tr>
			</thead>

			<xsl:apply-templates select="Sections/*"/>

		</table>

		<table style="border-collapse: collapse; width: 100%; table-layout: auto; margin-top: 2em; border: none;">
            <tr>
				<td colspan="5" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;">Составил:</td>
				<td colspan="2" style="border: none;"></td>
				<td colspan="2" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;"></td>
				<td style="border: none;"></td>
				<td colspan="5" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;"><xsl:value-of select="Signatures/Composer/Position"/> <xsl:value-of select="Signatures/Composer/Name"/></td>
				<td colspan="11" style="border: none;"></td>
			</tr>
			<tr>
				<td colspan="5" style="border: none;">Наименование должности</td>
				<td colspan="2" style="border: none;"></td>
				<td colspan="2" style="border: none;">(подпись)</td>
				<td style="border: none;"></td>
				<td colspan="5" style="border: none;">(фамилия, имя, отчество (при наличии))</td>
				<td colspan="11" style="border: none;"></td>
			</tr>
			<tr>
				<td colspan="27" style="border: none; height: 1em;"> </td>
			</tr>
			<tr>
				<td colspan="5" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;">Проверил:</td>
				<td colspan="2" style="border: none;"></td>
				<td colspan="2" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;"></td>
				<td style="border: none;"></td>
				<td colspan="5" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;"><xsl:value-of select="Signatures/Verifier/Position"/> <xsl:value-of select="Signatures/Verifier/Name"/></td>
				<td colspan="11" style="border: none;"></td>
			</tr>
			<tr>
				<td colspan="5" style="border: none;">Наименование должности</td>
				<td colspan="2" style="border: none;"></td>
				<td colspan="2" style="border: none;">(подпись)</td>
				<td style="border: none;"></td>
				<td colspan="5" style="border: none;">(фамилия, имя, отчество (при наличии))</td>
				<td colspan="11" style="border: none;"></td>
			</tr>

			<tr>
				<td colspan="27" style="border: none; height: 1em;"> </td>
			</tr>
			<tr>
				<td colspan="5" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;">Застройщик (Технический заказчик):</td>
				<td colspan="2" style="border: none;"></td>
				<td colspan="2" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;"></td>
				<td style="border: none;"></td>
				<td colspan="5" style="border-bottom: 1px solid black; border-top: none; border-left: none; border-right: none;"><xsl:value-of select="Signatures/Developer/Position"/> <xsl:value-of select="Signatures/Developer/Name"/></td>
				<td colspan="11" style="border: none;"></td>
			</tr>
			<tr>
				<td colspan="5" style="border: none;">Наименование должности</td>
				<td colspan="2" style="border: none;"></td>
				<td colspan="2" style="border: none;">(подпись)</td>
				<td style="border: none;"></td>
				<td colspan="5" style="border: none;">(фамилия, имя, отчество (при наличии))</td>
				<td colspan="11" style="border: none;"></td>
			</tr>
		</table>

	</xsl:template>

	<xsl:template match="Item">
		<xsl:if test="FreeString">
			<tr><td colspan="27" class="left bold-text"><xsl:value-of select="FreeString"/></td></tr>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="Offer[Winner=true()]">
				<xsl:for-each select="Offer[Winner=true()]">
					<tr>
						<td class="center bold-text"><xsl:value-of select="ancestor::Item[1]/Num"/>.<xsl:value-of select="OfferNum"/></td>
						<td class="wrapword bold-text"><xsl:call-template name="generate-offer-code"/></td>
						<td class="wrapword bold-text"><xsl:value-of select="ancestor::Item[1]/Name"/></td>
						<td class="wrapword bold-text">
							<xsl:value-of select="OfferName"/>
							<br/>
							Цена: <xsl:value-of select="util:format-numbers-in-formula(OfferPrice/OfferUnitFormula)"/>
						</td>
						<td class="center bold-text"><xsl:value-of select="ancestor::Item[1]/Unit"/></td>
						<td class="center bold-text"><xsl:value-of select="OfferUnit"/></td>
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithVAT, 2)'/></td>
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithoutVAT, 2)'/></td>
						<td class="center bold-text">
							<xsl:if test="OfferDate/Date">
								<xsl:variable name="month" select="substring(OfferDate/Date, 6, 2)"/>
								<xsl:variable name="year" select="substring(OfferDate/Date, 1, 4)"/>
								<xsl:value-of select="util:get-month-name($month)"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$year"/>
							</xsl:if>
							
						</td>
						
						<td class="right bold-text">
							<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/DeflationCoefficient, 4)"/>
							<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
						</td>
						
						<td class="right bold-text">
							<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/ConversionFactor, 2)"/>
							<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
						</td>
						
						
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferUnitWithoutVAT, 2)'/></td>
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Percent, 2)'/></td>
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Price, 2)'/></td>
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Percent, 2)'/></td>
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Price, 2)'/></td>
						<td class="left bold-text"></td> <td class="right bold-text"></td>
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(ExpensesTotal, 2)'/></td>
						<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/EstimateWithoutVAT, 2)'/></td>
						<td class="left wrapword bold-text"><xsl:value-of select="OfferCompany/CompanyName"/></td>
						<td class="left wrapword bold-text"><xsl:value-of select="OriginCountry"/></td>
						<td class="center bold-text"><xsl:value-of select="OfferCompany/KPP"/></td>
						<td class="center bold-text"><xsl:value-of select="OfferCompany/INN"/></td>
						<td class="left wrapword bold-text">
							<xsl:call-template name="render-link">
								<xsl:with-param name="url" select="OfferCompany/Site"/>
								
							</xsl:call-template>
							<xsl:if test="normalize-space(OfferCompany/Email)">
								<br/> <a href="mailto:{OfferCompany/Email}"> <xsl:value-of select="OfferCompany/Email"/> </a>
							</xsl:if>
						</td>
						<td class="left wrapword bold-text"><xsl:value-of select="OfferCompany/StorePlace"/></td>
						<td class="center bold-text"><xsl:value-of select="OfferCompany/Status"/></td>
					</tr>
					<xsl:apply-templates select="Expenses/Expense"/>
				</xsl:for-each>
				<xsl:for-each select="Offer[not(Winner=true())]">
					<tr>
						<td class="center"><xsl:value-of select="ancestor::Item[1]/Num"/>.<xsl:value-of select="OfferNum"/></td>
						<td class="wrapword"><xsl:call-template name="generate-offer-code"/></td>
						<td class="wrapword"><xsl:value-of select="ancestor::Item[1]/Name"/></td>
						<td class="wrapword">
							<xsl:value-of select="OfferName"/>
							<br/>
							Цена: <xsl:value-of select="util:format-numbers-in-formula(OfferPrice/OfferUnitFormula)"/>
						</td>
						<td class="center"><xsl:value-of select="ancestor::Item[1]/Unit"/></td>
						<td class="center"><xsl:value-of select="OfferUnit"/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithVAT, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithoutVAT, 2)'/></td>
						<td class="center">
							<xsl:if test="OfferDate/Date">
								<xsl:variable name="month" select="substring(OfferDate/Date, 6, 2)"/>
								<xsl:variable name="year" select="substring(OfferDate/Date, 1, 4)"/>
								<xsl:value-of select="util:get-month-name($month)"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="$year"/>
							</xsl:if>
							
                        </td>
						<td class="right">
							<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/DeflationCoefficient, 4)"/>
							<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
						</td>
						
						<td class="right">
							<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/ConversionFactor, 2)"/>
							<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
						</td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferUnitWithoutVAT, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Percent, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Price, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Percent, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Price, 2)'/></td>
						<td class="left"></td> <td class="right"></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(ExpensesTotal, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/EstimateWithoutVAT, 2)'/></td>
						<td class="left wrapword"><xsl:value-of select="OfferCompany/CompanyName"/></td>
						<td class="left wrapword"><xsl:value-of select="OriginCountry"/></td>
						<td class="center"><xsl:value-of select="OfferCompany/KPP"/></td>
						<td class="center"><xsl:value-of select="OfferCompany/INN"/></td>
						<td class="left wrapword">
							<xsl:call-template name="render-link">
								<xsl:with-param name="url" select="OfferCompany/Site"/>
								
							</xsl:call-template>
							<xsl:if test="normalize-space(OfferCompany/Email)">
								<br/> <a href="mailto:{OfferCompany/Email}"> <xsl:value-of select="OfferCompany/Email"/> </a>
							</xsl:if>
                        </td>
						<td class="left wrapword"><xsl:value-of select="OfferCompany/StorePlace"/></td>
						<td class="center"><xsl:value-of select="OfferCompany/Status"/></td>
					</tr>
					<xsl:apply-templates select="Expenses/Expense"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="Offer">
                    <tr>
                    	<td class="center"><xsl:value-of select="ancestor::Item[1]/Num"/>.<xsl:value-of select="OfferNum"/></td>
						<td class="wrapword"><xsl:call-template name="generate-offer-code"/></td>
						<td class="wrapword"><xsl:value-of select="ancestor::Item[1]/Name"/></td>
                    					<td class="wrapword">
                    						<xsl:value-of select="OfferName"/>
                    						<br/>
                    					Цена: <xsl:value-of select="util:format-numbers-in-formula(OfferPrice/OfferUnitFormula)"/>
                    					</td>
						<td class="center"><xsl:value-of select="ancestor::Item[1]/Unit"/></td>
						<td class="center"><xsl:value-of select="OfferUnit"/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithVAT, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithoutVAT, 2)'/></td>
						<td class="center">
							<xsl:if test="OfferDate/Date">
								<xsl:value-of select="concat(substring(OfferDate/Date, 9, 2), '.', substring(OfferDate/Date, 6, 2), '.', substring(OfferDate/Date, 1, 4))"/>
							</xsl:if>
                        </td>
                    	<td class="right ">
                    		<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/DeflationCoefficient, 4)"/>
                    		<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
                    	</td>
                    	
                    	<td class="right ">
                    		<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/ConversionFactor, 2)"/>
                    		<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
                    	</td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferUnitWithoutVAT, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Percent, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Price, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Percent, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Price, 2)'/></td>
						<td class="left"></td> <td class="right"></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(ExpensesTotal, 2)'/></td>
						<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/EstimateWithoutVAT, 2)'/></td>
						<td class="left wrapword"><xsl:value-of select="OfferCompany/CompanyName"/></td>
						<td class="left wrapword"><xsl:value-of select="OriginCountry"/></td>
						<td class="center"><xsl:value-of select="OfferCompany/KPP"/></td>
						<td class="center"><xsl:value-of select="OfferCompany/INN"/></td>
						<td class="left wrapword">
                            <xsl:call-template name="render-link">
								<xsl:with-param name="url" select="OfferCompany/Site"/>
							</xsl:call-template>
							<xsl:if test="normalize-space(OfferCompany/Email)">
								<br/> <a href="mailto:{OfferCompany/Email}"> <xsl:value-of select="OfferCompany/Email"/> </a>
							</xsl:if>
                        </td>
						<td class="left wrapword"><xsl:value-of select="OfferCompany/StorePlace"/></td>
						<td class="center"><xsl:value-of select="OfferCompany/Status"/></td>
                    </tr>
					
					
					
					
					<xsl:apply-templates select="Expenses/Expense"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	
		<xsl:variable name="clientLetterTitle" select="normalize-space(ClientLetter/Title)"/>
		<xsl:variable name="clientLetterFileName" select="normalize-space(ClientLetter/FileName)"/>
		
		<xsl:if test="ClientLetter and ($clientLetterTitle != '' or $clientLetterFileName != '')">
			<tr>
				<td colspan="2">
					<xsl:if test="$clientLetterTitle != ''">
						Письмо заказчика: <xsl:value-of select="$clientLetterTitle"/>
					</xsl:if>
				</td>
				<td colspan="25">
					<xsl:if test="$clientLetterFileName != ''">
						Файл:&#160; <a href="{ClientLetter/FileName}" target="_blank">
							<xsl:value-of select="ClientLetter/FileName"/> </a>
					</xsl:if>
				</td>
			</tr>
		</xsl:if>
	
	</xsl:template>

    <xsl:template match="Expense">
        <tr>
            <td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
            <td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
            <td class="left wrapword"> <xsl:choose>
                    <xsl:when test="OfferLinkFile"> <a href="{OfferLinkFile}" target="_blank"><xsl:value-of select="ExpenseType"/></a></xsl:when>
                    <xsl:otherwise><xsl:value-of select="ExpenseType"/></xsl:otherwise>
                 </xsl:choose>
            </td>
            <td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(ExpensePercent, 2)'/></td> <td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(ExpensePrice, 2)'/></td> <td></td> <td class="left wrapword"><xsl:value-of select="ExpenseCompany/Name"/></td> <td></td> <td class="center"><xsl:value-of select="ExpenseCompany/KPP"/></td> <td class="center"><xsl:value-of select="ExpenseCompany/INN"/></td> 
        	<td class="left wrapword"> 
        		<xsl:call-template name="render-link">
        			<xsl:with-param name="url" select="ExpenseCompany/Site"/>
        		</xsl:call-template>
        		<xsl:if test="normalize-space(ExpenseCompany/Email)">
        			<br/> <a href="mailto:{ExpenseCompany/Email}"> <xsl:value-of select="ExpenseCompany/Email"/> </a>
        		</xsl:if>
            </td>
            <td class="left wrapword"><xsl:value-of select="ExpenseCompany/StorePlace"/></td> <td class="center"><xsl:value-of select="ExpenseCompany/Status"/></td> </tr>
    </xsl:template>

	<xsl:template match="Section">
		<tr><td colspan="27" class="section-header">Раздел <xsl:value-of select="Code"/>. <xsl:value-of select="Name"/></td></tr>
		<xsl:apply-templates select="Items/*"/>
	</xsl:template>

    <xsl:template match="SectionFSBC">
		<tr><td colspan="27" class="section-fsbc-header">Раздел <xsl:value-of select="Code"/>. <xsl:value-of select="Name"/> (Данные ФГИС ЦС)</td></tr>
		<xsl:apply-templates select="Items/*"/>
	</xsl:template>

    <xsl:template match="ItemFSBC">
    	<xsl:if test="FreeString">
    		<tr><td colspan="27" class="left bold-text"><xsl:value-of select="FreeString"/></td></tr>
    	</xsl:if>
    	<xsl:choose>
    		<xsl:when test="Offer[Winner=true()]">
    			<xsl:for-each select="Offer[Winner=true()]">
    				<tr>
    					<td class="center bold-text"><xsl:value-of select="ancestor::Item[1]/Num"/>.<xsl:value-of select="position()"/></td>
    					<td class="wrapword bold-text"><xsl:call-template name="generate-offer-code"/></td>
    					<td class="wrapword bold-text"><xsl:value-of select="ancestor::Item[1]/Name"/></td>
    					<td class="wrapword bold-text">
    						<xsl:value-of select="OfferName"/>
    						<br/>
    						Цена: <xsl:value-of select="util:format-numbers-in-formula(OfferPrice/OfferUnitFormula)"/>
    					</td>
    					<td class="center bold-text"><xsl:value-of select="ancestor::Item[1]/Unit"/></td>
    					<td class="center bold-text"><xsl:value-of select="OfferUnit"/></td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithVAT, 2)'/></td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithoutVAT, 2)'/></td>
    					<td class="center bold-text">
    						<xsl:if test="OfferDate/Date">
    							<xsl:value-of select="concat(substring(OfferDate/Date, 9, 2), '.', substring(OfferDate/Date, 6, 2), '.', substring(OfferDate/Date, 1, 4))"/>
    						</xsl:if>
    					</td>
    					<td class="right bold-text">
    						<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/DeflationCoefficient, 4)"/>
    						<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
    					</td>
    					
    					<td class="right bold-text">
    						<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/ConversionFactor, 2)"/>
    						<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
    					</td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferUnitWithoutVAT, 2)'/></td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Percent, 2)'/></td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Price, 2)'/></td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Percent, 2)'/></td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Price, 2)'/></td>
    					<td class="left bold-text"></td> <td class="right bold-text"></td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(ExpensesTotal, 2)'/></td>
    					<td class="right bold-text"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/EstimateWithoutVAT, 2)'/></td>
    					<td class="left wrapword bold-text"><xsl:value-of select="OfferCompany/CompanyName"/></td>
    					<td class="left wrapword bold-text"><xsl:value-of select="OriginCountry"/></td>
    					<td class="center bold-text"><xsl:value-of select="OfferCompany/KPP"/></td>
    					<td class="center bold-text"><xsl:value-of select="OfferCompany/INN"/></td>
    					<td class="left wrapword bold-text">
    						<xsl:call-template name="render-link">
    							<xsl:with-param name="url" select="OfferCompany/Site"/>
    						</xsl:call-template>
    						<xsl:if test="normalize-space(OfferCompany/Email)">
    							<br/> <a href="mailto:{OfferCompany/Email}"> <xsl:value-of select="OfferCompany/Email"/> </a>
    						</xsl:if>
    					</td>
    					<td class="left wrapword bold-text"><xsl:value-of select="OfferCompany/StorePlace"/></td>
    					<td class="center bold-text"><xsl:value-of select="OfferCompany/Status"/></td>
    				</tr>
    				<xsl:apply-templates select="Expenses/Expense"/>
    			</xsl:for-each>
    			<xsl:for-each select="Offer[not(Winner=true())]">
    				<tr>
    					<td class="center"><xsl:value-of select="ancestor::ItemFSBC[1]/Num"/>.<xsl:value-of select="count(preceding-sibling::Offer) + count(ancestor::ItemFSBC[1]/Offer[Winner=true()]) + 1"/></td>
    					<td class="wrapword"><xsl:call-template name="generate-offer-code"/></td>
    					<td class="wrapword"><xsl:value-of select="ancestor::ItemFSBC[1]/Name"/></td>
    					<td class="wrapword">
    						<xsl:value-of select="OfferName"/>
    						<br/>
    						Цена: <xsl:value-of select="util:format-numbers-in-formula(OfferPrice/OfferUnitFormula)"/>
    					</td>
    					<td class="center"><xsl:value-of select="ancestor::ItemFSBC[1]/Unit"/></td>
    					<td class="center"><xsl:value-of select="OfferUnit"/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithVAT, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithoutVAT, 2)'/></td>
    					
    					<td class="center"> <xsl:variable name="priceLevel" select="/MarketAnalysis/PriceLevel"/>
    						<xsl:value-of select="$priceLevel/Day"/>.<xsl:value-of select="$priceLevel/Month"/>.<xsl:value-of select="$priceLevel/Year"/>
    					</td>
    					
    					<td class="right ">
    						<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/DeflationCoefficient, 4)"/>
    						<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
    					</td>
    					
    					<td class="right ">
    						<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/ConversionFactor, 2)"/>
    						<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
    					</td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferUnitWithoutVAT, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Percent, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Price, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Percent, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Price, 2)'/></td>
    					<td class="left"></td> <td class="right"></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(ExpensesTotal, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/EstimateWithoutVAT, 2)'/></td>
    					<td class="left wrapword"><xsl:value-of select="OfferCompany/CompanyName"/></td>
    					<td class="left wrapword"><xsl:value-of select="OriginCountry"/></td>
    					<td class="center"><xsl:value-of select="OfferCompany/KPP"/></td>
    					<td class="center"><xsl:value-of select="OfferCompany/INN"/></td>
    					<td class="left wrapword">
    						<xsl:call-template name="render-link">
    							<xsl:with-param name="url" select="OfferCompany/Site"/>
    						</xsl:call-template>
    						<xsl:if test="normalize-space(OfferCompany/Email)">
    							<br/> <a href="mailto:{OfferCompany/Email}"> <xsl:value-of select="OfferCompany/Email"/> </a>
    						</xsl:if>
    					</td>
    					<td class="left wrapword"><xsl:value-of select="OfferCompany/StorePlace"/></td>
    					<td class="center"><xsl:value-of select="OfferCompany/Status"/></td>
    				</tr>
    				<xsl:apply-templates select="Expenses/Expense"/>
    			</xsl:for-each>
    		</xsl:when>
    		<xsl:otherwise>
    			<xsl:for-each select="Offer">
    				<tr>
    					<td class="center"><xsl:value-of select="ancestor::ItemFSBC[1]/Num"/>.<xsl:value-of select="position()"/></td>
    					<td class="wrapword"><xsl:call-template name="generate-offer-code"/></td>
    					<td class="wrapword"><xsl:value-of select="ancestor::ItemFSBC[1]/Name"/></td>
    					<td class="wrapword">
    						<xsl:value-of select="OfferName"/>
    						<br/>
    						Цена: <xsl:value-of select="util:format-numbers-in-formula(OfferPrice/OfferUnitFormula)"/>
    					</td>
    					<td class="center"><xsl:value-of select="ancestor::ItemFSBC[1]/Unit"/></td>
    					<td class="center"><xsl:value-of select="OfferUnit"/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithVAT, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferWithoutVAT, 2)'/></td>
    					
    					<td class="center"> <xsl:variable name="priceLevel" select="/MarketAnalysis/PriceLevel"/>
    						<xsl:value-of select="concat($priceLevel/Quarter, ' Квартал ', $priceLevel/Year, ' год')"/>
    					</td>
    					
    					<td class="right ">
    						<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/DeflationCoefficient, 4)"/>
    						<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
    					</td>
    					
    					<td class="right ">
    						<xsl:variable name="priceFormatted" select="util:formatNumberWithZeroCheck(OfferPrice/ConversionFactor, 2)"/>
    						<xsl:value-of select="util:removeTrailingZeros($priceFormatted)"/>
    					</td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/OfferUnitWithoutVAT, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Percent, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Transportation/Price, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Percent, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(Storage/Price, 2)'/></td>
    					<td class="left"></td> <td class="right"></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(ExpensesTotal, 2)'/></td>
    					<td class="right"><xsl:value-of select='util:formatNumberWithZeroCheck(OfferPrice/EstimateWithoutVAT, 2)'/></td>
    					<td class="left wrapword"><xsl:value-of select="OfferCompany/CompanyName"/></td>
    					<td class="left wrapword"><xsl:value-of select="OriginCountry"/></td>
    					<td class="center"><xsl:value-of select="OfferCompany/KPP"/></td>
    					<td class="center"><xsl:value-of select="OfferCompany/INN"/></td>
    					<td class="left wrapword">
    						<xsl:call-template name="render-link">
    							<xsl:with-param name="url" select="OfferCompany/Site"/>
    						</xsl:call-template>
    						<xsl:if test="normalize-space(OfferCompany/Email)">
    							<br/> <a href="mailto:{OfferCompany/Email}"> <xsl:value-of select="OfferCompany/Email"/> </a>
    						</xsl:if>
    					</td>
    					<td class="left wrapword"><xsl:value-of select="OfferCompany/StorePlace"/></td>
    					<td class="center"><xsl:value-of select="OfferCompany/Status"/></td>
    				</tr>
    				<xsl:apply-templates select="Expenses/Expense"/>
    			</xsl:for-each>
    		</xsl:otherwise>
    	</xsl:choose>
   
    	<xsl:if test="ClientLetter[normalize-space(Title) or normalize-space(FileName)]">
    		<tr>
    			<td colspan="2">
    				<xsl:if test="normalize-space(ClientLetter/Title)">
    					Письмо заказчика: <xsl:value-of select="ClientLetter/Title"/>
    				</xsl:if>
    			</td>
    			<td colspan="25">
    				<xsl:if test="normalize-space(ClientLetter/FileName)">
    					Файл:&#160; <a href="{ClientLetter/FileName}" target="_blank">
    						<xsl:value-of select="ClientLetter/FileName"/>
    					</a>
    				</xsl:if>
    			</td>
    		</tr>
    	</xsl:if>
    
    </xsl:template>

    <xsl:template match="FreeString">
        <tr><td colspan="27" class="left italic"><xsl:value-of select="."/></td></tr>
    </xsl:template>
    <xsl:template match="ClientLetter">
         <tr>
             <td colspan="27" class="left italic" style="background-color: #fff8dc;">
                 Письмо заказчика: <xsl:value-of select="."/>
                 <xsl:if test="@filePath">(<a href="{@filePath}" target="_blank">открыть файл</a>)</xsl:if>
            </td>
         </tr>
    </xsl:template>

    <xsl:template name="generate-offer-code">
        <xsl:variable name="offer" select="."/>
		<xsl:variable name="item" select="ancestor::Item[1]"/>
		<xsl:variable name="company" select="$offer/OfferCompany"/>
		<xsl:variable name="offerDate" select="$offer/OfferDate/Date"/>
		<xsl:variable name="transportPriceExists" select="exists($offer/Transportation/Price) and number(translate(string($offer/Transportation/Price),',','.')) != 0"/>
		<xsl:choose>
			<xsl:when test="$offer/OfferCode"><xsl:value-of select="$offer/OfferCode"/></xsl:when>
			<xsl:when test="$item and $company/INN and $offerDate">
				<xsl:text>ТЦ_</xsl:text><xsl:value-of select="$item/Code"/><xsl:text>_</xsl:text>
				<xsl:value-of select="substring($company/KPP, 1, 2)"/><xsl:text>_</xsl:text>
				<xsl:value-of select="$company/INN"/><xsl:text>_</xsl:text>
				<xsl:value-of select="substring($offerDate, 9, 2)"/>.<xsl:value-of select="substring($offerDate, 6, 2)"/>.<xsl:value-of select="substring($offerDate, 1, 4)"/>
				<xsl:text>_</xsl:text>
				<xsl:choose><xsl:when test="$transportPriceExists">02</xsl:when><xsl:otherwise>01</xsl:otherwise></xsl:choose>
			</xsl:when>
            <xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    <xsl:template name="render-link">
        <xsl:param name="url"/><xsl:param name="maxLength" select="40"/>
		<xsl:choose>
			<xsl:when test="$url and normalize-space($url) != ''">
                <xsl:variable name="normalizedUrl" select="normalize-space($url)"/>
				<a href="{$normalizedUrl}" target="_blank">
					<xsl:value-of select="substring($normalizedUrl, 1, $maxLength)"/>
					<xsl:if test="string-length($normalizedUrl) > $maxLength">&#8230;</xsl:if>
				</a>
			</xsl:when>
			<xsl:otherwise><xsl:text/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
