// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
@JS()

import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

/// The JS-interop definition for the `initialData` object passed
/// to the views of this app.
extension type InitialData._(JSObject _) implements JSObject {
  /// Retrieve `initialData` from `ui_web` for [viewId].
  static InitialData? forView(int viewId) {
    return ui_web.views.getInitialData(viewId) as InitialData?;
  }

  @JS('randomInt')
  external JSNumber get _randomInt;
  @JS('randomUUID')
  external JSString get _randomUUID;
  @JS('decimals')
  external JSArray<JSNumber> get _decimals;
}

/// Translate [InitialData]'s getters to Dart types.
extension InitialDataDartGetters on InitialData {
  /// The `randomInt` property as an [int].
  int get randomInt => _randomInt.toDartInt;

  /// The `randomUUID` property as [String].
  String get randomUUID => _randomUUID.toDart;

  /// The `decimals` array as [List] of [double].
  List<double> get decimals =>
      _decimals.toDart.map((JSNumber e) => e.toDartDouble).toList();

  /// Returns a [Map]-like version of this object.
  Object? get toDart => dartify();
}
