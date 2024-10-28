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

  @JS('viewType')
  external JSString get _viewType;
}

/// The JS-interop for the Counter screen, which may include an additional random UUID.
extension type CounterInitialData._(InitialData _) implements InitialData {
  @JS('randomUUID')
  external JSString? get _randomUUID;
}

/// Translate [InitialData]'s getters to Dart types.
extension InitialDataDartGetters on InitialData {
  /// The view type to render.
  ViewType get viewType => ViewType.values.byName(_viewType.toDart);

  /// Returns a [Map]-like version of this object.
  Object? get toDart => dartify();
}

extension CounterInitialDataGetters on CounterInitialData {
  /// The `randomUUID` property as [String].
  String? get randomUUID => _randomUUID?.toDart;
}

/// The types of views that can be requested from JavaScript.
enum ViewType {
  counter('counter'),
  emoji('emoji'),
  list('list');

  const ViewType(String viewType) : _viewType = viewType;
  final String _viewType;

  @override
  String toString() => _viewType;
}
