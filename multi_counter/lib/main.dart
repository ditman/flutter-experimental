import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Multi-counter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colors[viewId%colors.length]),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Counter View $viewId'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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