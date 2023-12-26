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
        backgroundColor: Colors.lightBlueAccent,
      ),
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String?>> board = [];
  String? currentPlayer;
  bool gameFinished = false;
  int playerXScore = 0;
  int playerOScore = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    board = List.generate(3, (i) => List.filled(3, null, growable: false));
    currentPlayer = 'X';
    gameFinished = false;
  }

  void makeMove(int row, int col) {
    if (board[row][col] == null && !gameFinished) {
      setState(() {
        board[row][col] = currentPlayer!;
        if (checkWinner(row, col)) {
          gameFinished = true;
          updateScore();
          showWinnerDialog();
        } else if (board.every((row) => row.every((cell) => cell != null))) {
          gameFinished = true;
          showDrawDialog();
        } else {
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWinner(int row, int col) {
    if (board[row].every((cell) => cell == currentPlayer)) {
      return true;
    }
    if (List.generate(3, (i) => board[i][col])
        .every((cell) => cell == currentPlayer)) {
      return true;
    }
    if (row == col &&
        List.generate(3, (i) => board[i][i])
            .every((cell) => cell == currentPlayer)) {
      return true; // Main diagonal
    }
    if (row + col == 2 &&
        List.generate(3, (i) => board[i][2 - i])
            .every((cell) => cell == currentPlayer)) {
      return true; // Opposite diagonal
    }
    return false;
  }

  void updateScore() {
    if (currentPlayer == 'X') {
      playerXScore++;
    } else {
      playerOScore++;
    }
  }

  void showWinnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Winner!'),
          content: Column(
            children: [
              Text('$currentPlayer is the winner!'),
              Text('Score: X - $playerXScore, O - $playerOScore'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Draw!'),
          content: Text('The game is a draw!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void resetScores() {
    setState(() {
      playerXScore = 0;
      playerOScore = 0;
    });
  }

  Color getCellColor(String? value) {
    if (value == 'X') {
      return Colors.red;
    } else if (value == 'O') {
      return Colors.green;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Current Player: $currentPlayer',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                'Score: X - $playerXScore, O - $playerOScore',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                shrinkWrap: true,
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => makeMove(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: getCellColor(board[row][col]),
                      ),
                      child: Center(
                        child: Text(
                          board[row][col] ?? '',
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetScores,
                child: Text('Reset Scores'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
