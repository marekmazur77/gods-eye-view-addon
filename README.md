# God's Eye View - Home Assistant Add-on

A Home Assistant add-on wrapping [the God's Eye View open-source project](https://github.com/bilawalsidhu/gods-eye-view): a photorealistic 3D globe with live flights, ships, satellites, earthquakes, traffic, active fires and public cameras, built from public open data.

## What it needs

- A **Google Maps API key** (required) - enables the Map Tiles API for the photograph real 3D tiles. This key is browser-visible by design, so **restrict it** (API restriction = Map Tiles API only; HTTP referrer restriction = your HA/Cloudflare hostname) and set a **budget + quota**.
- Optional free keys (only if you want those layers): OpenAI (voice), AISStream (ships), NASA FIRMS (fires), TomTom (traffic), Cesium ion (Bing imagery).

## Install

1. Add this repository in Home Assistant: **Settings → Add-ons → Add-on stores → ⋮ → Repositories** → `https://github.com/marekmazur77/gods-eye-view-addon`.
2. Find **God's Eye View** → **Install**.
3. Open its **Configuration** tab, paste your **Google Maps API key**, then **(Save)**.
4. **Start** the add-on.
5. Open the panel from the sidebar (or **Open Web UI**).

## Notes

- Runs the app's Vite **dev server** (the upstream API proxies live in `vite.config.js`), exposed via HA ingress on port 5173.
- Non-Google keys are server-side only; Google Maps key is client-exposed by design.
- Be aware: if you expose HA beyond localhost (e.g. Cloudflare), the app brokers any configured server-side keys to whoever can reach it. Leave the optional keys empty unless you need them, and consider the app's per-IP rate limits.
- This is an exploratory visualization of public data - not for navigation or safety-critical use.

## License

The app is MIT-licensed. See the upstream project for its data source terms.
