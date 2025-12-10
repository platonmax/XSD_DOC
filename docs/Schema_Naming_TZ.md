# Техническое задание: правила именования и проверки XSD/XML/XSL (XSD_DOC)

Используйте это ТЗ вместе с `docs/XSD_Naming_Policy.md` для всех правок схем ComparativeQuantityTakeoff.

## Кодировки и формат
- Все файлы XSD/XML/XSL/HTML/скрипты держать в UTF-8 без BOM; в XML явно `encoding="utf-8"` и `meta charset="UTF-8"`.
- PowerShell: чтение/запись с `-Encoding UTF8`; при необходимости `chcp 65001` и `$OutputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8`.
- Python/скрипты: везде `encoding="utf-8"` при чтении/записи.
- Saxon/Java: считать вход/выход в UTF-8.
- Не копировать тексты из консоли cp866/cp1251; проверять новые файлы на UTF-8.

## Именование (Минстрой + UBL-ориентированный стиль)
- complexType/simpleType — `lowerCamelCase` + суффикс `Type`/`CodeType`/`IdType`.
- Элементы и атрибуты — `lowerCamelCase`; без непонятных сокращений.
- Коллекции — суффикс `List` сохраняем (пример: `sectionList`, `itemList`, `alterationList`, `fileList`); внутри — единственное число (`item`, `section`, `documentReference`).
- Идентификаторы/ссылки: `:Id` / `:Ref` для элементов/атрибутов; типы `:IdType`/`:RefType`.
- Коды/классификаторы: элементы `...Code`, типы `...CodeType`; для единиц/валют — пары `value + unitCode/currencyCode`.
- Prefix/namespace — стабильные (`bt`, `ct`, `bd`, `cqt`, `ds`), не менять без необходимости; путь импортов предсказуемый `types/*.xsd`.
- При сомнениях об именах и разбиении на типы сверяйтесь с шаблоном в `docs/XSD_Naming_Policy.md`.

## Обязательные проверки перед любыми правками ComparativeQuantityTakeoff
1. Проверка на кракозябры:
   ```powershell
   python tools/xsd-tools/check_garbage.py `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/types/BaseDocument.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/types/CommonTypes.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/types/BaseTypes.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/types/Xmldsig.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsl `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff_minstroy_simple.xml
   ```
2. Сохранить контрольную копию схемы `ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.<timestamp>.xsd` (yyyyMMddHHmmss перед расширением). При необходимости поддерживайте зеркальную копию в `schema/ComparativeQuantityTakeoff.<timestamp>.xsd`.
3. Дифф типов/элементов:
   ```powershell
   python tools/xsd-tools/compare_xsd_types.py `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.<timestamp>.xsd
   ```
4. Поиск неиспользуемых типов:
   ```powershell
   python tools/xsd-tools/check_unused_types_xmlschema.py ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd
   ```
5. Валидация XSD и примера:
   ```powershell
   python -c "import xmlschema; xmlschema.XMLSchema('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd'); print('Schema valid')"
   python -c "import xmlschema; schema = xmlschema.XMLSchema11('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd'); schema.validate('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff_minstroy_simple.xml'); print('Sample valid (XSD 1.1)')"
   ```
6. Для контроля документации типов/элементов (при изменениях описаний):
   ```powershell
   python tools/xsd-tools/compare_xsd_docs.py `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.<timestamp>.xsd
   ```
7. После правок повторите `compare_xsd_types.py` с тем же baseline и приложите итоговый diff в отчёт.

## Контроль документации
- Соблюдайте `docs/XSD_Documentation_Safeguards.md`; не изменяйте xs:documentation/xs:appinfo без явного запроса, переносите аннотации вместе с узлами, избегайте грубых замен по тексту.

Нарушения кодировки, именования или проверки считаются блокирующими до исправления.
