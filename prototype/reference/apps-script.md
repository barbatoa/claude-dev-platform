# Guide: Apps Script migration
| Apps Script | Prototype stack |
|---|---|
| HTML Service UI | React feature in `web/src/features/` |
| `google.script.run` | generated API client call |
| `.gs` server code | Python route or job |
| `UrlFetchApp` | `httpx` |
| Time triggers | Cloud Scheduler + Cloud Run Job |
| `PropertiesService` | Secret Manager |
| Sheet as database | Postgres via one-time import script |

Approach: sync the Sheet into Postgres while Apps Script keeps running → reach parity → switch → retire the Sheet.
