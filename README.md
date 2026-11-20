# instruments

Инструменты, скиллы и материалы, общие для всех проектов. Код ботов здесь не лежит,
бот магазина живёт в репозитории `Vintyi`.

Репозиторий — это **плагин Claude Code** (маркетплейс `instruments`, плагин `instruments`).
Подключённый к проекту, он сам даёт скиллы, хуки и ставит то, что нужно для их работы.

## Что внутри
- `plugins/instruments/` — сам плагин:
  - `skills/token-saver` — экономия лимита: модель и effort под размер задачи, минимум чтения.
  - `skills/graphify` — граф кода (`graphify query/path/explain`), чтобы не читать файлы целиком.
  - `hooks/` — при старте сессии ставит `graphify` (если нет), строит/обновляет граф проекта
    в фоне, добавляет `graphify-out/` в `.gitignore` и подсказывает Claude правила graphify;
    перед Read/Grep/Bash направляет к графу. Без `graphify` хуки просто молчат.
- `.claude-plugin/marketplace.json` — описание маркетплейса.
- `templates/project/settings.json` — что положить в `.claude/settings.json` проекта.
- `promo/vinty/` — аватарки, описания ботов, посты, ролики vintyishop / vintyiuzb (в плагин не входят).
- `install.sh` — подключение одной командой.

## Как подключить к проекту (рекомендуется — работает и в облаке, и на компьютере)
Положи в проект файл `.claude/settings.json` (или допиши в существующий):
```json
{
  "extraKnownMarketplaces": {
    "instruments": { "source": { "source": "github", "repo": "stelzxnoob-ops/Instruments" } }
  },
  "enabledPlugins": { "instruments@instruments": true }
}
```
и закоммить. Либо сделай это скриптом: `bash install.sh ~/путь/к/проекту`.
Дальше любая сессия Claude Code в этом проекте (облачная тоже) подтянет плагин сама.
На компьютере Claude Code один раз спросит, доверять ли маркетплейсу — ответь «да».

## Для всех проектов на своём компьютере
```
/plugin install instruments --marketplace stelzxnoob-ops/Instruments
```
или `bash install.sh` (без аргументов). Обновить: `/plugin marketplace update instruments`.

## Работа в самом этом репозитории
`.claude/skills/*` — ссылки на скиллы плагина, так что они работают и здесь.
Новый скилл клади в `plugins/instruments/skills/<имя>/SKILL.md` и подними `version`
в `plugins/instruments/.claude-plugin/plugin.json`, чтобы проекты получили обновление.
