Описание / Description
🇷🇺 Русская версия
Универсальный сетевой диагностический инструмент на PowerShell для проверки доступности любых хостов и сервисов. Проверяйте пинг, разрешение DNS, открытые порты и HTTP-статусы за один клик — без привязки к конкретной инфраструктуре.
✅ Почему этот инструмент?
Не требует предопределённой базы хостов — вводите любой IP/FQDN
Гибкие проверки: включайте/выключайте Ping, DNS, Port, HTTP независимо
Поддержка кастомных портов и путей для HTTP-проверок
Массовая проверка из файла (CSV/TXT)
Цветовая индикация статусов в реальном времени
Экспорт результатов в лог-файл с метриками времени
Не требует прав администратора
Работает на PowerShell 5.1+ без внешних зависимостей
🇬🇧 English Version
Universal network diagnostics tool written in PowerShell for checking availability of any host or service. Verify ping, DNS resolution, open ports, and HTTP status codes with a single click — infrastructure-agnostic and ready for any environment.
✅ Why this tool?
No predefined host database required — enter any IP/FQDN on the fly
Flexible checks: enable/disable Ping, DNS, Port, HTTP independently
Custom port support + HTTP path validation
Batch mode from CSV/TXT file
Real-time color-coded status indicators
Export detailed logs with timing metrics
No administrator privileges required
Pure PowerShell 5.1+ — zero external dependencies
✨ Ключевые возможности / Key Features
Функция / Feature
Описание / Description
Универсальный ввод
Universal Input
Проверяйте любой хост: 10.245.0.226, example.com, s3.storage.ru
Test any host: 10.245.0.226, example.com, s3.storage.ru
Гибкие проверки
Flexible Checks
Независимый выбор: Ping • DNS • Port • HTTP
Independent selection: Ping • DNS • Port • HTTP
Кастомные порты
Custom Ports
Любой порт: 22, 80, 443, 3389, 5432, 9092, 10254...
Any port: 22, 80, 443, 3389, 5432, 9092, 10254...
HTTP Path Validation
Проверка конкретных эндпоинтов: /health, /api/status
Validate specific endpoints: /health, /api/status
Пакетный режим
Batch Mode
Массовая проверка из файла: хост,порт,путь
Bulk check from file: host,port,path
Настройка таймаутов
Timeout Control
Порт (мс) • HTTP (сек)
Port (ms) • HTTP (sec)
Экспорт отчётов
Report Export
Сохранение лога с метриками: пинг, DNS, порт, HTTP
Save logs with metrics: ping, DNS, port, HTTP
Цветовая индикация
Color Coding
🟢 Available • 🟡 Partial • 🔴 Unavailable
🟢 Available • 🟡 Partial • 🔴 Unavailable
🚀 Быстрый старт / Quick Start
Требования / Requirements
Windows с PowerShell 5.1+
Сетевой доступ к целевым хостам
Не требуются права администратора / No admin rights required
Установка / Installation
powershell
12345
Запуск / Launch
powershell
1
📋 Примеры использования / Usage Examples
🔹 Быстрая проверка одного хоста / Single Host Check
12345
Результат: полная диагностика за <2 секунды
🔹 Проверка доступности SSH / SSH Accessibility Check
1234
🔹 Диагностика базы данных / Database Connectivity
1234
🔹 Массовая проверка из файла / Batch Check from File
Создайте targets.txt:
text
12345
Нажмите Batch Check (from file) → Выберите файл → Получите отчёт
📊 Пример отчёта / Sample Output
12345678910111213141516171819
📁 Структура проекта / Project Structure
12345678
🔒 Безопасность / Security Notes
✅ Без учётных данных — использует только сетевые проверки / No credentials required — network-level checks only
✅ Только чтение — не изменяет конфигурацию системы / Read-only operations — no system changes
✅ Локальное выполнение — все проверки инициируются с вашей машины / Local execution — all checks originate from your machine
✅ Нет сбора данных — результаты сохраняются только локально / No data collection — results saved locally only
🤝 Вклад в проект / Contributing
Вклады приветствуются! Отправляйте Pull Request.
Contributions welcome! Please feel free to submit a Pull Request.
📄 Лицензия / License
Этот проект распространяется под лицензией MIT — см. файл LICENSE.
This project is licensed under the MIT License — see LICENSE for details.
💡 Советы / Pro Tips
Горячие клавиши: Enter — запуск проверки, Esc — закрыть окно
Hotkeys: Enter — run check, Esc — close window
Шаблоны: Сохраняйте файлы targets.txt для разных окружений (DEV/TEST/PROD)
Templates: Keep targets.txt files for different environments (DEV/TEST/PROD)
Комбинируйте проверки: Отключите Ping для проверки только DNS-резолвинга
Combine checks: Disable Ping to test DNS resolution only
HTTP-диагностика: Используйте пути / для базовой проверки, /health для валидации приложения
HTTP debugging: Use / for basic connectivity, /health for app-level validation
💡 Запомните: Это не просто «чекер для ЕПК-2» — это ваш универсальный сетевой швейцарский нож.
Работает с облаками, локальными серверами, IoT-устройствами, API, базами данных и многим другим.
Один скрипт. Бесконечные возможности.
💡 Remember: This is not just an "EPK-2 checker" — it's your universal network Swiss Army knife.
Works with cloud services, on-prem servers, IoT devices, APIs, databases, and more.
One script. Infinite use cases.
Статус: ✅ Готов к использованию / Production Ready
Последнее обновление: 19 февраля 2026 / February 19, 2026
Тестировалось на: Windows 10/11, Windows Server 2016+
Tested on: Windows 10/11, Windows Server 2016+
⭐ Поставьте звезду, если инструмент оказался полезным! ⭐
⭐ Star this repo if you find it useful! ⭐
