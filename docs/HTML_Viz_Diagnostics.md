# Диагностика сгенерированного HTML (визуалка XSL)

Короткие проверки, чтобы понять, что выводится в готовом HTML без ручного просмотра браузером. Подходит для любых XSL-таблиц, например ComparativeQuantityTakeoff.

## Чтение таблиц через pandas
```powershell
# заменить путь на нужный HTML
@'
import pandas as pd

html = "ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff_minstroy_simple.html"
tables = pd.read_html(html)
print(len(tables))  # сколько таблиц

# пример: первая большая таблица (обычно index 1)
df = tables[1]
# расплющить многоуровневые заголовки для удобной выборки
flat = ['/'.join([str(x) for x in col]) for col in df.columns]
df.columns = flat

# посмотреть столбцы по маске
target_cols = [c for c in flat if "Изменение объема работ/Корректировка" in c]
print(target_cols)

# пример выборки проблемных колонок
print(df[["№ п/п/№ п/п/№ п/п/1",
          "Изменение объема работ/Корректировка 2025 г./Снижение 2025 г./9.2.1",
          "Изменение объема работ/Корректировка 2025 г./Снижение 2025 г./9.2.2",
          "Изменение объема работ/Корректировка 2025 г./Снижение 2024 г./9.2.3"]])
@' | python -
```

## Быстрый парсинг заголовков через BeautifulSoup
```powershell
@'
from bs4 import BeautifulSoup
from pathlib import Path

html = Path("ComparativeQuantityTakeoff/MINSTROY_VERSION/ComparativeQuantityTakeoff_minstroy_simple.html").read_text(encoding="utf-8")
soup = BeautifulSoup(html, "html.parser")

# найти таблицу по тексту в заголовке
table = None
for t in soup.find_all("table"):
    if t.find(string=lambda x: x and "Изменение объема работ" in x):
        table = t
        break

if table:
    rows = table.find_all("tr")[:4]
    for i, row in enumerate(rows):
        cells = [c.get_text(strip=True) for c in row.find_all(["th", "td"])]
        print(i, cells)
else:
    print("Таблица не найдена")
@' | python -
```

## Зачем
- Быстро убедиться, что нужный столбец/ячейки не пустые.
- Проверить порядок колонок после изменений XSL.
- Искать смещения/повторы заголовков без открытия браузера.
