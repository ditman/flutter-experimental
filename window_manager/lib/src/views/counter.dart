// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';

import '../js_interop/initial_data.dart';

/// Renders the classic Flutter counter (with some extra data coming from JS).
class Counter extends StatefulWidget {
  const Counter({super.key, this.data});

  final CounterInitialData? data;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    print('Initial data: ${widget.data?.toDart}');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String uuidFromJs =
        widget.data?.randomUUID ?? 'null (Browser crypto not available?)';

    final TextStyle? tiny = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
        );
    final TextStyle? tinyBold = tiny?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Counter (id#${View.of(context).viewId})'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('RandomUUID from JS (initialData):', style: tiny),
            Padding(
              padding: const EdgeInsets.only(bottom: 50), // Clear the FAB.
              child: Text(uuidFromJs, style: tinyBold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
