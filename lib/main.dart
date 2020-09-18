import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<List> _matrix; //declarar una matriz

  _MyHomePageState() {
    _initMatrix; //Matriz inicial en blanco
  }

  get _initMatrix {
    //obtener los valores en la matriz inicial
    _matrix = List<List>(3);
    for (var i = 0; i < _matrix.length; i++) {
      _matrix[i] = List(3);
      for (var j = 0; j < _matrix[i].length; j++) {
        _matrix[i][j] = ' ';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
        ),
        body: Center(
          child: Column(
            // declarar en forma de columna
            mainAxisAlignment:
                MainAxisAlignment.center, //alinear al centro la cuadricula
            children: [
              Row(
                //declarar una fila
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(0, 0),
                  _buildElement(0, 1),
                  _buildElement(0, 2),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(1, 0),
                  _buildElement(1, 1),
                  _buildElement(1, 2),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(2, 0),
                  _buildElement(2, 1),
                  _buildElement(2, 2),
                ],
              )
            ],
          ),
        ));
  }

  String _lastChar = 'O'; //declarar un valor como ultimo caracter
  //Funcion para la construccion de un campo en la matriz
  _buildElement(int i, int j) {
    //construir cada campo de la matriz
    return GestureDetector(
      //para detectar el toque en la pantalla touch
      onTap: () {
        _changeMatrixField(i, j); //cambiar el campo en la matriz

        if (_checkWinner(i, j)) {
          _showDialog(_matrix[i][j]); //mostrar cuadro de dialogo
        } else {
          if (_checkDraw()) {
            _showDialog(null); //no mostrar cuadro de dialogo
          }
        }
      },
      child: Container(
        //en esta parte se crean las cajas que contendran las O o las X
        width: 90.0,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle, border: Border.all(color: Colors.black)),
        child: Center(
          child: Text(
            _matrix[i][j],
            style: TextStyle(fontSize: 92.0),
          ),
        ),
      ),
    );
  }

  //esta seccion es para hacer un arreglo que cambie los campos en la matriz a "O" o "X"
  _changeMatrixField(int i, int j) {
    setState(() {
      if (_matrix[i][j] == ' ') {
        //evalua si el campo esta vacio
        if (_lastChar == 'O') //evalua si el ultimo caracter fue una O
          _matrix[i][j] = 'X'; //de ser correcto el valor en el campo sera X
        else
          _matrix[i][j] =
              'O'; //de no ser correcto el valor en el campo sera una =O

        _lastChar = _matrix[i][
            j]; //actualiza el ultimo caracter dependiendo cual condicion se cumplio
      }
    });
  }

  //funcion para revisar si hay empate
  _checkDraw() {
    var draw = true;
    _matrix.forEach((i) {
      //recorrido en la matriz que verifica que los cuadros
      i.forEach((j) {
        //esten llenos y verifiquen si hay empate
        if (j == ' ') draw = false;
      });
    });
    return draw; //retorna un valor true de ser empate o uno false de no serlo
  }

  //funcion para revisar quien gano la partida
  _checkWinner(int x, int y) {
    var col = 0,
        row = 0,
        diag = 0,
        rdiag = 0; //variables que verifican columnas, filas y diagonales
    var n = _matrix.length - 1;
    var player = _matrix[x][y];

    for (int i = 0; i < _matrix.length; i++) {
      //recorrido para actualizar las posiciones en cada campo
      if (_matrix[x][i] == player) col++;
      if (_matrix[i][y] == player) row++;
      if (_matrix[i][i] == player) diag++;
      if (_matrix[i][n - 1] == player) rdiag++;
    }
    if (row == n + 1 || col == n + 1 || diag == n + 1 || rdiag == n + 1) {
      return true; //condicion para ver si el campo esta usado
    }
    return false;
  }

  //funcion para mostrar un cuadro de dialogo
  _showDialog(String winner) {
    String dialogText;
    if (winner == null) {
      // condicion si aun no hay ganador o resulto en empate
      dialogText =
          'It\'s a draw'; //muestra en el cuadro de dialogo si hubo empate
    } else {
      dialogText =
          'Player $winner won'; //muestra en el cuadro de dialogo quien gano
    }

    showDialog(
        context: context,
        builder: (context) {
          //construccion del cuadro de dialogo
          return AlertDialog(
            title: Text('Game Over'),
            content: Text(dialogText),
            actions: <Widget>[
              FlatButton(
                // boton para reiniciar juego
                child: Text('Reset Game'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _initMatrix; //colocar la matriz en su estado inicial
                  });
                },
              )
            ],
          );
        });
  }
}
