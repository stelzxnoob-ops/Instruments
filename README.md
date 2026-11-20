# instruments

Инструменты, скиллы и материалы, общие для всех проектов. Код ботов здесь не лежит,
бот магазина живёт в репозитории `barbershop`.

## Что внутри
- `.claude/skills/token-saver` — экономия лимита: модель и effort под размер задачи, минимум чтения.
- `.claude/skills/graphify` — граф кода (`graphify query/path/explain`), чтобы не читать файлы целиком.
- `templates/project/` — правила graphify для CLAUDE.md и хуки `.claude/settings.json` для любого проекта.
- `promo/vinty/` — аватарки, описания ботов, посты, ролики vintyishop / vintyiuzb.
- `install.sh` — установка.

## Как подключить
**Облачная сессия Claude Code:** добавь этот репозиторий в сессию вместе с проектом.
Скиллы из `.claude/skills` подхватятся сами.

**Компьютер или сервер:**
```bash
git clone https://github.com/stelzxnoob-ops/instruments ~/instruments
bash ~/instruments/install.sh                  # скиллы для всех проектов (~/.claude/skills)
bash ~/instruments/install.sh ~/путь/к/проекту # плюс graphify-правила и хуки в проект
```
Обновить: `cd ~/instruments && git pull && bash install.sh`.
