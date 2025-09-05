// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'src/js_interop/initial_data.dart';
import 'src/multiview.dart';
import 'src/views.dart';

/// A randomized list of primary colors.
final List<Color> colors = List.from(Colors.primaries)..shuffle();

void main() {
  runWidget(MultiViewApp(
    viewBuilder: (BuildContext context) => const ViewSelector(),
  ));
}

/// Selects the appropriate app to render in each flutter view.
///
/// (This doesn't need to be a widget, it can be a `viewBuilder` method.)
class ViewSelector extends StatelessWidget {
  const ViewSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final int viewId = View.of(context).viewId;
    final InitialData? data = InitialData.forView(viewId);

    assert(data != null, 'initialData must not be null (on this app)!');

    return MaterialApp(
      title: 'Flutter Apps',
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: colors[viewId % colors.length])),
      home: switch (data!.viewType) {
        ViewType.counter => Counter(data: data as CounterInitialData),
        ViewType.list => WordList(),
        ViewType.emoji => BigEmoji(),
        ViewType.warmup => Warmup(),
      },
    );
  }
}
