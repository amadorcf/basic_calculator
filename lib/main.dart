import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculadoraHomePage(),
    );
  }
}

class CalculadoraHomePage extends StatefulWidget {
  @override
  _CalculadoraHomePageState createState() => _CalculadoraHomePageState();
}

class _CalculadoraHomePageState extends State<CalculadoraHomePage> {
  String _display = "";
  String _operation = "";
  double? _firstOperand;
  double? _secondOperand;
  final List<String> _history = [];

  void _inputDigit(String digit) {
    setState(() {
      _display += digit;
    });
  }

  void _clear() {
    setState(() {
      _display = "";
      _operation = "";
      _firstOperand = null;
      _secondOperand = null;
    });
  }

  void _setOperation(String operation) {
    setState(() {
      if (_display.isNotEmpty) {
        _firstOperand = double.tryParse(_display);
        _display = "";
        _operation = operation;
      }
    });
  }

  void _calculate() {
    setState(() {
      if (_display.isNotEmpty && _firstOperand != null) {
        _secondOperand = double.tryParse(_display);
        if (_secondOperand != null) {
          String result;
          switch (_operation) {
            case "+":
              result = (_firstOperand! + _secondOperand!).toString();
              break;
            case "-":
              result = (_firstOperand! - _secondOperand!).toString();
              break;
            case "*":
              result = (_firstOperand! * _secondOperand!).toString();
              break;
            case "/":
              result = _secondOperand != 0
                  ? (_firstOperand! / _secondOperand!).toString()
                  : "Error";
              break;
            default:
              result = "Error";
          }
          _history.insert(0, "$_firstOperand $_operation $_secondOperand = $result");
          _display = result;
          _firstOperand = null;  // Limpia los operandos
          _secondOperand = null;
          _operation = "";  // Limpia la operación
        }
      }
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
      _display = "";
      _operation = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          SizedBox(height: 10),
          Column(
            children: [
              _buildButtonRow(["7", "8", "9", "/"]),
              SizedBox(height: 5),
              _buildButtonRow(["4", "5", "6", "*"]),
              SizedBox(height: 5),
              _buildButtonRow(["1", "2", "3", "-"]),
              SizedBox(height: 5),
              _buildButtonRow(["C", "0", "=", "+"]),
            ],
          ),
          SizedBox(height: 20),
          if (_history.isNotEmpty) ...[
            Divider(),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_history[index]),
                  );
                },
              ),
            ),
          ],
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _clearHistory,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
            ),
            child: Text(
              "Borrar Historial",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((btn) {
        return ElevatedButton(
          onPressed: () {
            if (btn == "C") {
              _clear();
            } else if (btn == "=") {
              _calculate();
            } else if ("+-*/".contains(btn)) {
              _setOperation(btn);
            } else {
              _inputDigit(btn);
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(80, 80),
            shape: CircleBorder(),
          ),
                    child: Text(
            btn,
            style: TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
    );
  }
}
