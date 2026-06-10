import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: CalculatorPage()),
);

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = "";
  String hasil = "";
  List<String> riwayat = [];

  void tekanTombol(String value) {
    setState(() {
      // Input dibatasi hingga 10 digit agar tetap dalam rentang miliaran
      if (input.length < 10 || "+-*/()".contains(value)) {
        input += value;
      }
    });
  }

  void hitung() {
    try {
      // Mengganti simbol agar dipahami parser
      String ekspresi = input.replaceAll('×', '*').replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(ekspresi);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        // Format desimal: 5 angka di belakang, hapus nol berlebih, ubah . jadi ,
        String res = eval.toStringAsFixed(5);
        res = res.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
        res = res.replaceAll('.', ',');

        hasil = res;
        riwayat.insert(0, "$input = $res");
        if (riwayat.length > 5) riwayat.removeLast();
      });
    } catch (e) {
      setState(() => hasil = "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kalkulator", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Area Riwayat
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: riwayat.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(
                  riwayat[i],
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          // Area Tampilan Input & Hasil
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(input, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 10),
                Text(
                  hasil.isEmpty ? "" : "= $hasil",
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
          _buildKeypad(),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        rowTombol(
          ["(", ")", "⌫", "C"],
          [Colors.blue, Colors.blue, Colors.red, Colors.red],
        ),
        rowTombol(["7", "8", "9", "÷"], [null, null, null, Colors.blue]),
        rowTombol(["4", "5", "6", "×"], [null, null, null, Colors.blue]),
        rowTombol(["1", "2", "3", "-"], [null, null, null, Colors.blue]),
        rowTombol(
          ["0", ".", "=", "+"],
          [null, null, Colors.orange, Colors.blue],
        ),
      ],
    );
  }

  Widget rowTombol(List<String> teks, List<Color?> warna) {
    return Row(
      children: List.generate(teks.length, (i) => tombol(teks[i], warna[i])),
    );
  }

  Widget tombol(String text, Color? color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFFEEEEEE),
            foregroundColor: color == null ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (text == "=")
              hitung();
            else if (text == "C")
              setState(() {
                input = "";
                hasil = "";
              });
            else if (text == "⌫")
              setState(() {
                if (input.isNotEmpty)
                  input = input.substring(0, input.length - 1);
              });
            else
              tekanTombol(text);
          },
          child: Text(
            text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
