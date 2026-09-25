/// Keeps the default hash URL strategy (`example.ir/#/info`).
///
/// A hash fragment is never sent to the server, so any static host — even
/// one with no SPA fallback configured, like a bare `http.server` — can
/// serve a deep link correctly: every request resolves to `/`, and Flutter
/// reads the route out of the fragment once it boots.
void configureUrlStrategy() {}
