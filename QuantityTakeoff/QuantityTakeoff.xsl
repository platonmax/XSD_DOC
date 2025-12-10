<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>

	<!-- Главный шаблон и описание стилей CSS -->
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<style type="text/css" id="styles"> 
                    h1 { font-family: Times New Roman; font-size: 14pt; font-weight:bold; text-align:center; width:100%; margin-top: 2em; }
                    body,p,td { font-family: Times New Roman; font-size: 10pt; margin:0;}
                    
                    div.heading-left2 { margin-left:1.7em; display:flex; width:30%; margin-top: 0.5em; min-height: 1em;}
                    div.heading-left2 .headingvalue { border-bottom: 1px solid black; flex: 1; }

					div.heading-left3 { margin-left:1.7em; display:flex; width:50%; margin-top: 0.5em; min-height: 1em;}
                    div.heading-left3 .headingvalue { border-bottom: 1px solid black; flex: 1; }
                    
                    div.helptext { text-align:center; width:100%; margin-top:0;}
                    div.helptext-left{ text-align:left; width:100%; margin-top:0;}
                    
                    
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
					.bold {
					font-weight: bold;
					}
					.inline {display: inline; }
					.breakword {word-wrap: break-word; }
					.indent {padding-left: 2em;}
					.indent2 {padding-left: 4em;}
					.indent3 {padding-left: 6em;}
					
                    .err { color:red; text-decoration: underline }
                    .err A { color:red; text-decoration: underline }
                    
                    table {border-collapse: collapse; width:100%; margin:2em 0; }
                    th {border: 1px solid black; padding: 0.5em; vertical-align: top;}
					td {border: 0px; padding: 0.2em 0.5em; vertical-align: top; text-align:right}
					td.tborder {border: 1px solid black}
					td.btop {border-top: 1px solid black}
					
					
					td.btop, td.bbottom {
					border-top: 1px solid black;
					border-bottom: 1px solid black;
					}
					
					.nowrap {
					white-space: nowrap;
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

			<div class="heading-left2 nowrap">
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
			


			<div class="heading">
				<div class="headingvalue center">
					<xsl:value-of select="ConstructionSite"/>
				</div>
			</div>
			<div class="helptext">(наименование стройки)</div>

			<div class="heading">
				<div class="headingvalue center">
					<xsl:value-of select="ObjectName"/>
				</div>
			</div>
			<div class="helptext">(наименование объекта капитального строительства)</div>

			<h1 id="EstimateNum">Ведомость объемов работ № <xsl:value-of
					select="Num"/></h1>

			<div class="heading">
				<div class="headingvalue left" >Основание:  <xsl:value-of select="Reason"/></div>
			</div>
			
				<div class="helptext">(наименование раздела (подраздела) проектной документации)</div>
			
			
			<div class="heading">
				<div class="headingname">Дата составления: <xsl:value-of select="Date/Day"/>.<xsl:value-of select="Date/Month"/>.<xsl:value-of select="Date/Year"/></div>
			</div>

			<xsl:apply-templates select="./Sections"/>
		</div>
		
		
	</xsl:template>

	<!-- Объект -->
	<xsl:template match="Sections">
		<table>
			<thead>
				<tr>
					<th >№ п.п.</th>
					<th >Наименование работ, ресурсов, затрат по проекту</th>
					<th >Ед. изм.</th>
					<th >Объем работ / Количество</th>
					<th >Формула расчета объемов работ и расхода материалов, потребности ресурсов</th>
					<th >Ссылка на чертежи, спецификации в проектной документации</th>
					<th >Дополнительная информация (комментарий).</th>
				</tr>
				
				<tr>
					<td class="tborder center">1</td>
					<td class="tborder center">2</td>
					<td class="tborder center">3</td>
					<td class="tborder center">4</td>
					<td class="tborder center">5</td>
					<td class="tborder center">6</td>
					<td class="tborder center">7</td>
					
				</tr>
			</thead>
			
			<xsl:apply-templates select="Section">
				<xsl:with-param name="num_prefix" select="''"/>
			</xsl:apply-templates>	
			
			<tr>
				<td  colspan="7">&#160;</td>
			</tr>
			<tr> <td  colspan="7">&#160;</td></tr>
			<tr>
				<td class= " left " colspan="7">Составил: <xsl:value-of select="/Construction/Signatures/Composer/Position"/>.  <xsl:value-of select="/Construction/Signatures/Composer//Name"/>_________________________</td>
			</tr>	
			<tr>
				<td class = "left italic" colspan="7">[должность, подпись (инициалы, фамилия)]</td>
			</tr>
			<tr>
				<td class= " left " colspan="7">Проверил: <xsl:value-of select="/Construction/Signatures/Verifier/Position"/>.  <xsl:value-of select="/Construction/Signatures/Verifier//Name"/>_________________________</td>
			</tr>
			<tr>
				<td class = "left italic" colspan="7">[должность, подпись (инициалы, фамилия)]</td>
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
		
		<tr>
			<td class="bbottom left bold" colspan="7">
				<xsl:if test="ancestor::Section">
					<span class="indent"/>
				</xsl:if>
				Раздел: <xsl:value-of select="$current_num"/>. <xsl:value-of select="./Name"/>
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
			<td class= "center"><xsl:value-of select="Num"/></td>
			<td class= "left"><xsl:value-of select="Name"/></td>
			<td class= "center"><xsl:value-of select="Unit"/></td>
			<td><xsl:value-of select="Quantity"/></td>
			<td class= "left"><xsl:value-of select="QuantityFormula"/></td>
			<td class= "left">
				<xsl:for-each select="Links/Link">
					<xsl:variable name="fileName">
						<xsl:for-each select="/Construction/Files/File[ID = current()/FileID]">
							<xsl:value-of select="FileName"/>
						</xsl:for-each>
					</xsl:variable>
					Файл: <xsl:value-of select="$fileName"/> <br/>
					<xsl:if test="PageNumber">
						Страница: <xsl:value-of select="translate(PageNumber, ' ', ', ')"/> <br/>
					</xsl:if>	
					<xsl:value-of select="PageDescription"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not(Links/Link)">
					Нет данных
				</xsl:if>
			</td>
			<td class= "left"><xsl:value-of select="Comment"/></td>
		</tr>
		<xsl:apply-templates select="Resources/Resource"/>
	</xsl:template>
	
	<!-- Ресурс внутри работы -->
	<xsl:template match="Work/Resources/Resource">
		<tr>
			<td class= "center"><xsl:value-of select="../../Num"/>.<xsl:value-of select="Num"/></td>
			<td class= "left"><xsl:value-of select="Name"/></td>
			<td class= "center"><xsl:value-of select="Unit"/></td>
			<td><xsl:value-of select="Quantity"/></td>
			<td class= "left"><xsl:value-of select="QuantityFormula"/></td>
			<td class= "left">
				<xsl:for-each select="Links/Link">
					<xsl:variable name="fileName">
						<xsl:for-each select="/Construction/Files/File[ID = current()/FileID]">
							<xsl:value-of select="FileName"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="$fileName">
						Файл: <xsl:value-of select="$fileName"/> <br/>
					</xsl:if>
					<xsl:if test="PageNumber">
						Страница: <xsl:value-of select="translate(PageNumber, ' ', ', ')"/> <br/>
					</xsl:if>
					<xsl:value-of select="PageDescription"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not(Links/Link)">
					Нет данных
				</xsl:if>
			</td>
			<td class= "left"><xsl:value-of select="Comment"/></td>
		</tr>
	</xsl:template>
	
	<!-- Свободный ресурс на уровне Works (без родительского Work) -->
	<xsl:template match="Works/Resource">
		<tr>
			<td class= "center"><xsl:value-of select="Num"/></td>
			<td class= "left"><xsl:value-of select="Name"/></td>
			<td class= "center"><xsl:value-of select="Unit"/></td>
			<td><xsl:value-of select="Quantity"/></td>
			<td class= "left"><xsl:value-of select="QuantityFormula"/></td>
			<td class= "left">
				<xsl:for-each select="Links/Link">
					<xsl:variable name="fileName">
						<xsl:for-each select="/Construction/Files/File[ID = current()/FileID]">
							<xsl:value-of select="FileName"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="$fileName">
						Файл: <xsl:value-of select="$fileName"/> <br/>
					</xsl:if>
					<xsl:if test="PageNumber">
						Страница: <xsl:value-of select="translate(PageNumber, ' ', ', ')"/> <br/>
					</xsl:if>
					<xsl:value-of select="PageDescription"/>
					<xsl:if test="position() != last()">
						<br/>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not(Links/Link)">
					Нет данных
				</xsl:if>
			</td>
			<td class= "left"><xsl:value-of select="Comment"/></td>
		</tr>
	</xsl:template>
	
	<!-- Раздел (по каждому разделу / свободная строка -->
	<xsl:template match="Works/FreeString">
		<xsl:param name="IndexType" select="0"/>
		<tr>
			
			<td colspan="7" class="bbottom left">
				<xsl:value-of select="."/>
			</td>
		</tr>

	</xsl:template>




</xsl:stylesheet>


