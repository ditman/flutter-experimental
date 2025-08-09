# window_manager

A different way of rendering the same Flutter app in the
`flutterconf_latam_demo` directory.

Instead of embedding views in a grid, it renders them in a very primitive
"window manager".

* Deployed [here](https://dit-flutter-windows.web.app).


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
