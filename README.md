# instruments

Инструменты, скиллы и материалы, общие для всех проектов. Код ботов здесь не лежит,
бот магазина живёт в репозитории `Vintyi`.

Репозиторий — это **маркетплейс плагинов Claude Code** `instruments`. В нём три плагина:

| Плагин | Что делает |
|---|---|
| `instruments` | наши скиллы token-saver и graphify + хуки graphify (см. ниже) |
| `ponytail` | режим «ленивого сеньора»: самое простое решение, без лишнего кода ([DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)) |
| `agent-skills` | инженерные скиллы от спеки до релиза: TDD, ревью, отладка, безопасность ([addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)) |

Чужие плагины берутся прямо из их репозиториев на GitHub, поэтому всегда свежие.

## Что внутри
- `plugins/instruments/` — наш плагин:
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
  "enabledPlugins": {
    "instruments@instruments": true,
    "ponytail@instruments": true,
    "agent-skills@instruments": true
  }
}
```
и закоммить. Либо сделай это скриптом: `bash install.sh ~/путь/к/проекту`.
Ненужный плагин просто убери из `enabledPlugins`. Дальше любая сессия Claude Code в этом проекте (облачная тоже) подтянет плагин сама.
На компьютере Claude Code один раз спросит, доверять ли маркетплейсу — ответь «да».

## Для всех проектов на своём компьютере
```
/plugin marketplace add stelzxnoob-ops/Instruments
/plugin install instruments@instruments
/plugin install ponytail@instruments
/plugin install agent-skills@instruments
```
или `bash install.sh` (без аргументов). Обновить: `/plugin marketplace update instruments`.

## OmniRoute
`npx omniroute` — это отдельный локальный сервер-роутер для AI-провайдеров, а не плагин.
Его запускают на своём компьютере (нужен Node.js): `npx omniroute`. В облачной сессии он не нужен.

## Работа в самом этом репозитории
`.claude/skills/*` — ссылки на скиллы плагина, так что они работают и здесь.
Новый скилл клади в `plugins/instruments/skills/<имя>/SKILL.md` и подними `version`
в `plugins/instruments/.claude-plugin/plugin.json`, чтобы проекты получили обновление.
