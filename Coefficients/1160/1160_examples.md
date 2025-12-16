# Примеры ошибок и подход (1160)

Контекст: в файле «Рекомендуемая привязка поправочных коэффициентов к ФСНБ-2022 доп.16.xml» выявлены ошибки по схеме `Coefficients-1.0.xsd`: нарушен порядок элементов внутри `Section/Coefficient/Applys`, есть `Section` без обязательного `Coefficient`.

## Нарушенный порядок в Applys (ожидается Cost → Section → Resources)
1) Неверно: `Section` перед `Cost`
```xml
<Applys>
  <Section code="01-01-001" />
  <Cost code="ФЕР01-01-001-01" />
</Applys>
```
Исправление:
```xml
<Applys>
  <Cost code="ФЕР01-01-001-01" />
  <Section code="01-01-001" />
</Applys>
```

2) Неверно: `Cost` после `Resources`
```xml
<Applys>
  <Resources>
    <Resource code="101-1234" />
  </Resources>
  <Cost code="ФЕР01-02-003-02" />
</Applys>
```
Исправление:
```xml
<Applys>
  <Cost code="ФЕР01-02-003-02" />
  <Resources>
    <Resource code="101-1234" />
  </Resources>
</Applys>
```

## Пустые разделы (Coefficient обязателен, minOccurs=1)
1) Пустой `Section`
```xml
<Section code="02-00-000">
  <Name>Общие положения</Name>
</Section>
```
Исправление — добавить хотя бы один `Coefficient`:
```xml
<Section code="02-00-000">
  <Name>Общие положения</Name>
  <Coefficient id="101" code="K-1" target="Стоимость">
    <Name>Повышающий для раздела 02</Name>
    <Worker><Value>1.05</Value></Worker>
  </Coefficient>
</Section>
```

2) Вложенный `Section` без коэффициентов
```xml
<Section code="03-01-000">
  <Name>Земляные работы</Name>
  <Section code="03-01-001">
    <Name>Разработка грунта</Name>
  </Section>
</Section>
```
Исправление: добавить `Coefficient` или удалить/объединить пустой подраздел.

## Архитекторский подход к решению
- Уточнить требования к источнику: фиксируем порядок `Applys` и обязательность `Coefficient` в `Section`.
- Исправить генератор/конвертер XML: выпускать `Applys` в нужной последовательности, запрещать пустые `Section`, валидировать входные данные до выгрузки.
- Добавить pre-publish чек: XSD-валидация `Coefficients-1.0.xsd` и линтер (порядок `Applys`, пустые `Section`), стоп сборки при ошибках.
- Для существующих файлов: одноразовый скрипт нормализации (реупорядочивание `Applys`, заполнение/удаление пустых разделов) и повторная XSD-валидация для подтверждения исправлений.
