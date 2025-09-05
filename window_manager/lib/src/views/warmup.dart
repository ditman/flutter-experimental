// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';

/// A minimal view used to ensure the app, and framework, warm up ASAP.
///
/// This is triggered by the JS code as soon as the engine starts, to ensure
/// the framework is fully ready by the time the user interacts with the page.
class Warmup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFABADA),
    );
  }
}
