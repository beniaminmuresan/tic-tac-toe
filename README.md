# Tic-Tac-Toe

A Tic-Tac-Toe game implemented in Ruby with multiple versions.

## Versions

### 1. Command Line Version (`x0.rb`)
Traditional terminal-based game where you play against the computer.

**Run:**
```bash
ruby x0.rb
```

**Features:**
- Play as X or 0 (zero)
- Computer opponent with random move selection
- Win detection for rows, columns, and diagonals
- Draw detection when the board is full
- Interactive command-line interface

**How to Play:**
1. Choose your symbol (X or 0)
2. Enter your move using the position format shown on the board (e.g., `00`, `11`, `22`)
3. The computer will automatically make its move after yours
4. First to get 3 in a row wins!

### 2. Web-based GUI Version (Dockerized)
Modern web interface using Sinatra framework, packaged with Docker for easy deployment.

**Run with Docker Compose:**
```bash
docker-compose up
```

Then open your browser to: `http://localhost:4567`

**Features:**
- Beautiful gradient UI with animations
- Click-to-play interface
- Real-time game updates
- Computer opponent
- Win/draw detection
- Responsive design
- Session-based game state
- Fully containerized with Docker

**How to Play:**
1. Choose your symbol (X or O)
2. Click on any empty cell to make your move
3. The computer will automatically make its move
4. First to get 3 in a row wins!
5. Click "New Game" to start over

## Project Structure

```
tic-tac-toe/
├── app/
│   └── app.rb              # Main Sinatra application
├── lib/
│   └── game.rb             # Game logic
├── public/
│   ├── css/
│   │   └── style.css       # Styles
│   └── js/
│       └── game.js         # Client-side JavaScript
├── views/
│   └── index.erb           # HTML template
├── config.ru               # Rack configuration
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker Compose configuration
└── Gemfile                 # Ruby dependencies
```

## Requirements

### Command Line Version
- Ruby 2.6+

### Web Version
- Docker & Docker Compose

## Running the Web Version

### Start the application
```bash
docker-compose up
```

Then open your browser to: `http://localhost:4567`

### Stop the application
```bash
docker-compose down
```

or press `Ctrl+C` if running in foreground.

### Rebuild after changes
```bash
docker-compose up --build
```

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
