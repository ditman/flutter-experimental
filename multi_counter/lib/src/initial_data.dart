// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:ui_web' as ui_web;


// The JS-interop definition of the `initialData` object passed to the views of this app.
@JS()
@staticInterop
class InitialData {
  /// A static accessor to retrieve `initialData` from `ui_web` for [viewId].
  static InitialData? forView(int viewId) {
    return ui_web.views.getInitialData(viewId) as InitialData?;
  }
}

/// The attributes of the [InitialData] object.
extension InitialDataExtension on InitialData {
  external int get randomInt;
  external String? get randomUUID;

  @JS('decimals')
  external JSArray<JSNumber> get _decimals;
  List<double> get decimals => _decimals.toDart.map((JSNumber e) => e.toDartDouble).toList();

  Object? get toDart => (this as JSAny).dartify();
}
