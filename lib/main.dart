import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color the Number',
      home: RandomNumbersScreen(),
    );
  }
}

class RandomNumbersScreen extends StatefulWidget {
  @override
  _RandomNumbersScreenState createState() => _RandomNumbersScreenState();
}

class _RandomNumbersScreenState extends State<RandomNumbersScreen> {
  String numbers = '';
  Color activeColor = Colors.black;
  Map<int, Color> colorMap = {};

  @override
  void initState() {
    super.initState();
    numbers = generateRandomNumbers(100);
    loadActiveColor();
  }

  String generateRandomNumbers(int length) {
    return List.generate(length, (index) => Random().nextInt(10).toString())
        .join();
  }

  void loadActiveColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('color') ?? Colors.black.value;
    setState(() {
      activeColor = Color(colorValue);
    });
  }

  void saveActiveColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color', color.value);
  }

  void toggleColor(int index) {
    setState(() {
      if (colorMap[index] == activeColor) {
        // Jika warna saat ini adalah hitam, ubah menjadi putih
        colorMap[index] = Colors.white;
      } else if (colorMap[index] == Colors.black) {
        // Jika warna saat ini adalah hitam, ubah menjadi warna aktif
        colorMap[index] = activeColor;
      } else {
        // Jika warna saat ini bukan hitam, ubah sesuai warna aktif
        colorMap[index] = activeColor;
      }
    });
  }

  void checkAnswer() {
    // Logic to check if the correct numbers are colored
    // For demonstration, just print out the result
    bool correct = true;
    for (var i = 0; i < numbers.length; i++) {
      if (numbers[i] == '3' && colorMap[i] != Colors.green) {
        correct = false;
        break;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(correct ? "Benar" : "Salah"),
          content: Text(correct ? "Selamat!" : "Salah, Coba Lagi!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ...List<Widget>.generate(5, (int index) {
                  List<Color> colors = [
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.brown,
                    Colors.orange
                  ];
                  return ToggleButtons(
                    children: <Widget>[
                      Icon(Icons.circle, color: colors[index], size: 60,),
                    ],
                    onPressed: (int buttonIndex) {
                      setState(() {
                        activeColor = colors[index];
                        saveActiveColor(activeColor);
                      });
                    },
                    isSelected: [activeColor == colors[index]],
                  );
                }),
              ],
            ),
            Expanded( // Wrap the Column in Expanded
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text('Warnai angka 3 dengan warna hijau.', style: TextStyle(fontSize: 25),),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: List<Widget>.generate(numbers.length, (int index) {
                        return GestureDetector(
                          onTap: () => setState(() {
                            toggleColor(index);
                          }),
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            color: colorMap[index] ?? Colors.white,
                            child: Center(
                              child: Text(numbers[index],
                                  style: TextStyle(color: Colors.black, fontSize: 28),),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      checkAnswer();
                    },
                    child: Text('SELESAI'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
