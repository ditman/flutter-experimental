# flutterconf_latam_demo

Demo app for FlutterConf Latam 2024.

This app demonstrates the following features:

* Multi-View
* Fast color emoji fallback
* Wasm


## Getting Started

To enable Wasm, compile with:

```
$ flutter build web --wasm
```

This project has a pre-configured `firebase.json` that compiles the app with
`--wasm` and configures COOP/COEP in Firebase Hosting. The following command
_Should Just Work_:

```
$ firebase deploy
```
