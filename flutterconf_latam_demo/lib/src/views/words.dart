// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:english_words/english_words.dart' as words;
import 'package:flutter/material.dart';

/// Renders a scrollable list of random words.
class WordList extends StatefulWidget {
  const WordList({ super.key });

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _names = <String>[];

  @override
  void initState() {
    _names.addAll(_getRandomWords(2));
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
        title: Text('${_names.length} Word List (id#${View.of(context).viewId})'),
      ),
      body: _names.isNotEmpty
          ? Scrollbar(
              controller: _scrollController,
              child: ListView.separated(
                controller: _scrollController,
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
