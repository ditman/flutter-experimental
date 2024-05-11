// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:english_words/english_words.dart' as words;
import 'package:flutter/material.dart';
import 'src/multiview.dart';

final List<Color> colors = List.from(Colors.primaries)..shuffle();

void main() {
  runWidget(MultiViewApp(
    viewBuilder: (BuildContext context) => const WordList(),
  ));
}

class WordList extends StatelessWidget {
  const WordList({super.key});

  @override
  Widget build(BuildContext context) {
    final int viewId = View.of(context).viewId;
    return MaterialApp(
      title: 'Multi-list Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: colors[viewId % colors.length]),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'List View $viewId'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController scrollController = ScrollController();
  final List<String> _names = <String>[];

  @override
  void initState() {
    _names.addAll(_getRandomWords(20));
    super.initState();
  }

  void _generateName() {
    setState(() {
      _names.addAll(_getRandomWords(1));
    });
  }

  Iterable<String> _getRandomWords(int count) {
    return words
        .generateWordPairs(safeOnly: true)
        .take(count)
        .map((pair) => pair.join(' '));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _names.isNotEmpty
          ? Scrollbar(
              controller: scrollController,
              child: ListView.separated(
                controller: scrollController,
                itemCount: _names.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) => ListTile(
                  title: Text(_names[index]),
                ),
              ),
            )
          : const Center(child: Text('empty')),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateName,
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
