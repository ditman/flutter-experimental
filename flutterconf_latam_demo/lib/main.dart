// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'src/initial_data.dart';
import 'src/multiview.dart';
import 'src/views/counter.dart';
import 'src/views/emoji.dart';
import 'src/views/words.dart';

final List<Color> colors = List.from(Colors.primaries)..shuffle();

void main() {
  runWidget(MultiViewApp(
    viewBuilder: (BuildContext context) => const ViewSelector(),
  ));
}

class ViewSelector extends StatelessWidget {
  const ViewSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final int viewId = View.of(context).viewId;
    final InitialData? data = InitialData.forView(viewId);

    assert(data != null, 'initialData must not be null (on this app)!');

    return MaterialApp(
      title: 'FlutterConf Latam Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: colors[viewId % colors.length])),
      home: switch (data!.viewType) {
        ViewType.counter => Counter(data: data as CounterInitialData),
        ViewType.list => WordList(),
        ViewType.emoji => BigEmoji(),
      },
    );
  }
}
