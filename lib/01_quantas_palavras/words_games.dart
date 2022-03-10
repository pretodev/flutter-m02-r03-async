import 'package:flutter/material.dart';

class WordsGamesApp extends StatelessWidget {
  const WordsGamesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WordsGameScreen(),
    );
  }
}

class WordsGameScreen extends StatefulWidget {
  const WordsGameScreen({Key? key}) : super(key: key);

  @override
  State<WordsGameScreen> createState() => _WordsGameScreenState();
}

class _WordsGameScreenState extends State<WordsGameScreen> {
  var gameRunning = false;
  var timerSeconds = 30;
  var countWord = 3;

  var inputWord = '';

  final wordController = TextEditingController();

  final words = [
    "esquilo",
    "caricatura",
    "felino",
    "bruxa",
    "elefante",
    "gasolina",
    "orbita",
    "cornija",
    "barreira",
    "esportes",
  ];

  void starGame() async {
    setState(() {
      gameRunning = true;
      timerSeconds = 30;
      countWord = 3;
    });
    for (var i = timerSeconds; i > 0; i--) {
      if (countWord == 0) break;
      setState(() => timerSeconds = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() => gameRunning = false);
  }

  void sendWord() {
    final messenger = ScaffoldMessenger.of(context);
    final word = wordController.text;
    final hasWord = words.contains(word.toLowerCase());

    wordController.clear();

    if (!hasWord) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Palavra incorreta'),
          duration: Duration(milliseconds: 500),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Palavra encontrada'),
        duration: Duration(milliseconds: 500),
      ),
    );

    countWord -= 1;

    if (countWord == 0) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('Você encontrou as três palavras.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = gameRunning ? '00:$timerSeconds' : 'Quantas Palavras?';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: wordController,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              child: const Text('Enviar'),
              onPressed: gameRunning ? sendWord : null,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              child: const Text('Start game'),
              onPressed: !gameRunning ? starGame : null,
            ),
          ],
        ),
      ),
    );
  }
}
