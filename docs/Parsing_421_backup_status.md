# Parsing_421: заметки о бэкапах

Обновлено: 09.12.2025.

## Где что лежит
- Скрипты и README: `D:\MAX\_LEARN\Python\Parsing_421\backup`.
- Целевые артефакты: `G:\Мой диск\ai-smeta-backups\Parsing_421\<timestamp>` (формат `yyyyMMdd_HHmmss`, внутри `snapshot/`, ZIP, git bundle).
- Ожидаемые логи: `D:\MAX\_LEARN\Python\Parsing_421\backup\logs\backup_<timestamp>.log` (каталога нет, поэтому ориентируемся по артефактам на G:).

## Последние запуски (статус на 09.12.2025)
- 20251208_133545 (вчера, 08.12.2025 ~13:35): `Parsing_421_20251208_133545.zip` ≈ 86.45 MB (13:38:51), `Parsing_421_20251208_133545.bundle` ≈ 8.40 MB (13:38:53), `snapshot/` от 13:36. Лог не найден в `backup/logs` (скорее не сохранялся), успешность подтверждается наличием артефактов.
- 20251207_225658 (позавчера): ZIP ≈ 13.52 MB (22:57:57), bundle ≈ 8.40 MB (22:59:16), `snapshot/` от 22:57.

## Как быстро проверить вручную
- Список всех бэкапов по времени:
  ```powershell
  Get-ChildItem 'G:\Мой диск\ai-smeta-backups\Parsing_421' | Sort-Object LastWriteTime
  ```
- Детали конкретного запуска (пример для вчерашнего):
  ```powershell
  Get-ChildItem 'G:\Мой диск\ai-smeta-backups\Parsing_421\20251208_133545' `
    | Select-Object Name,@{Name='SizeMB';Expression={[math]::Round($_.Length/1MB,2)}},LastWriteTime
  ```
- Если появится каталог `backup/logs`, там ищем `backup_<timestamp>.log` для расшифровки ошибок robocopy/git bundle.
