<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs">

    <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
    <xsl:strip-space elements="*"/>
    <xsl:decimal-format name="rus" decimal-separator="," grouping-separator=" "/>

    <xsl:template name="styles">
        <style>
            /* Общие стили документа */
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                margin: 2em;
                padding: 0;
                color: #333;
                font-size: 11pt;
                line-height: 1.6;
                background-color: #fcfcfc;
            }
            h1, h2, h3 {
                color: #111;
                text-align: left;
            }
            h1 {
                font-size: 24px;
                text-align: center;
                margin-bottom: 1.5em;
                line-height: 1.4;
            }
            h2 {
                font-size: 18px;
                margin-top: 2.5em;
                margin-bottom: 1em;
                border-bottom: 2px solid #eaeaea;
                padding-bottom: 0.5em;
            }
            h3 {
                font-size: 15px;
                border-bottom: 1px dashed #ccc;
                margin-bottom: 1em;
                font-style: normal;
                font-weight: 600;
                color: #444;
            }
            p {
                text-indent: 1.25cm;
                text-align: justify;
                margin: 0.5em 0;
            }

            /* --- СОВРЕМЕННЫЕ СТИЛИ ТАБЛИЦ --- */
            table {
                border-collapse: collapse;
                width: 100%;
                margin: 25px 0;
                font-size: 10pt;
            }
            th, td {
                padding: 12px 15px;
                text-align: left;
                vertical-align: top;
                border: 1px solid #e0e0e0;
            }
            th {
                background-color: #f9f9f9;
                font-weight: 600;
                color: #333;
                text-align: center;
                font-size: 10.5pt;
                white-space: nowrap;
            }
            tbody tr:hover {
                background-color: #f5f5f5;
            }

            /* --- Логичная ширина столбцов --- */
            .financing-table th:nth-child(1) { width: 25%; }
            .financing-table th:nth-child(2) { width: 55%; }
            .financing-table th:nth-child(3) { width: 20%; }
            
            .tei-table th:nth-child(1) { width: 50%; text-align: left; }
            .tei-table th:nth-child(2) { width: 15%; }
            .tei-table th:nth-child(3) { width: 17.5%; }
            .tei-table th:nth-child(4) { width: 17.5%; }
            .tei-table td:not(:first-child) { text-align: center; }

            .tei-table .main-tei {
                font-weight: 600;
                background-color: #fef8e7; 
            }
            
            /* ============================================= */
            /* Таблица коэффициентов (ИСПРАВЛЕННАЯ ВЕРСИЯ) */
            /* ============================================= */
            .coefficients-table-v3 {
                width: 100%;
                border-collapse: collapse;
                margin: 25px 0;
                font-size: 10pt;
               
            }
             
            .coefficients-table-v3 td {
                border: 1px solid #e0e0e0;
                padding: 10px 12px;
                vertical-align: middle;
            }
            
            .coefficients-table-v3 th {
                border: 1px solid #e0e0e0;
                padding: 10px 12px;
                vertical-align: middle;
                text-align: center;
                background-color: #f9f9f9;
                font-weight: 600;
                white-space: nowrap; /* Важно: предотвращает перенос текста */
            }
            .coefficients-table-v3 td:nth-child(1),
            .coefficients-table-v3 td:nth-child(2) {
                text-align: left;
                word-wrap: break-word; 
            }
            .coefficients-table-v3 td:nth-child(n+3) {
                text-align: center;
            }
            
            /* Таблица 7: Список документов */
            .documents-table th:nth-child(1) { width: 20%; }
            .documents-table th:nth-child(2) { width: 50%; }
            .documents-table th:nth-child(3) { width: 30%; }

            /* Специальные таблицы */
            .cost-table { font-family: "Menlo", "Consolas", monospace; }
            .cost-table td:nth-child(2) { text-align: right; }
            .cost-table .cost-table-header { font-weight: 600; text-align: center !important; background-color: #f0f0f0; }
            .summary-table td:first-child { font-weight: 600; width: 30%; color: #555; }
            
            /* Прочие улучшения */
            .number { font-weight: 600; color: #000; }
            .footnote { font-size: smaller; text-indent: 0; color: #666; margin-top: 1em; }
            u { text-decoration: none; border-bottom: 2px solid #007bff; padding-bottom: 2px;}
            .designer-note { margin-top: 2em; border-top: 2px solid #eee; padding-top: 1.5em; }
        </style>
    </xsl:template>

    <xsl:template match="/">
        <html>
            <head>
                <title>Пояснительная записка к сметной документации</title>
                <xsl:call-template name="styles"/>
            </head>
            <body>
                <xsl:apply-templates select="/Construction"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="Construction">
                <xsl:variable name="theObject" select="ObjectDescription/*[1]"/>
                <xsl:variable name="estimate" select="ExplanatoryNoteEstimate"/>
                <xsl:variable name="currentPriceLevel" select="$estimate/CurrentPriceLevel"/>
                <xsl:variable name="basicPriceLevel" select="$estimate/BasicPriceLevel"/>

        <p style="text-indent: 0;">
            Дата и время выгрузки файла из сметного программного комплекса: <xsl:text> </xsl:text> 
            <i><xsl:value-of select="concat(substring(ExportDateTime, 9, 2), '.', substring(ExportDateTime, 6, 2), '.', substring(ExportDateTime, 1, 4), ' ', substring(ExportDateTime, 12, 5))"/></i>
        </p> 
        <p style="text-indent: 0;">
            Наименование программного комплекса: <xsl:text> </xsl:text>
           <i><xsl:value-of select="Meta/Soft/Name"/></i>
            <xsl:text> </xsl:text>
            Версия: <xsl:text> </xsl:text>
            <i><xsl:value-of select="Meta/Soft/Version"/></i>
        </p>
        
        

        <h1>Пояснительная записка к сметной документации<br/>объекта капитального строительства</h1>
        
        <h2><span class="number">1.</span> Сведения об объекте капитального строительства</h2>
        <p>
            <span class="number">1.1.</span> Метод определения сметной стоимости: <i><xsl:value-of select="$estimate/CurrentPriceLevel/CalculationMethod"/></i>
        </p>
        <p>
            <span class="number">1.2.</span> Наименование объекта капитального строительства: «<i><xsl:value-of select="$theObject/Name"/></i>»
        </p>
        <xsl:variable name="type-code" select="$theObject/ConstructionType"/>
        <xsl:variable name="type-label">
            <xsl:choose>
                <xsl:when test="$type-code = 1">Строительство</xsl:when>
                <xsl:when test="$type-code = 2">Реконструкция</xsl:when>
                <xsl:when test="$type-code = 3">Капитальный ремонт</xsl:when>
                <xsl:when test="$type-code = 4">Снос</xsl:when>
                <xsl:when test="$type-code = 5">Сохранение объекта культурного наследия</xsl:when>
                <xsl:otherwise>Неизвестно</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <p>
            <span class="number">1.3.</span> Вид строительства: <i><xsl:value-of select="$type-label"/></i>
        </p>

        <p><span class="number">1.4.</span> Сведения об источнике (источниках) и размере финансирования строительства, реконструкции, капитального ремонта, сноса объекта капитального строительства</p>
        <xsl:if test="exists($estimate/FinanceSource/*)">
            <table class="financing-table">
                <thead>
                    <tr>
                        <th>Источник финансирования</th>
                        <th>Наименование уровня бюджета/ Сведения о юридическом лице</th>
                        <th>Доля финансирования, %</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="$estimate/FinanceSource/*">
                        <xsl:choose>
                            <xsl:when test="self::BudgetSource">
                                <tr>
                                    <td>Бюджетные средства</td>
                                    <td><i><xsl:value-of select="BudgetLevel"/></i></td>
                                    <td style="text-align:center;"><i><xsl:value-of select="SourceRatio"/></i></td>
                                </tr>
                            </xsl:when>
                            <xsl:when test="self::StateCustomerSource">
                                <tr>
                                    <td>Средства юридических лиц (ст. 8.3 ГрК РФ)</td>
                                    <td><i><xsl:value-of select="Owner/Organization/FullName"/></i></td>
                                    <td style="text-align:center;"><i><xsl:value-of select="SourceRatio"/></i></td>
                                </tr>
                            </xsl:when>
                            <xsl:when test="self::PrivateSource">
                                <tr>
                                    <td>Частные средства</td>
                                    <td>-</td>
                                    <td style="text-align:center;"><i><xsl:value-of select="SourceRatio"/></i></td>
                                </tr>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </tbody>
            </table>
            <xsl:if test="$estimate/FinanceSource/FinanceComment">
                <p>
                    <span class="number">1.4.1.</span>
                    <xsl:text> </xsl:text>
                    <b>Комментарий:</b>
                    <xsl:text> </xsl:text>
                    <i><xsl:value-of select="$estimate/FinanceSource/FinanceComment"/></i>
                </p>
            </xsl:if>
        </xsl:if>
        
        <p>
            <span class="number">1.5.</span> Почтовый (строительный) адрес (местоположение) объекта капитального строительства: <i><xsl:call-template name="formatAddress"><xsl:with-param name="addressNode" select="$theObject/Address"/></xsl:call-template></i>
        </p>
        
        <p>
            <span class="number">1.6.</span>    Сведения о функциональном назначении объекта капитального строительства: функциональное назначение по классификатору объектов капитального строительства по их назначению и функционально-технологическим особенностям: <i><xsl:value-of select="$theObject/Functions/FunctionsNote"/>, <xsl:value-of select="$theObject/Functions/FunctionsClass"/>.</i>
        </p>
        
        <p><span class="number">1.7.</span> Сведения о технико-экономических показателях объекта:</p>
        <table class="tei-table">
            <thead>
                <tr>
                    <th>Наименование показателя</th>
                    <th>Ед. изм.</th>
                    <th>Значение</th>
                    <th>Стоимость за единицу, тыс. руб. с учетом НДС</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="$theObject/MainTEI">
                    <tr>
                        <xsl:attribute name="class">main-tei</xsl:attribute>
                        <td><i><xsl:value-of select="Name"/></i></td>
                        <td><i><xsl:value-of select="Measure"/></i></td>
                        <td><i><xsl:value-of select="Value"/></i></td>
                        <td>
                            <xsl:if test="UnitCost">
                                <i><xsl:value-of select="format-number(UnitCost, '# ##0,00', 'rus')"/></i>
                            </xsl:if>
                        </td>
                    </tr>
                </xsl:for-each>
                <xsl:for-each select="$theObject/AdditionalTEI">
                    <tr>
                        <td><i><xsl:value-of select="Name"/></i></td>
                        <td><i><xsl:value-of select="Measure"/></i></td>
                        <td><i><xsl:value-of select="Value"/></i></td>
                        <td>
                            <xsl:if test="UnitCost">
                                <i><xsl:value-of select="format-number(UnitCost, '# ##0,00', 'rus')"/></i>
                            </xsl:if>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>

        <xsl:if test="$theObject/ObjectParts">
            <p style="text-indent:0;"><span class="number">1.8.</span> Сведения о зданиях и сооружениях, входящих в состав объекта</p> 
            <xsl:for-each select="$theObject/ObjectParts/ObjectPart">
                <p> Наименование объекта капитального строительства: <i><xsl:value-of select="ObjectName"/></i></p>
                <p> Почтовый (строительный) адрес (местоположение) объекта капитального строительства: 
                    <i><xsl:call-template name="formatAddress"><xsl:with-param name="addressNode" select="ObjectAddress"/></xsl:call-template></i>
                </p>
                <p> Сведения о функциональном назначении объекта капитального строительства: ...
                    <i><xsl:value-of select="ObjectFunctions/FunctionsNote"/>, <xsl:value-of select="ObjectFunctions/FunctionsClass"/></i>
                </p>
                <p><b>Технико-экономические показатели объекта капитального строительства</b></p>
                <table class="tei-table">
                    <thead>
                        <tr>
                            <th>Наименование показателя</th>
                            <th>Ед. изм.</th>
                            <th>Значение</th>
                            <th>Стоимость за единицу, тыс. руб. с учетом НДС</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="TechnicalEconomicIndicators/MainTEI">
                            <tr>
                                <xsl:attribute name="class">main-tei</xsl:attribute>
                                <td><i><xsl:value-of select="Name"/></i></td>
                                <td><i><xsl:value-of select="Measure"/></i></td>
                                <td><i><xsl:value-of select="Value"/></i></td>
                                <td>
                                    <xsl:if test="UnitCost">
                                        <i><xsl:value-of select="format-number(UnitCost, '# ##0,00', 'rus')"/></i>
                                    </xsl:if>
                                </td>
                            </tr>
                        </xsl:for-each>
                        <xsl:for-each select="TechnicalEconomicIndicators/AdditionalTEI">
                            <tr>
                                <td><i><xsl:value-of select="Name"/></i></td>
                                <td><i><xsl:value-of select="Measure"/></i></td>
                                <td><i><xsl:value-of select="Value"/></i></td>
                                <td>
                                    <xsl:if test="UnitCost">
                                        <i><xsl:value-of select="format-number(UnitCost, '# ##0,00', 'rus')"/></i>
                                    </xsl:if>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="$theObject/EnergyEfficiency">
            <p><span class="number">1.9.</span> Класс энергетической эффективности: <b><i><xsl:value-of select="$theObject/EnergyEfficiency/EnergyEfficiencyClass"/></i></b></p>
        </xsl:if>

        <h2><span class="number">2.</span> Сведения о примененных сметных нормативах</h2>
        <ul class="norm-list">
            <xsl:for-each select="$estimate/Legal/*[self::Main or self::Metodology or self::Overheads or self::Profits]">
                <li>- <i><xsl:value-of select="Name"/></i>
                    <xsl:if test="Orders">(с учетом приказов: <i><xsl:for-each select="Orders"><xsl:value-of select="."/><xsl:if test="position() != last()">; </xsl:if></xsl:for-each>)</i></xsl:if>.
                </li>
            </xsl:for-each>
            <xsl:for-each select="$estimate/Legal/Indexes">
                <li>- <i><xsl:value-of select="Name"/>.</i></li>
            </xsl:for-each>
            <xsl:for-each select="$estimate/Legal/Other">
                <li>- <i><xsl:value-of select="Name"/></i>
                    <xsl:if test="Rate"> в размере <i><xsl:value-of select="Rate"/>%</i></xsl:if>. Обоснование: <i><xsl:value-of select="ItemNumber"/>.</i>
                </li>
            </xsl:for-each>
        </ul>

        <h2><span class="number">3.</span> Обоснование особенностей определения сметной стоимости</h2>
        
        <xsl:variable name="uniqueCostTypes" select="distinct-values($estimate/Coefficients/Coefficient/Values/Value/Target)"/>
        <xsl:variable name="hasCoefficients" select="count($estimate/Coefficients/Coefficient) > 0"/>
        
        <xsl:if test="$hasCoefficients">
            <table class="coefficients-table-v3">
                                <thead>
                                        <tr>
                                                                        <th rowspan="2" style="width: 15%;">Обоснование</th>
                                                                        <th rowspan="2" style="width: 55%;">Наименование коэффициента</th>
                                                <th colspan="{count($uniqueCostTypes)}">Значение</th>
                                            </tr>
                                        <tr>
                                                <xsl:for-each select="$uniqueCostTypes">
                                                   <th>
                                                        <xsl:value-of select="."/>
                                                   </th>
                                                 </xsl:for-each>
                                            </tr>
                                    </thead>
                <tbody>
                    <xsl:for-each select="$estimate/Coefficients/Coefficient">
                        
                        <xsl:sort select="Reason"/>
                        <xsl:if test="matches(normalize-space(Reason), '^[0-9]')">
                            <xsl:variable name="currentCoefficient" select="."/>
                            <tr>
                                <td><i><xsl:value-of select="Reason"/></i></td>
                                <td><i><xsl:value-of select="Name"/></i></td>
                                <xsl:for-each select="$uniqueCostTypes">
                                    <xsl:variable name="currentType" select="."/>
                                    <xsl:variable name="value" select="$currentCoefficient/Values/Value[Target = $currentType]/CoefValue"/>
                                    <td>
                                        <i><xsl:value-of select="$value"/></i>
                                    </td>
                                </xsl:for-each>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                </tbody>
            </table>
        </xsl:if>
        
        <xsl:if test="not($hasCoefficients)">
            <p>Коэффициенты, учитывающие условия производства работ, не применялись.</p>
        </xsl:if>
        
        <!--<xsl:if test="$estimate/OtherInfo/Text">
            <h2><span class="number">4.</span> Другие сведения о порядке определения сметной стоимости</h2>
            <xsl:for-each select="$estimate/OtherInfo/Text">
                <p><i><xsl:value-of select="."/></i></p>
            </xsl:for-each>
        </xsl:if>-->

        <h2><span class="number">4.</span> Сведения о сметной стоимости</h2>
        <table class="cost-table">
            <thead>
                <tr>
                    <th>Структура затрат</th>
                    <th>Сметная стоимость, тыс. рублей</th>
                </tr>
            </thead>
            <tbody>
                <xsl:if test="$basicPriceLevel">
                    <tr>
                        <td colspan="2" class="cost-table-header">В базисном уровне цен (<xsl:call-template name="formatPriceLevelDate"><xsl:with-param name="priceLevel" select="$basicPriceLevel"/></xsl:call-template>)</td>
                    </tr>
                </xsl:if>
                <xsl:variable name="totalBasic" select="$estimate/CostSummary/Total"/>
                
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Всего,'"/><xsl:with-param name="node" select="$totalBasic"/><xsl:with-param name="totalNode" select="$totalBasic"/></xsl:call-template>
                <tr><td colspan="2" style="padding-left:15px;">в том числе:</td></tr>
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Строительно-монтажные работы'"/><xsl:with-param name="node" select="$estimate/CostSummary/ConstructionWorks"/><xsl:with-param name="indent" select="'2em'"/><xsl:with-param name="totalNode" select="$totalBasic"/></xsl:call-template>
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Оборудование'"/><xsl:with-param name="node" select="$estimate/CostSummary/Equipment"/><xsl:with-param name="indent" select="'2em'"/><xsl:with-param name="totalNode" select="$totalBasic"/></xsl:call-template>
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Прочие затраты'"/><xsl:with-param name="node" select="$estimate/CostSummary/OtherCosts"/><xsl:with-param name="indent" select="'2em'"/><xsl:with-param name="totalNode" select="$totalBasic"/></xsl:call-template>
                <tr><td colspan="2" style="padding-left:5em;">в том числе:</td></tr>
                <xsl:call-template name="costRow">
                    <xsl:with-param name="label" select="'Проектно-изыскательские работы'"/>
                    <xsl:with-param name="node" select="$estimate/CostSummary/DesignAndSurveyWorks"/>
                    <xsl:with-param name="indent" select="'4em'"/>
                    <xsl:with-param name="totalNode" select="$totalBasic"/>
                </xsl:call-template>
                
                <xsl:if test="$currentPriceLevel">
                    <tr>
                        <td colspan="2" class="cost-table-header">В текущем уровне цен (<xsl:call-template name="formatPriceLevelDate"><xsl:with-param name="priceLevel" select="$currentPriceLevel"/></xsl:call-template>)</td>
                    </tr>
                </xsl:if>
                <xsl:variable name="totalCurrent" select="$estimate/CostSummary/Total"/>
                
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Всего,'"/><xsl:with-param name="node" select="$totalCurrent"/><xsl:with-param name="priceType" select="'current'"/><xsl:with-param name="suffix" select="'*'"/><xsl:with-param name="totalNode" select="$totalCurrent"/></xsl:call-template>
                <tr><td colspan="2" style="padding-left:15px;">в том числе:</td></tr>
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Строительно-монтажные работы'"/><xsl:with-param name="node" select="$estimate/CostSummary/ConstructionWorks"/><xsl:with-param name="priceType" select="'current'"/><xsl:with-param name="indent" select="'2em'"/><xsl:with-param name="totalNode" select="$totalCurrent"/></xsl:call-template>
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Оборудование'"/><xsl:with-param name="node" select="$estimate/CostSummary/Equipment"/><xsl:with-param name="priceType" select="'current'"/><xsl:with-param name="indent" select="'2em'"/><xsl:with-param name="totalNode" select="$totalCurrent"/></xsl:call-template>
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Прочие затраты'"/><xsl:with-param name="node" select="$estimate/CostSummary/OtherCosts"/><xsl:with-param name="priceType" select="'current'"/><xsl:with-param name="indent" select="'2em'"/><xsl:with-param name="totalNode" select="$totalCurrent"/></xsl:call-template>
                <tr><td colspan="2" style="padding-left:5em;">в том числе:</td></tr>
                <xsl:call-template name="costRow">
                    <xsl:with-param name="label" select="'Проектно-изыскательские работы'"/>
                    <xsl:with-param name="node" select="$estimate/CostSummary/DesignAndSurveyWorks"/>
                    <xsl:with-param name="priceType" select="'current'"/>
                    <xsl:with-param name="indent" select="'4em'"/>
                    <xsl:with-param name="totalNode" select="$totalCurrent"/>
                </xsl:call-template>
                <xsl:call-template name="costRow"><xsl:with-param name="label" select="'Налог на добавленную стоимость'"/><xsl:with-param name="node" select="$estimate/CostSummary/Vat"/><xsl:with-param name="priceType" select="'current'"/><xsl:with-param name="indent" select="'2em'"/><xsl:with-param name="totalNode" select="$totalCurrent"/></xsl:call-template>
            </tbody>
        </table>
        <p class="footnote">
                        <xsl:if test="$currentPriceLevel">
<!--                                *Сметная стоимость в уровне цен <i><xsl:call-template name="formatPriceLevelDate"><xsl:with-param name="priceLevel" select="$currentPriceLevel"/></xsl:call-template></i> с учетом НДС.-->
                                      *Сметная стоимость с учетом НДС
                            </xsl:if>
                    </p>
        <h2><span class="number">5.</span> Дополнительные сведения о проектных решениях</h2>
        <xsl:for-each select="(DesignerNote | *[local-name()='DesignerNote'])">
            <div class="designer-note">
                <xsl:apply-templates select="node()"/>
            </div>
        </xsl:for-each>
        
        <h2><span class="number">6.</span> Список приложенных документов</h2>
        <table class="documents-table">
            <thead>
                <tr>
                    <th>Тип документа</th>
                    <th>Наименование</th>
                    <th>Файл</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="ProjectDocumentationContent/ProjectDocument[DocumentType != 'КАД']">
                    <tr>
                        <td><i><xsl:value-of select="DocumentType"/></i></td>
                        <td><i><xsl:value-of select="DocumentName"/></i></td>
                        <td><i><xsl:for-each select="File"><xsl:value-of select="FileName"/><xsl:if test="position() != last()">, </xsl:if></xsl:for-each></i></td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>

       
    
        <div style="margin-top: 4em;">
            <table style="width: 100%; font-size: 11pt;">
                <tr>
                    <td style="width: 15%;">Составил</td>
                    <td style="width: 45%; text-align: left;">
                        <i>
                            <xsl:value-of select="Signatures/ComposeFIO/Position"/>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:value-of select="Signatures/ComposeFIO/Name"/>
                        </i>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%;">Проверил</td>
                    <td style="width: 45%; text-align: left;">
                        <i>
                            <xsl:value-of select="Signatures/VerifyFIO/Position"/>
                            <xsl:text>&#160;</xsl:text>
                            <xsl:value-of select="Signatures/VerifyFIO/Name"/>
                        </i>
                    </td>
                </tr>
            </table>
        </div>

    </xsl:template>

    <xsl:template name="costRow">
        <xsl:param name="label"/>
        <xsl:param name="node"/>
        <xsl:param name="priceType" select="'basic'"/>
        <xsl:param name="indent" select="''"/>
        <xsl:param name="suffix" select="''"/>
        <xsl:param name="totalNode"/> <tr>
            <td>
                <xsl:if test="normalize-space($indent)">
                    <span style="padding-left: {$indent};"><i><xsl:value-of select="$label"/></i></span>
                </xsl:if>
                <xsl:if test="not(normalize-space($indent))">
                    <b><i><xsl:value-of select="$label"/></i></b>
                </xsl:if>
            </td>
            <td>
                <xsl:variable name="priceNode" select="if ($priceType = 'basic') then $node/BasicLevelPrice else $node/CurrentLevelPrice"/>
                <xsl:variable name="totalPrice" select="if ($priceType = 'basic') then $totalNode/BasicLevelPrice else $totalNode/CurrentLevelPrice"/>
                
                <xsl:choose>
                    <xsl:when test="number($totalPrice) = 0">
                        <i>Не требуется</i>
                    </xsl:when>
                    <xsl:when test="normalize-space($priceNode)">
                        <i><xsl:value-of select="format-number(number($priceNode), '# ##0,00', 'rus')"/><xsl:value-of select="$suffix"/></i>
                    </xsl:when>
                    <xsl:otherwise>—</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="formatAddress">
        <xsl:param name="addressNode"/>
        <xsl:if test="normalize-space($addressNode/Country)">
            <i><xsl:value-of select="normalize-space($addressNode/Country)"/></i>
            <xsl:if test="normalize-space($addressNode/Region) or normalize-space($addressNode/City) or normalize-space($addressNode/Street) or normalize-space($addressNode/Building) or normalize-space($addressNode/Note)">, </xsl:if>
        </xsl:if>
        <xsl:if test="normalize-space($addressNode/Region)">
            Регион <i><xsl:value-of select="normalize-space($addressNode/Region)"/></i>
            <xsl:if test="normalize-space($addressNode/City) or normalize-space($addressNode/Street) or normalize-space($addressNode/Building) or normalize-space($addressNode/Note)">, </xsl:if>
        </xsl:if>
        <xsl:if test="normalize-space($addressNode/City)">
            г. <i><xsl:value-of select="normalize-space($addressNode/City)"/></i>
            <xsl:if test="normalize-space($addressNode/Street) or normalize-space($addressNode/Building) or normalize-space($addressNode/Note)">, </xsl:if>
        </xsl:if>
        <xsl:if test="normalize-space($addressNode/Street)">
            ул. <i><xsl:value-of select="normalize-space($addressNode/Street)"/></i>
            <xsl:if test="normalize-space($addressNode/Building) or normalize-space($addressNode/Note)">, </xsl:if>
        </xsl:if>
        <xsl:if test="normalize-space($addressNode/Building)">д. <i><xsl:value-of select="normalize-space($addressNode/Building)"/></i></xsl:if>
        <xsl:if test="normalize-space($addressNode/Note)"> (<i><xsl:value-of select="normalize-space($addressNode/Note)"/></i>)</xsl:if>
    </xsl:template>
    
    <xsl:template name="formatPriceLevelDate">
        <xsl:param name="priceLevel"/>
        <xsl:variable name="year" select="$priceLevel/Year"/>
        <xsl:variable name="month" select="$priceLevel/Month"/>
        <xsl:variable name="day" select="$priceLevel/Day"/>
        <xsl:variable name="quarter" select="$priceLevel/Quarter"/>
        <xsl:choose>
            <xsl:when test="normalize-space($day) and normalize-space($month)">
                <xsl:value-of select="format-number($day, '00')"/>.<xsl:value-of select="format-number($month, '00')"/>.<xsl:value-of select="$year"/>
            </xsl:when>
            <xsl:when test="normalize-space($quarter) and normalize-space($year)">
                <xsl:value-of select="$quarter"/> квартала <xsl:value-of select="$year"/> года
            </xsl:when>
            <xsl:otherwise>
                Неизвестный уровень цен
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="GUID">
        <xsl:variable name="guid" select="."/>
        <xsl:variable name="document" select="//ProjectDocumentationContent/ProjectDocument[GUID = $guid]"/>
        <xsl:if test="$document">
            <a href="{concat('documents/', $document/File/FileName)}">
                <xsl:value-of select="$document/DocumentName"/>
            </a>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="Text">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="SubTitle">
        <h3><i><xsl:value-of select="."/></i></h3>
    </xsl:template>
    
    <xsl:template match="Table">
        <table>
            <xsl:if test="TitleRow">
                <thead>
                    <tr>
                        <xsl:for-each select="TitleRow/Cell">
                            <th><i><xsl:apply-templates select="node()"/></i></th>
                        </xsl:for-each>
                    </tr>
                </thead>
            </xsl:if>
            <tbody>
                <xsl:for-each select="Row">
                    <tr>
                        <xsl:for-each select="Cell">
                            <td><i><xsl:apply-templates select="node()"/></i></td>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    

</xsl:stylesheet>
