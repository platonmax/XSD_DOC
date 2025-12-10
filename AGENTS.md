# Инструкция для агентов (XSD_DOC)

Основной файл инструкций: `tools/AGENTS.md` (джанкшен ведёт в `d:\MAX\projects\schema-tools\AGENTS.md`). Всегда начинайте с него.

Локальные дополнения для XSD_DOC (если появятся) добавляйте ниже.

## Учёт задач по трекингу
- Если работаем по задаче с номером из трекинг-системы (например, 1129), ведём короткую историю и текущий статус в Markdown-файле `<номер>.md`, который лежит в папке самой задачи (где её материалы/артефакты).
- Имя файла - только номер задачи без префиксов/суффиксов.
- В файле держим два блока: краткий контекст (понятный, но без бизнес-терминов/речи для бизнеса) и историю. В истории каждое значимое действие/ответ фиксируем лаконично: дата/время, что сделано, что осталось/блокеры; обновляем по мере прогресса.
- Не смешиваем задачи: для каждой задачи — отдельный `<номер>.md` в её папке (например, `LocalEstimateResourceIndexMethod/1149/1149.md` для РИМ, `LocalEstimateBaseIndexMethod/1148/1148.md` для БИМ). Не добавляем сведения одной задачи в файл другой.

## Дополнения из SVOR
Перед любыми изменениями основной схемы ComparativeQuantityTakeoff (файлы `ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd` и зеркальные копии в `schema/ComparativeQuantityTakeoff*.xsd`) выполняйте полный чек-лист:

0. **Проверка на кракозябры** в схеме/примерах/XSL (перед любыми правками):
   ```powershell
   python tools/xsd-tools/check_garbage.py `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsl `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/types/BaseDocument.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/types/CommonTypes.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/types/BaseTypes.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/types/Xmldsig.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff_minstroy_simple.xml
   ```
   При изменениях схемы обязательно соблюдайте правила именования/проверок из `docs/XSD_Naming_Policy.md` и `docs/Schema_Naming_TZ.md` (используйте версии из этого проекта).
1. **Сохраните контрольную копию схемы** рядом с исходником: `ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.<timestamp>.xsd` (таймстемп `yyyyMMddHHmmss` перед расширением). Если поддерживаете зеркальную копию в `schema/`, сохраните её в `schema/ComparativeQuantityTakeoff.<timestamp>.xsd`.
2. **Прогоните скрипт сравнения типов** (до правок) и изучите diff:
   ```powershell
   python tools/xsd-tools/compare_xsd_types.py `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.<timestamp>.xsd
   ```
3. **Подтвердите результаты через xmlschema (неиспользуемые типы)**:
   ```powershell
   python tools/xsd-tools/check_unused_types_xmlschema.py ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd
   ```
4. **Проверьте валидность**:
   ```powershell
   python -c "import xmlschema; xmlschema.XMLSchema('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd'); print('Schema valid')"
   python -c "import xmlschema; schema = xmlschema.XMLSchema11('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd'); schema.validate('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff_minstroy_simple.xml'); print('Sample valid (XSD 1.1)')"
   ```
   Для проверки изменений документации типов/элементов:
   ```powershell
   python tools/xsd-tools/compare_xsd_docs.py `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd `
     ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.<timestamp>.xsd
   ```
5. **Всегда включайте в ответ пользователю/отчёт**: вывод `compare_xsd_types.py`, `check_unused_types_xmlschema.py` и результаты валидаций (схема + примеры), даже если изменений нет.
6. **После внесения правок повторно запустите `compare_xsd_types.py`** с тем же baseline, чтобы зафиксировать итоговый diff и приложить его в отчёт.

Только после выполнения шагов 1-7 можно редактировать схему (и завершать работу после повторного diff).

Дополнительные правила:
- Всегда отвечайте пользователю на русском языке, включая статусы, отчёты и пояснения.
- Соблюдайте ограничения `docs/XSD_Documentation_Safeguards.md`.
- Малые ошибки документации исправлять без замены или генерации текстов: не перезаписывать существующие описания (xs:documentation) и tooltips без прямого указания пользователя.
- Не трогать описания и документацию (xs:documentation, tooltips) без прямого указания пользователя. Любые изменения текстов документации делать только по явному запросу.

## Быстрые команды (Windows PowerShell)
- Python и скрипты XSD:
  ```powershell
  # дифф объявлений типов/элементов (базовый снимок подставьте свой)
  python tools/xsd-tools/compare_xsd_types.py `
    ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd `
    ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.<timestamp>.xsd
  # дифф описаний (documentation)
  python tools/xsd-tools/compare_xsd_docs.py `
    ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd `
    ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.<timestamp>.xsd
  # поиск неиспользуемых типов
  python tools/xsd-tools/check_unused_types_xmlschema.py ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd
  # валидация XSD и примера
  python -c "import xmlschema; xmlschema.XMLSchema('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd'); print('Schema valid')"
  python -c "import xmlschema; schema = xmlschema.XMLSchema11('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff.xsd'); schema.validate('ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff_minstroy_simple.xml'); print('Sample valid (XSD 1.1)')"
  ```
- Визуализация (Saxon на Windows):
  ```powershell
  Set-Location -Path 'D:\MAX\projects\XSD_DOC'
  & 'C:\Program Files\Eclipse Adoptium\jre-21.0.7.6-hotspot\bin\java.exe' `
    -cp 'tools\saxon-he-12.4.jar;tools\xmlresolver-5.2.1.jar' `
    net.sf.saxon.Transform `
    -s:ComparativeQuantityTakeoff\MINSTROY_VERSION\ComparativeQuantityTakeoff_minstroy_simple.xml `
    -xsl:ComparativeQuantityTakeoff\MINSTROY_VERSION\ComparativeQuantityTakeoff.xsl `
    -o:ComparativeQuantityTakeoff\MINSTROY_VERSION\ComparativeQuantityTakeoff_minstroy_simple.html
  ```
