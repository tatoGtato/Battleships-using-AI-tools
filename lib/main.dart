import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(BatallaNavalApp());
}

class BatallaNavalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Batalla Naval',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Jugador1Screen(),
    );
  }
}

class Jugador1Screen extends StatefulWidget {
  @override
  _Jugador1ScreenState createState() => _Jugador1ScreenState();
}

class _Jugador1ScreenState extends State<Jugador1Screen> {
  late List<List<int>> board;
  late int placedShips;
  late bool firstCellTapped;
  late int firstCellRow;
  late int firstCellCol;

  @override
  void initState() {
    super.initState();
    resetBoard();
  }

  void resetBoard() {
    setState(() {
      board = List.generate(5, (_) => List.filled(5, 0));
      placedShips = 0;
      firstCellTapped = false;
      firstCellRow = -1;
      firstCellCol = -1;
    });
  }

  void placeShip(int row, int col) {
    setState(() {
      if (placedShips < 2 && board[row][col] == 0) {
        if (!firstCellTapped) {
          // First cell of the ship
          firstCellTapped = true;
          firstCellRow = row;
          firstCellCol = col;
          board[row][col] = 1;
        } else {
          // Second cell of the ship
          if ((row == firstCellRow && col == firstCellCol + 1) ||
              (row == firstCellRow + 1 && col == firstCellCol) ||
              (row == firstCellRow - 1 && col == firstCellCol) ||
              (row == firstCellRow && col == firstCellCol - 1)) {
            board[row][col] = 1;
            placedShips++;
            firstCellTapped = false;
          }
        }
      }
    });
  }

  void startGame() {
    Get.to(Jugador2Screen(board: board));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugador 1 - Batalla Naval'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ 5;
                int col = index % 5;
                return GestureDetector(
                  onTap: () {
                    placeShip(row, col);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: board[row][col] == 1 ? Colors.blue : null,
                    ),
                    child: Icon(
                      Icons.directions_boat,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Barcos colocados: $placedShips/2',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: placedShips == 2 ? startGame : null,
            child: Text('Iniciar Juego'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Jugador2Screen extends StatefulWidget {
  final List<List<int>> board;

  Jugador2Screen({required this.board});

  @override
  _Jugador2ScreenState createState() => _Jugador2ScreenState();
}

class _Jugador2ScreenState extends State<Jugador2Screen> {
  late List<List<int>> board;
  late int guessedShips;
  late int remainingAttempts;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    resetBoard();
  }

  void resetBoard() {
    setState(() {
      board = List.generate(5, (_) => List.filled(5, -1));
      guessedShips = 0;
      remainingAttempts = 6;
      gameOver = false;
    });
  }

  void guessShip(int row, int col) {
    setState(() {
      if (board[row][col] == -1) {
        if (widget.board[row][col] == 1) {
          board[row][col] = 1;
          guessedShips++;
        } else {
          board[row][col] = 0;
        }

        remainingAttempts--;

        if (guessedShips == 4 || remainingAttempts == 0) {
          gameOver = true;
        }
      }
    });
  }

  void restartGame() {
    resetBoard();
    Get.to(Jugador1Screen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugador 2 - Batalla Naval'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ 5;
                int col = index % 5;
                return GestureDetector(
                  onTap: () {
                    if (!gameOver) {
                      guessShip(row, col);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: board[row][col] == 1
                          ? Colors.green
                          : board[row][col] == 0
                              ? Colors.orange
                              : null,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          if (gameOver)
            Column(
              children: [
                if (guessedShips == 4)
                  Text(
                    '¡Has ganado!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                else
                  Text(
                    'Perdiste',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: restartGame,
                  child: Text('Reiniciar'),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  'Intentos restantes: $remainingAttempts',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: null,
                  child: Text('Esperando Jugada'),
                ),
              ],
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
