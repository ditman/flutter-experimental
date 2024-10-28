// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

final EmojiParser _emojiParser = EmojiParser();

/// Renders a random emoji with it name
class BigEmoji extends StatefulWidget {
  const BigEmoji({ super.key });

  @override
  State<BigEmoji> createState() => _BigEmojiState();
}

class _BigEmojiState extends State<BigEmoji> {
  late List<int> emojiRunes;
  late Emoji emoji;

  @override
  void initState() {
    super.initState();
    _updateEmoji();
  }

  void _updateEmoji() {
    // My _getRandomEmoji method sucks, and some times generates Emoji.None.
    // Loop it until we get a next valid (and different) emoji :)
    do {
      emojiRunes = _getRandomEmoji();
      emoji = _emojiParser.getEmoji(String.fromCharCodes(emojiRunes));
    } while (emoji == Emoji.None);
  }

  List<int> _getRandomEmoji() {
    // TODO: Ensure this generates a valid emoji sequence.
    // See: https://unicode.org/Public/emoji/16.0/emoji-sequences.txt
    return [Random().nextInt(0xFF) + 0x1F300];
  }

  void _changeEmoji() {
    setState(_updateEmoji);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Emoji (id#${View.of(context).viewId})'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji.code,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(emoji.name),
            Text(
              emojiRunes.map((int code) => '0x' + code.toRadixString(16).padLeft(4, '0')).join(', '),
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeEmoji,
        tooltip: 'Randomize',
        child: const Icon(Icons.recycling),
      ),
    );
  }
}