// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// See https://github.com/tugorez/flutter_focus/blob/main/lib/focusable_app.dart

import 'dart:ui' show ViewFocusState;
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class FocusableApp extends StatefulWidget {
  final Widget child;

  const FocusableApp({super.key, required this.child});

  @override
  State<FocusableApp> createState() => _FocusableAppState();
}

class _FocusableAppState extends State<FocusableApp> {
  late FocusScopeNode _focusNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();

    final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
    final PlatformDispatcher platformDispatcher = binding.platformDispatcher;
    // This has to be done otherwise Flutter assumes it has focus.
    binding.scheduleFirstFrameCheck(
      onFirstFramePainted: () => _focusNode.unfocus(),
    );
    platformDispatcher.onViewFocusChange = (ev) {
      print(ev);
      if (ev.state == ViewFocusState.focused) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: FocusScope(
        node: _focusNode,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

extension on WidgetsBinding {
  void scheduleFirstFrameCheck({required void Function() onFirstFramePainted}) {
    addPostFrameCallback((_) {
      if (sendFramesToEngine) {
        onFirstFramePainted();
      } else {
        scheduleFirstFrameCheck(onFirstFramePainted: onFirstFramePainted);
      }
    });
  }
}
