# Changelog

## 0.1.0 - 2026-08-29

- Initial release. Home Assistant add-on wrapping the God's Eye View Vite dev server.
- `build: true`, arch amd64, HA ingress panel on port 5173.
- Options schema for Google Maps (required) plus optional OpenAI, AISStream, FIRMS, Cesium ion and TomTom keys.
- Dockerfile clones the app at build time; `run.sh` injects keys from add-on options and serves on `0.0.0.0:5173`.
