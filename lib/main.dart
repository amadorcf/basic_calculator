import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Básica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculadoraHome(),
    );
  }
}

class CalculadoraHome extends StatefulWidget {
  const CalculadoraHome({super.key});

  @override
  State<CalculadoraHome> createState() => _CalculadoraHomeState();
}

class _CalculadoraHomeState extends State<CalculadoraHome> {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();
  String _resultado = "";
  final List<String> _historial = [];

  void _calcular(String operacion) {
    setState(() {
      double? num1 = double.tryParse(_num1Controller.text);
      double? num2 = double.tryParse(_num2Controller.text);

      if (num1 == null || num2 == null) {
        _resultado = "Error: Entrada inválida";
        return;
      }

      switch (operacion) {
        case '+':
          _resultado = (num1 + num2).toStringAsFixed(2);
          break;
        case '-':
          _resultado = (num1 - num2).toStringAsFixed(2);
          break;
        case '×':
          _resultado = (num1 * num2).toStringAsFixed(2);
          break;
        case '÷':
          _resultado = num2 != 0
              ? (num1 / num2).toStringAsFixed(2)
              : "Error: División por cero";
          break;
      }

      if (!_resultado.startsWith("Error")) {
        _historial.add("$num1 $operacion $num2 = $_resultado");
      }
    });
  }

  void _limpiar() {
    setState(() {
      _num1Controller.clear();
      _num2Controller.clear();
      _resultado = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora Básica"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Número 1",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Número 2",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _calcular('+'),
                  child: const Text("+"),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('-'),
                  child: const Text("-"),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('×'),
                  child: const Text("×"),
                ),
                ElevatedButton(
                  onPressed: () => _calcular('÷'),
                  child: const Text("÷"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Resultado: $_resultado",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: _historial.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_historial[index]),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _limpiar,
              child: const Text("Limpiar"),
            ),
          ],
        ),
      ),
    );
  }
}
