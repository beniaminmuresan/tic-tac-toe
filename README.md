# Tic-Tac-Toe

A command-line Tic-Tac-Toe game written in Ruby where you play against the computer.

## Features

- Play as X or 0 (zero)
- Computer opponent with random move selection
- Win detection for rows, columns, and diagonals
- Draw detection when the board is full
- Interactive command-line interface

## How to Play

1. Run the game:
   ```bash
   ruby x0.rb
   ```

2. Choose your symbol (X or 0)

3. Enter your move using the position format shown on the board:
   - Positions are labeled as `00`, `01`, `02` (top row)
   - `10`, `11`, `12` (middle row)
   - `20`, `21`, `22` (bottom row)

4. The computer will automatically make its move after yours

5. The game ends when:
   - You win (three in a row)
   - The computer wins (three in a row)
   - The board is full (draw)

## Requirements

- Ruby (any recent version)

## Example

```
Choose X or 0
X
--------
00 01 02
10 11 12
20 21 22
--------

Choose a correct position
11
--------
00 01 02
10  X 12
20 21 22
--------
```
