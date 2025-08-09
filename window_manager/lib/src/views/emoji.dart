// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

final EmojiParser _emojiParser = EmojiParser();

/// Renders a random emoji with its name.
class BigEmoji extends StatefulWidget {
  const BigEmoji({super.key});

  @override
  State<BigEmoji> createState() => _BigEmojiState();
}

class _BigEmojiState extends State<BigEmoji> {
  late Emoji _emoji;

  // Remove 0xFE0F from _emoji.code
  String get _cleanEmojiCode => EmojiUtil.stripNSM(_emoji.code)!;

  @override
  void initState() {
    super.initState();
    _updateEmoji();
  }

  void _updateEmoji() {
    // My _getRandomEmoji method is not great. Some times it generates `Emoji.None`.
    // Loop until we get a valid (and different) emoji :)
    int attempts = 0;
    do {
      _emoji = _emojiParser.getEmoji(String.fromCharCodes(_getRandomEmoji()));
      attempts++;
    } while (_emoji == Emoji.None);
    // Let's see how bad it is :)
    if (kDebugMode && attempts > 10) {
      print('Emoji found in ${attempts} attempts.');
    }
  }

  List<int> _getRandomEmoji() {
    // See: https://unicode.org/Public/emoji/16.0/emoji-sequences.txt
    return [Random().nextInt(0x3FF) + 0x1F300];
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
              _cleanEmojiCode,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(_emoji.name),
            Text(
              _cleanEmojiCode.codeUnits
                  .map((int code) =>
                      '0x' + code.toRadixString(16).padLeft(4, '0'))
                  .join(', '),
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
