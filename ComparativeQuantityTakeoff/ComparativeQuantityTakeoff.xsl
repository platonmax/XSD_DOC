<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="urn:svor:functions"
                exclude-result-prefixes="xs f"
                version="2.0">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Утилиты -->

  <xsl:function name="f:quantity" as="xs:decimal?">
    <xsl:param name="item" as="element()"/>
    <xsl:param name="stageId" as="xs:string"/>
    <xsl:variable name="node"
                  select="if ($stageId = 'base')
                          then $item/*:volumesList/*:alteration[@alterationRef='base']/*:volumeQuantity
                          else $item/*:volumesList/*:alteration[@alterationRef=$stageId]/*:volumeQuantity"/>
    <xsl:sequence select="if ($node) then xs:decimal($node) else ()"/>
  </xsl:function>

  <xsl:function name="f:stage-label" as="xs:string">
    <xsl:param name="stage" as="element()"/>
    <xsl:variable name="year" select="normalize-space($stage/*:year)"/>
    <xsl:variable name="month-raw" select="normalize-space($stage/*:month)"/>
    <xsl:variable name="month"
                  select="if ($month-raw)
                          then format-number(number(substring($month-raw, string-length($month-raw) - 1)), '00')
                          else ''"/>
    <xsl:sequence select="normalize-space(concat($year,
                                                 if ($month) then concat('-', $month) else ''))"/>
  </xsl:function>

  <xsl:function name="f:quarter-label" as="xs:string?">
    <xsl:param name="date" as="element()?"/>
    <xsl:variable name="year" select="normalize-space($date/*:year)"/>
    <xsl:variable name="month" select="if ($date/*:month castable as xs:integer) then xs:integer($date/*:month) else ()"/>
    <xsl:variable name="quarter"
                  select="if ($month) then xs:integer(floor(($month - 1) div 3) + 1) else ()"/>
    <xsl:sequence select="if ($year and $quarter ge 1 and $quarter le 4)
                          then concat(('I','II','III','IV')[$quarter], ' квартал ', $year, ' г')
                          else ()"/>
  </xsl:function>

  <xsl:function name="f:full-date" as="xs:string?">
    <xsl:param name="date" as="element()?"/>
    <xsl:variable name="year" select="normalize-space($date/*:year)"/>
    <xsl:variable name="month" select="if ($date/*:month castable as xs:integer) then xs:integer($date/*:month) else ()"/>
    <xsl:variable name="day" select="if ($date/*:day castable as xs:integer) then xs:integer($date/*:day) else ()"/>
    <xsl:sequence select="if ($year and $month and $day)
                          then concat(format-number($day, '00'), '.', format-number($month, '00'), '.', $year)
                          else ()"/>
  </xsl:function>


  <xsl:function name="f:format" as="xs:string">
    <xsl:param name="value" as="xs:decimal?"/>
    <xsl:sequence select="if (exists($value)) then format-number($value, '0.###') else ''"/>
  </xsl:function>

  <xsl:function name="f:tooltip" as="xs:string">
    <xsl:param name="path" as="xs:string"/>
    <xsl:param name="note" as="xs:string"/>
    <xsl:sequence select="concat('Путь: ', $path, '&#10;Назначение: ', $note)"/>
  </xsl:function>

  <xsl:function name="f:link-label" as="xs:string?">

    <xsl:param name="ref" as="element()?"/>

    <xsl:variable name="fileId" select="$ref/*:fileId"/>

    <xsl:variable name="fileName" select="(root($ref)/*:comparativeQuantityTakeoff/*:fileList/*:file[*:id=$fileId]/*:fileName)[1]"/>

    <xsl:variable name="fileLabel" select="if ($fileName) then $fileName else concat('Файл #', $fileId)"/>

    <xsl:variable name="pageNumber" select="$ref/*:pageNumber"/>

    <xsl:variable name="pageDesc" select="$ref/*:pageDescription"/>

    <xsl:variable name="ifcGuid" select="$ref/*:ifcGuid"/>

    <xsl:variable name="ifcDesc" select="$ref/*:ifcDescription"/>

    <xsl:variable name="propName" select="$ref/*:propertyName"/>

    <xsl:variable name="propDesc" select="$ref/*:propertyDescription"/>

    <xsl:variable name="propValue" select="$ref/*:propertyValue"/>

    <xsl:sequence select="if (not($ref) or not($fileId)) then ''

                          else if ($pageNumber)

                               then concat($fileLabel,

                                           ' (стр. ', normalize-space(string-join($pageNumber/*, ' ')), ')',

                                           if ($pageDesc) then concat(' — ', $pageDesc) else '')

                          else if ($ifcGuid)

                               then concat($fileLabel,

                                           ' (IFC ', normalize-space(string-join($ifcGuid/*, ' ')), ')',

                                           if ($ifcDesc) then concat(' — ', $ifcDesc) else '')

                          else if ($propName)

                               then concat($fileLabel,

                                           ' (', $propName,

                                           if ($propValue) then concat('=', $propValue) else '',

                                           ')',

                                           if ($propDesc) then concat(' — ', $propDesc) else '')

                          else $fileLabel"/>

  </xsl:function>

  <xsl:template match="/">
    <xsl:variable name="doc" select="/*:comparativeQuantityTakeoff"/>
    <xsl:variable name="stages" select="$doc/*:alterationList/*:alteration"/>
    <xsl:variable name="stages-order" as="element()*">
      <xsl:perform-sort select="$stages">
        <xsl:sort select="number(*:year)" data-type="number" order="ascending"/>
        <xsl:sort select="number(substring(normalize-space(*:month), string-length(normalize-space(*:month)) - 1, 2))" data-type="number" order="ascending"/>
      </xsl:perform-sort>
    </xsl:variable>
    <xsl:variable name="alteration-stages" select="$stages-order[@id!='base']"/>
    <xsl:variable name="base-stage" select="$stages-order[@id='base'][1]"/>
    <xsl:variable name="stage-count" select="xs:integer(count($alteration-stages))"/>
    <!-- Кол-во колонок считается детерминированно по блокам:
         5 фиксированных + (1 база + S Total по стадиям) +
         (S блоков изменений: 1 увеличение + снижения ко всем предыдущим стадиям) +
         (S обоснований) +
         (1 база документов + S документов по стадиям) -->
    <xsl:variable name="total-columns" select="1 + $stage-count"/>
    <xsl:variable name="decrease-columns" select="xs:integer(sum(for $i in 1 to $stage-count return $i))"/>
    <xsl:variable name="changes-columns" select="xs:integer($stage-count + $decrease-columns)"/>
    <xsl:variable name="reasons-columns" select="$stage-count"/>
    <xsl:variable name="docs-columns" select="1 + $stage-count"/>
    <xsl:variable name="column-count"
                  select="xs:integer(5 + $total-columns + $changes-columns + $reasons-columns + $docs-columns)"/>
    <xsl:variable name="base-label"
                  select="( ($doc/*:estimateList//*:item[1]/*:volumesList/@baseLabel)[1],
                            'До изменений (база)')[1]"/>

    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta charset="UTF-8"/>
        <title>Сводная ведомость объемов работ</title>
        <style type="text/css">
          body { font-family: "Times New Roman", serif; font-size: 10pt; margin: 20px; }
          h1 { font-size: 16pt; text-align: center; margin: 20px 0; }
          .meta { margin: 12px 0; }
          .meta div { margin: 2px 0; }
          table { width: auto; min-width: 2200px; border-collapse: collapse; margin: 24px 0; }
          thead th { border: 1px solid #000; padding: 6px 6px; font-size: 9pt; background: #f4f4f4;
                     vertical-align: middle; text-align: center; white-space: normal; word-break: break-word; }
          thead th.numbering { background: #fff; font-size: 8pt; font-weight: normal; }
          tbody td { border: 1px solid #000; padding: 4px 5px; vertical-align: top;
                     white-space: normal; word-break: break-word; line-height: 1.15; }
          .center { text-align: center; }
          .right { text-align: right; white-space: nowrap; }
          .nowrap { white-space: nowrap; word-break: normal; }
          .section-row td { font-weight: bold; background: #f0f0f0; }
          .estimate-row td { font-weight: bold; background: #dfe7ff; }
          .notes-cell { white-space: pre-wrap; }
          .header-block { margin: 8px 0 24px 0; width: 1100px; max-width: 1100px; }
          .header-title { font-size: 14pt; font-weight: bold; text-align: center; text-transform: uppercase; margin: 0 0 18px; }
          table.header-table { width: 1100px; max-width: 1100px; min-width: 0; margin: 0; border-collapse: collapse; table-layout: fixed; }
          table.header-table td { border: none; padding: 4px 4px; font-size: 11pt; vertical-align: bottom; }
          table.header-table .label { width: 12%; min-width: 80px; white-space: nowrap; text-align: left; padding-right: 4px; }
          table.header-table .line { width: auto; padding-left: 0; }
          table.header-table .line-text { border-bottom: 1px solid #000; min-height: 18px; padding: 0 4px 2px 4px; text-align: center; }
          table.header-table .hint { font-size: 9pt; color: #666; text-align: center; font-style: italic; white-space: nowrap; padding-top: 2px; }
          table.header-table .date-alt { color: #c00; font-style: italic; }
        </style>
      </head>
      <body>
        <xsl:variable name="doc-date" select="$doc/*:date"/>
        <xsl:variable name="customer" select="normalize-space($doc/*:customer)"/>
        <xsl:variable name="object-name" select="normalize-space($doc/*:objectName)"/>
        <xsl:variable name="quarter-label" select="f:quarter-label($doc-date)"/>
        <xsl:variable name="full-date" select="f:full-date($doc-date)"/>

        <div class="header-block">
          <div class="header-title">СОПОСТАВИТЕЛЬНАЯ ВЕДОМОСТЬ ОБЪЕМОВ РАБОТ</div>
          <table class="header-table">
            <tr>
              <td class="label">Заказчик</td>
              <td class="line">
                <div class="line-text">
                  <xsl:value-of select="$customer"/>
                </div>
                <div class="hint">(наименование организации)</div>
              </td>
            </tr>
            <tr>
              <td class="label">&#160;</td>
              <td class="line">
                <div class="line-text">
                  <xsl:value-of select="$object-name"/>
                </div>
                <div class="hint">(наименование стройки)</div>
              </td>
            </tr>
            <tr>
              <td class="label">Дата составления:</td>
              <td class="line">
                <div class="line-text">
                  <xsl:choose>
                    <xsl:when test="$quarter-label">
                      <xsl:value-of select="$quarter-label"/>
                      <xsl:if test="$full-date">
                        <xsl:text> (или </xsl:text><span class="date-alt"><xsl:value-of select="$full-date"/></span><xsl:text>)</xsl:text>
                      </xsl:if>
                    </xsl:when>
                    <xsl:when test="$full-date">
                      <xsl:value-of select="$full-date"/>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </div>
              </td>
            </tr>
          </table>
        </div>


        <xsl:call-template name="render-table">
          <xsl:with-param name="doc" select="$doc"/>
          <xsl:with-param name="stages-order" select="$alteration-stages"/>
          <xsl:with-param name="stage-count" select="$stage-count"/>
          <xsl:with-param name="column-count" select="$column-count"/>
          <xsl:with-param name="base-label" select="$base-label"/>
          <xsl:with-param name="base-stage" select="$base-stage"/>
        </xsl:call-template>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="render-table">
    <xsl:param name="doc"/>
    <xsl:param name="stages-order" as="element()*"/>
    <xsl:param name="stage-count" as="xs:integer"/>
    <xsl:param name="column-count" as="xs:integer"/>
    <xsl:param name="base-label" as="xs:string"/>
    <xsl:param name="base-stage" as="element()?"/>
    <xsl:variable name="decrease-columns" select="xs:integer(sum(for $i in 1 to $stage-count return $i))"/>
    <xsl:variable name="change-columns" select="xs:integer($stage-count + $decrease-columns)"/>
    <xsl:variable name="numbering" as="xs:string*">
      <xsl:sequence select="('1','2','3','4','5')"/>
      <xsl:sequence select="'6'"/>
      <xsl:for-each select="1 to $stage-count">
        <xsl:sequence select="if (position() = 1) then '7' else concat('7.', position() - 1)"/>
      </xsl:for-each>
      <xsl:for-each select="1 to $stage-count">
        <xsl:variable name="idx" select="position() - 1"/>
        <xsl:sequence select="if ($idx = 0) then '8' else concat('8.', $idx)"/>
        <xsl:choose>
          <xsl:when test="$idx = 0">
            <xsl:sequence select="'9'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="1 to ($idx + 1)">
              <xsl:sequence select="concat('9.', $idx, '.', position())"/>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:variable name="reason-start" select="10"/>
      <xsl:for-each select="1 to $stage-count">
        <xsl:sequence select="if (position() = 1) then string($reason-start) else concat($reason-start, '.', position() - 1)"/>
      </xsl:for-each>
      <xsl:sequence select="'11'"/>
      <xsl:for-each select="$stages-order">
        <xsl:sequence select="if (position() = 1)
                              then '12'
                              else concat('12.', position() - 1)"/>
      </xsl:for-each>
    </xsl:variable>

    <table>
      <thead>
        <tr>
          <th rowspan="3" class="center">№ п/п</th>
          <th colspan="2" class="center">Данные сметного расчета (сметы)</th>
          <th rowspan="3" class="center">Наименование работ и затрат</th>
          <th rowspan="3" class="center">Ед. изм.</th>
          <th colspan="{1 + $stage-count}" class="center">Объем работ в сметной документации</th>
          <th colspan="{$change-columns}" class="center">Изменение объема работ</th>
          <th colspan="{$stage-count}" class="center">Обоснование изменений</th>
          <th colspan="{$stage-count + 1}" class="center">Ссылки на исходные документы</th>
        </tr>
        <tr>
          <th class="center" rowspan="2">Номер</th>
          <th class="center" rowspan="2">Наименование</th>
          <th class="center" rowspan="2">
            <xsl:value-of select="$base-label"/>
          </th>
          <xsl:for-each select="$stages-order">
            <th class="center" rowspan="2">
              <xsl:value-of select="f:stage-label(.)"/>
            </th>
          </xsl:for-each>
          <xsl:for-each select="$stages-order">
            <xsl:variable name="stage-index" select="position()"/>
            <th class="center" colspan="{1 + $stage-index}">
              Корректировка <xsl:value-of select="f:stage-label(.)"/>
            </th>
          </xsl:for-each>
          <xsl:for-each select="$stages-order">
            <th class="center" rowspan="2">
              <xsl:value-of select="f:stage-label(.)"/>
            </th>
          </xsl:for-each>
          <th class="center" rowspan="2">
            <xsl:value-of select="$base-label"/>
          </th>
          <xsl:for-each select="$stages-order">
            <th class="center" rowspan="2">
              <xsl:value-of select="f:stage-label(.)"/>
            </th>
          </xsl:for-each>
        </tr>
        <tr>
          <xsl:for-each select="$stages-order">
            <xsl:variable name="stage-index" select="position()"/>
            <xsl:variable name="stage-label" select="f:stage-label(.)"/>
            <th class="center">Увеличение <xsl:value-of select="$stage-label"/></th>
            <xsl:variable name="prior-stages" select="reverse(($base-stage, $stages-order[position() lt $stage-index]))"/>
            <xsl:for-each select="$prior-stages">
              <xsl:variable name="target-label" select="if (@id = 'base') then f:stage-label($base-stage) else f:stage-label(.)"/>
              <th class="center">Снижение <xsl:value-of select="$target-label"/></th>
            </xsl:for-each>
          </xsl:for-each>
        </tr>
        <tr>
          <xsl:for-each select="$numbering">
            <th class="center numbering">
              <xsl:value-of select="."/>
            </th>
          </xsl:for-each>
        </tr>
      </thead>
      <tbody>
        <xsl:call-template name="render-estimates">
          <xsl:with-param name="estimates" select="$doc/*:estimateList/*:estimate"/>
          <xsl:with-param name="stages-order" select="$stages-order"/>
          <xsl:with-param name="base-label" select="$base-label"/>
          <xsl:with-param name="column-count" select="xs:integer($column-count)"/>
          <xsl:with-param name="base-stage" select="$base-stage"/>
        </xsl:call-template>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="render-estimates">
    <xsl:param name="estimates" as="element()*"/>
    <xsl:param name="stages-order" as="element()*"/>
    <xsl:param name="base-label" as="xs:string"/>
    <xsl:param name="column-count" as="xs:integer"/>
    <xsl:param name="base-stage" as="element()?"/>

    <xsl:for-each select="$estimates">
      <xsl:variable name="estimate" select="."/>
      <xsl:variable name="source" select="$estimate/*:sourceEstimate"/>
      <tr class="estimate-row">
        <td colspan="{$column-count}"
            title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sourceEstimate','Исходная смета (номер, наименование, дата)')}">
          <xsl:text>Смета </xsl:text>
          <xsl:value-of select="normalize-space($source/*:number)"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="normalize-space($source/*:name)"/>
          <xsl:if test="$source/*:date">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space($source/*:date/@display)"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </td>
      </tr>
      <xsl:call-template name="render-sections">
        <xsl:with-param name="sections" select="$estimate/*:sectionList/*:section"/>
        <xsl:with-param name="level" select="0"/>
        <xsl:with-param name="stages-order" select="$stages-order"/>
        <xsl:with-param name="base-label" select="$base-label"/>
        <xsl:with-param name="column-count" select="$column-count"/>
        <xsl:with-param name="estimate-source" select="$source"/>
        <xsl:with-param name="base-stage" select="$base-stage"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="render-sections">
    <xsl:param name="sections" as="element()*"/>
    <xsl:param name="level" as="xs:integer"/>
    <xsl:param name="stages-order" as="element()*"/>
    <xsl:param name="base-label" as="xs:string"/>
    <xsl:param name="column-count" as="xs:integer"/>
    <xsl:param name="estimate-source" as="element()?"/>
    <xsl:param name="base-stage" as="element()?"/>

    <xsl:for-each select="$sections">
      <tr class="section-row">
        <td colspan="{$column-count}"
            title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/(numberSection|name)','Номер и наименование раздела сметы')}">
          <xsl:variable name="sectionNumber" select="normalize-space(*:numberSection)"/>
          <xsl:variable name="sectionName" select="normalize-space(*:name)"/>
          <xsl:value-of select="concat(if ($sectionNumber) then concat($sectionNumber, '. ') else '', $sectionName)"/>
        </td>
      </tr>
      <xsl:for-each select="*:itemList/*:item">
        <xsl:call-template name="render-item">
          <xsl:with-param name="item" select="."/>
          <xsl:with-param name="stages-order" select="$stages-order"/>
          <xsl:with-param name="base-label" select="$base-label"/>
          <xsl:with-param name="estimate-source" select="$estimate-source"/>
          <xsl:with-param name="base-stage" select="$base-stage"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:if test="*:sectionList/*:section">
        <xsl:call-template name="render-sections">
          <xsl:with-param name="sections" select="*:sectionList/*:section"/>
          <xsl:with-param name="level" select="$level + 1"/>
          <xsl:with-param name="stages-order" select="$stages-order"/>
          <xsl:with-param name="base-label" select="$base-label"/>
          <xsl:with-param name="column-count" select="$column-count"/>
          <xsl:with-param name="estimate-source" select="$estimate-source"/>
          <xsl:with-param name="base-stage" select="$base-stage"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="render-item">
    <xsl:param name="item" as="element()"/>
    <xsl:param name="stages-order" as="element()*"/>
    <xsl:param name="base-label" as="xs:string"/>
    <xsl:param name="estimate-source" as="element()?"/>
    <xsl:param name="base-stage" as="element()?"/>
    <xsl:param name="depth" as="xs:integer" select="0"/>

    <xsl:variable name="indent" select="string-join(for $i in 1 to $depth return '   ', '')"/>
    <xsl:variable name="base-value" select="f:quantity($item, 'base')"/>

    <tr>
      <td class="center nowrap"
          title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/@position','Номер позиции сметы (атрибут position)')}">
        <xsl:value-of select="$item/@position"/>
      </td>
      <td title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sourceEstimate/Number','Номер исходной сметы (SourceEstimate/Number)')}">
        <xsl:value-of select="normalize-space($estimate-source/*:number)"/>
      </td>
      <td title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sourceEstimate/Name','Наименование исходной сметы (SourceEstimate/Name)')}">
        <xsl:value-of select="normalize-space($estimate-source/*:name)"/>
      </td>
      <td title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/work','Работа (Work/Name, Work/Prefix, Work/Code)')}">
        <xsl:value-of select="$indent"/>
        <xsl:value-of select="normalize-space($item/*:work/*:name)"/>
        <xsl:variable name="prefix" select="normalize-space($item/*:work/*:prefix)"/>
        <xsl:variable name="code" select="normalize-space($item/*:work/*:code)"/>
        <xsl:if test="$prefix or $code">
          <xsl:text> (</xsl:text>
          <xsl:if test="$prefix">
            <xsl:value-of select="$prefix"/>
            <xsl:if test="$code">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:if>
          <xsl:if test="$code">
            <xsl:text>код: </xsl:text>
            <xsl:value-of select="$code"/>
          </xsl:if>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </td>
      <td class="center"
          title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/work/Unit','Единица измерения (Work/Unit)')}">
        <xsl:value-of select="$item/*:work/*:unit"/>
      </td>
      <td class="right"
          title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumesList/alteration[@alterationRef=&quot;base&quot;]/volumeQuantity','Объем базы (Volumes/Alteration, alterationRef=base)')}">
        <xsl:value-of select="f:format($base-value)"/>
      </td>
      <xsl:for-each select="$stages-order">
        <xsl:variable name="stageId" select="@id"/>
        <xsl:variable name="stageLabel" select="f:stage-label(.)"/>
        <xsl:variable name="value" select="f:quantity($item, $stageId)"/>
        <td class="right"
            title="{f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumesList/alteration[@alterationRef=&quot;',$stageId,'&quot;]/volumeQuantity'), concat('Объем по стадии ', $stageLabel))}">
          <xsl:value-of select="f:format($value)"/>
        </td>
      </xsl:for-each>
      <xsl:for-each select="$stages-order">
        <xsl:variable name="stage" select="."/>
        <xsl:variable name="stageId" select="$stage/@id"/>
        <xsl:variable name="stageLabel" select="f:stage-label($stage)"/>
        <xsl:variable name="stage-pos" select="position()"/>
        <xsl:variable name="inc" select="$item/*:volumesList/*:alteration[@alterationRef=$stageId]/*:volumeIncrease[1]"/>
        <xsl:variable name="dec" select="$item/*:volumesList/*:alteration[@alterationRef=$stageId]/*:volumeDecrease[1]"/>
        <xsl:variable name="prior-stages" select="reverse(($base-stage, $stages-order[position() lt $stage-pos]))"/>
        <xsl:variable name="prev-stage-id" select="( ($stages-order[position() lt $stage-pos])[last()]/@id, 'base')[1]"/>

        <td class="right"
            title="{f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumesList/alteration[@alterationRef=&quot;',$stageId,'&quot;]/volumeIncrease'), concat('Увеличение объема на стадии ', $stageLabel))}">
          <xsl:value-of select="f:format($inc)"/>
        </td>
        <xsl:for-each select="$prior-stages">
          <xsl:variable name="target-stage" select="."/>
          <xsl:variable name="target-id" select="@id"/>
          <xsl:variable name="target-label" select="if ($target-id = 'base') then f:stage-label($base-stage) else f:stage-label($target-stage)"/>
          <xsl:variable name="difference" select="$item/*:volumesList/*:alteration[@alterationRef=$stageId]/*:Delta/*:Difference[@fromRef=$target-id]"/>
          <xsl:variable name="raw-dec" select="if ($difference) then xs:decimal($difference) else if ($target-id = $prev-stage-id and $dec) then xs:decimal($dec) else ()"/>
          <xsl:variable name="dec-value" select="if (exists($raw-dec) and $raw-dec lt 0) then $raw-dec else ()"/>
          <td class="right"
              title="{f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumesList/alteration[@alterationRef=&quot;',$stageId,'&quot;]/Delta/Difference[@fromRef=&quot;',$target-id,'&quot;]'), concat('Снижение объема от ', if ($target-id = 'base') then 'базы' else concat('стадии ', $target-label), ' до стадии ', $stageLabel))}">
            <xsl:value-of select="f:format($dec-value)"/>
          </td>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="$stages-order">
        <xsl:variable name="stageId" select="@id"/>
        <xsl:variable name="stageLabel" select="f:stage-label(.)"/>
        <xsl:variable name="reasons" select="$item/*:volumesList/*:alteration[@alterationRef=$stageId]/*:reason"/>
        <td class="notes-cell"
            title="{f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/volumesList/alteration[@alterationRef=&quot;',$stageId,'&quot;]/reason'), concat('Причины изменения по стадии ', $stageLabel))}">
          <xsl:for-each select="$reasons">
            <xsl:if test="position() gt 1"><br/></xsl:if>
            <xsl:value-of select="."/>
          </xsl:for-each>
        </td>
      </xsl:for-each>
      <xsl:variable name="baseDocs" select="$item/*:documentationList/*:reference[not(@alterationRef) or @alterationRef='base']"/>
      <td class="notes-cell"
          title="{f:tooltip('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/documentationList/reference[@alterationRef=&quot;base&quot;]', 'Документы, привязанные к базе (подпись ссылки)')}">
        <xsl:for-each select="$baseDocs">
          <xsl:if test="position() gt 1"><br/></xsl:if>
          <xsl:value-of select="f:link-label(.)"/>
        </xsl:for-each>
      </td>
      <xsl:for-each select="$stages-order">
        <xsl:variable name="stageId" select="@id"/>
        <xsl:variable name="stageLabel" select="f:stage-label(.)"/>
        <xsl:variable name="docs" select="$item/*:documentationList/*:reference[@alterationRef=$stageId]"/>
        <td class="notes-cell"
            title="{f:tooltip(concat('/comparativeQuantityTakeoff/estimateList/estimate/sectionList/section/itemList/item/documentationList/reference[@alterationRef=&quot;',$stageId,'&quot;]'), concat('Документы по стадии ', $stageLabel, ' (подпись ссылки)'))}">
          <xsl:for-each select="$docs">
            <xsl:if test="position() gt 1"><br/></xsl:if>
            <xsl:value-of select="f:link-label(.)"/>
          </xsl:for-each>
        </td>
      </xsl:for-each>
    </tr>

    <xsl:for-each select="$item/*:itemList/*:item">
      <xsl:call-template name="render-item">
        <xsl:with-param name="item" select="."/>
        <xsl:with-param name="stages-order" select="$stages-order"/>
        <xsl:with-param name="base-label" select="$base-label"/>
        <xsl:with-param name="estimate-source" select="$estimate-source"/>
        <xsl:with-param name="base-stage" select="$base-stage"/>
        <xsl:with-param name="depth" select="$depth + 1"/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>

