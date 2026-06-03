import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData(useMaterial3: true),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = "";
  String hasil = "0";

  void tekanTombol(String value) {
    setState(() {
      input += value;
    });
  }

  void clear() {
    setState(() {
      input = "";
      hasil = "0";
    });
  }

  void hitung() {
    try {
      String ekspresi = input.replaceAll('×', '*').replaceAll('÷', '/');

      List<String> angka = [];
      List<String> operator = [];

      String temp = "";

      for (int i = 0; i < ekspresi.length; i++) {
        String c = ekspresi[i];

        if ("+-*/".contains(c)) {
          angka.add(temp);
          operator.add(c);
          temp = "";
        } else {
          temp += c;
        }
      }

      angka.add(temp);

      double hasilAkhir = double.parse(angka[0]);

      for (int i = 0; i < operator.length; i++) {
        double nilai = double.parse(angka[i + 1]);

        switch (operator[i]) {
          case "+":
            hasilAkhir += nilai;
            break;
          case "-":
            hasilAkhir -= nilai;
            break;
          case "*":
            hasilAkhir *= nilai;
            break;
          case "/":
            hasilAkhir /= nilai;
            break;
        }
      }

      setState(() {
        hasil = hasilAkhir % 1 == 0
            ? hasilAkhir.toInt().toString()
            : hasilAkhir.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        hasil = "Error";
      });
    }
  }

  Widget tombol(String text, {Color color = Colors.blueAccent}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: () {
            if (text == "=") {
              hitung();
            } else if (text == "C") {
              clear();
            } else {
              tekanTombol(text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            minimumSize: const Size(70, 70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget baris(List<Widget> children) {
    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Simple Calculator"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 14, 15, 80),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    input.isEmpty ? "0" : input,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hasil,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            baris([
              tombol("7"),
              tombol("8"),
              tombol("9"),
              tombol("÷", color: Colors.orange),
            ]),
            baris([
              tombol("4"),
              tombol("5"),
              tombol("6"),
              tombol("×", color: Colors.orange),
            ]),
            baris([
              tombol("1"),
              tombol("2"),
              tombol("3"),
              tombol("-", color: Colors.orange),
            ]),
            baris([
              tombol("0"),
              tombol("."),
              tombol("=", color: Colors.green),
              tombol("+", color: Colors.orange),
            ]),
            baris([tombol("C", color: Colors.red)]),
          ],
        ),
      ),
    );
  }
}
