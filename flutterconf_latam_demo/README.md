# flutterconf_latam_demo

Demo app for FlutterConf Latam 2024.

This app demonstrates the following features:

* Multi-View
* Fast color emoji fallback
* Wasm


## Getting Started

To enable Wasm, compile with:

```
flutter build web --wasm
```

Check the `firebase.json` file that enables COOP/COEP headers for Wasm GC when
deploying to Firebase Hosting.
