// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'src/initial_data.dart';
import 'src/multiview.dart';

final List<Color> colors = List.from(Colors.primaries)..shuffle();

void main() {
  runAppWithoutImplicitView(MultiViewApp(
    viewBuilder: (BuildContext context) => const Counter(),
  ));
}

class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    final int viewId = View.of(context).viewId;
    final InitialData? data = InitialData.forView(viewId);
    return MaterialApp(
      title: 'Multi-counter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colors[viewId%colors.length]),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Counter View $viewId', data: data),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, this.data});

  final String title;
  final InitialData? data;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    final String uuidFromJs = widget.data?.randomUUID ?? 'null (Browser crypto not available?)';

    final TextStyle? tiny = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
    );
    final TextStyle? tinyBold = tiny?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
