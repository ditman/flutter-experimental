// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:js_interop';

// The JS-interop definition of the `initialData` object passed to the views of this app.
@JS()
@staticInterop
class InitialData {}

/// The attributes of the [InitialData] object.
extension InitialDataExtension on InitialData {
  external int get randomInt;
  external String? get randomUUID;

  @JS('decimals')
  external JSArray<JSNumber> get _decimals;
  List<double> get decimals => _decimals.toDart.map((JSNumber e) => e.toDartDouble).toList();
}
