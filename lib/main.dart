import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _guessedNumber = TextEditingController();
  static Random randomizer = new Random();
  int randomNumber = randomizer.nextInt(100);
  bool _isVisible = false;
  String _guessingText = '';
  String _buttonText = 'Guess';

  _checkTheNumber() {
    int inputNumber = int.parse(_guessedNumber.text);
    setState(() {
      if (inputNumber != 0) {
        _isVisible = true;
        if (inputNumber < randomNumber) {
          _guessingText = 'You tried $inputNumber\n Try higher!';
          _guessedNumber.clear();
        } else if (inputNumber > randomNumber) {
          _guessingText = 'You tried $inputNumber\n Try lower!';
          _guessedNumber.clear();
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Congratulations"),
                  content: Text("You guessed the number"),
                  actions: [
                    TextButton(
                      child: Text("Retry"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _guessingText = "";
                        _guessedNumber.clear();
                        randomNumber = randomizer.nextInt(100);
                        setState(() {});
                      },
                    ),
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _buttonText = "Reset";
                        setState(() {});
                      },
                    ),
                  ],
                );
              });
        }
      }
    });
  }

  _handleReset() {
    setState(() {
      if (_buttonText == "Reset") {
        _guessingText = "";
        _guessedNumber.clear();
        randomNumber = randomizer.nextInt(100);
        _buttonText = "Guess";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Guess My Number"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'I\'m thinking of a number between 1 and 100.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'It\'s your turn to guess my number!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            Visibility(
              visible: _isVisible,
              child: Text(
                _guessingText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 10.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Try a number!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.grey,
                        ),
                      ),
                      TextField(
                        controller: _guessedNumber,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                        ],
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                          onPressed: () => _guessedNumber.clear(),
                          icon: Icon(Icons.clear),
                        )),
                      ),
                      ElevatedButton(
                        child: Text(_buttonText),
                        onPressed: () {
                          if (_buttonText == "Reset") {
                            _handleReset();
                          }
                          _checkTheNumber();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
