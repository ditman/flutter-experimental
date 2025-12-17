import 'package:flutter/material.dart';

import 'package:genui/genui.dart';
import 'package:genui_google_generative_ai/genui_google_generative_ai.dart';

import 'package:logging/logging.dart';

final String systemInstruction = '''
You are an experienced storyteller. You're telling a story to a child, where the
child is between 7 and 12 years old.

The first page of the story should present the child with several options for a
story to tell; the child should pick the setting from one of the options. The
options should be related to popular anime shows, movies or books. Present at
least 10 initial options for the setting of the story.

The story has parts of narration, and at key moments, the child will have to
make a decision on what to do next. The child's decisions will affect the 
story's outcome. The child's decisions are limited to two choices on each pause,
and the child will click on a button to make their decision. The child's
decisions are not reversible and will continue the story forward.

Every time the child makes a decision, the earlier text of the story should
remain visible, with "chapter markers" for each of the answers picked, so it can
be revisited, but not changed.

Each story decision should have a difficulty level between 1 and 20. When the
child makes a choice, roll a 20 sided die. If the roll is greater than or equal
to the difficulty level, the selection is successful and the story continues. If
the roll is less than the difficulty level, the selection is not successful and
the story needs to continue as if the choice had failed in the story.

After 10 decisions, the story should end.

When the story ends, give the option to start from the beginning.
''';

// Get your own Gemini API key on https://aistudio.google.com/api-keys
final String apiKey = '';

// This only uses the default catalog, so the manager and the content generation
// can be finals here
final _genUiManager = GenUiManager(catalog: CoreCatalogItems.asCatalog());

final _contentGenerator = GoogleGenerativeAiContentGenerator(
  catalog: CoreCatalogItems.asCatalog(),
  systemInstruction: systemInstruction,
  modelName:
      // 'models/gemini-2.5-flash-lite', // -lite didn't work well for me
      // 'models/gemini-2.5-flash', // -flash works fairly well!
      'models/gemini-3-pro-preview', // TODO: Add an enum encapsulating these names?
  apiKey: apiKey,
);

final logger = configureGenUiLogging(level: Level.ALL);

void main() {
  logger.onRecord.listen((record) {
    debugPrint('${record.loggerName}: ${record.message}');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yarn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _surfaceIds = <String>[];

  /// This handles our conversation with the LLM.
  late GenUiConversation conversation;

  @override
  void initState() {
    super.initState();
    conversation = GenUiConversation(
      genUiManager: _genUiManager,
      contentGenerator: _contentGenerator,
      onSurfaceAdded: _onSurfaceAdded,
      onSurfaceDeleted: _onSurfaceDeleted,
    );
    // Kickstart the conversation without user interaction
    conversation.sendRequest(UserMessage.text(''));
  }

  @override
  void dispose() {
    conversation.dispose();
    super.dispose();
  }

  void _onSurfaceAdded(SurfaceAdded update) {
    setState(() {
      _surfaceIds.add(update.surfaceId);
    });
  }
  void _onSurfaceDeleted(SurfaceRemoved update) {
    setState(() {
      _surfaceIds.remove(update.surfaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Yarn'),
      ),
      body: Center(
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _surfaceIds.length,
          itemBuilder: (context, index) {
            // For each surface, create a GenUiSurface to display it.
            final id = _surfaceIds[index];
            return GenUiSurface(host: conversation.host, surfaceId: id);
          },
        ),
      ),
    );
  }
}
