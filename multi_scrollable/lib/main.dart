// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'src/multiview.dart';

const List<String> _lipsum = <String>[
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris luctus pharetra lacinia. Aenean euismod sed ligula ut aliquet. Curabitur tempus sagittis ex vel laoreet. Aliquam in posuere lacus, porttitor varius massa. Vivamus id libero at nunc feugiat tempor eget quis elit. Pellentesque non eleifend mauris. Maecenas semper vulputate quam, ac ultrices nisl sagittis sit amet. Duis finibus maximus ultricies. Vestibulum sit amet tempus augue.',
  'Duis semper at orci ut ullamcorper. In eleifend fermentum ex, non imperdiet metus convallis ac. Praesent vel risus eget diam viverra dapibus. Aliquam nec elementum quam. Nunc ornare est nec lacus fringilla, id pharetra orci condimentum. Sed ac ornare ex. In arcu elit, faucibus ac sapien sit amet, gravida malesuada dui. Nullam dignissim mi in dolor consectetur, vestibulum luctus enim condimentum. Nulla facilisi. Vivamus magna eros, accumsan vitae convallis in, bibendum sit amet augue. Cras semper dolor quis ex sagittis volutpat. Donec vehicula risus in justo eleifend, et finibus lectus commodo. Nam at felis elit. Etiam vel porttitor quam, ac tristique velit.',
  'Praesent est est, viverra varius tortor et, porta aliquam nisl. Aenean quis tortor scelerisque metus cursus dapibus ac at velit. Aliquam in elementum quam. Nullam nec ligula et urna aliquet fringilla. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus pretium sapien tempor semper mollis. Duis sagittis lectus lectus, a consectetur turpis feugiat sed. Suspendisse quis metus tellus. Aenean vitae pulvinar erat. Donec efficitur consectetur enim, a bibendum lectus tincidunt in. Nullam accumsan, neque a porttitor vulputate, erat ligula vehicula tellus, ut aliquam nisl mi nec nisi. Fusce non semper massa. Duis vel sem ipsum. Aliquam accumsan justo in lacus porta porttitor.',
  'Sed elit tortor, dignissim ut tellus quis, convallis egestas neque. Cras quis ornare nulla. Mauris molestie faucibus sapien at porttitor. Aenean dignissim risus at enim egestas, ac commodo elit luctus. Praesent libero leo, condimentum a pretium bibendum, vestibulum quis elit. Nullam ut venenatis risus. Praesent nec lacus velit. Donec sed tellus commodo, faucibus odio ut, tincidunt sem. Praesent luctus magna a mollis fermentum. In eu nisi augue. Aenean non purus ac nisi tristique pulvinar. Duis nibh leo, sollicitudin vitae neque non, faucibus facilisis nunc.',
  'Sed neque nisl, vehicula nec imperdiet vitae, mollis nec quam. Phasellus in cursus tellus. Duis quis orci tempus, tempor dui vel, mattis lectus. Nullam non nibh quis velit interdum euismod quis sed lorem. Maecenas ac porta velit, at fermentum diam. Pellentesque faucibus faucibus risus, interdum euismod justo tempus sit amet. Phasellus ac quam rhoncus, gravida ex eu, maximus nisl. Aliquam finibus purus et hendrerit efficitur. Vivamus sit amet placerat nisi. Donec id augue ut urna tempus volutpat. Nulla sed tempus ligula, in lacinia arcu. Donec vestibulum, nunc congue rutrum porttitor, nulla nunc ultricies dolor, quis placerat magna justo sed nisi.',
];

final List<Color> colors = List.from(Colors.primaries)..shuffle();

void main() {
  runWidget(MultiViewApp(
    viewBuilder: (BuildContext context) => const Counter(),
  ));
}

class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    final int viewId = View.of(context).viewId;
    return MaterialApp(
      title: 'Multi-scrollable Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colors[viewId%colors.length]),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'HTML Scrollable #$viewId'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: HtmlElementView.fromTagName(
                tagName: 'div',
                onElementCreated:(Object e) => _fillWithLipsum(
                  e, 
                  colors.primaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fillWithLipsum(Object element, Color bg) {
    element as web.HTMLDivElement;
    element.style
      ..backgroundColor = bg.toCss()
      ..overflow = 'auto';
    element.append(web.HTMLHeadingElement.h3()..innerText = 'This is HTML text!');
    _lipsum
        .map((String line) => web.HTMLParagraphElement()..innerText=line,)
        .forEach((web.HTMLParagraphElement p) => element.append(p));
  }
}

extension on Color {
  String toCss() => 'rgba($red,$green,$blue,${(alpha/255.0).toStringAsFixed(1)})';
}
