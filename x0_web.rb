require 'sinatra'
require 'json'
require 'securerandom'

set :port, 4567
set :bind, '0.0.0.0'

# Game state
class Game
  attr_accessor :board, :user_symbol, :computer_symbol, :game_over, :winner

  def initialize(user_symbol)
    @board = Array.new(3) { Array.new(3, nil) }
    @user_symbol = user_symbol
    @computer_symbol = user_symbol == 'X' ? 'O' : 'X'
    @game_over = false
    @winner = nil
  end

  def make_move(row, col, symbol)
    return false if @board[row][col] || @game_over

    @board[row][col] = symbol
    check_game_state
    true
  end

  def computer_move
    available = []
    3.times do |row|
      3.times do |col|
        available << [row, col] if @board[row][col].nil?
      end
    end

    return nil if available.empty?

    row, col = available.sample
    make_move(row, col, @computer_symbol)
    [row, col]
  end

  def check_game_state
    if check_winner(@user_symbol)
      @game_over = true
      @winner = 'user'
    elsif check_winner(@computer_symbol)
      @game_over = true
      @winner = 'computer'
    elsif board_full?
      @game_over = true
      @winner = 'draw'
    end
  end

  def check_winner(symbol)
    # Check rows
    3.times do |row|
      return true if @board[row].all? { |cell| cell == symbol }
    end

    # Check columns
    3.times do |col|
      return true if (0..2).all? { |row| @board[row][col] == symbol }
    end

    # Check diagonals
    return true if (0..2).all? { |i| @board[i][i] == symbol }
    return true if (0..2).all? { |i| @board[i][2-i] == symbol }

    false
  end

  def board_full?
    @board.all? { |row| row.all? { |cell| !cell.nil? } }
  end

  def to_json(*args)
    {
      board: @board,
      user_symbol: @user_symbol,
      computer_symbol: @computer_symbol,
      game_over: @game_over,
      winner: @winner
    }.to_json(*args)
  end
end

# Session storage
enable :sessions
set :session_secret, SecureRandom.hex(32)

get '/' do
  erb :index
end

post '/start' do
  content_type :json
  user_symbol = params[:symbol]
  session[:game] = Game.new(user_symbol)
  session[:game].to_json
end

post '/move' do
  content_type :json
  game = session[:game]

  if game.nil?
    return { error: 'No game in progress' }.to_json
  end

  row = params[:row].to_i
  col = params[:col].to_i

  if game.make_move(row, col, game.user_symbol)
    # Computer makes a move if game not over
    unless game.game_over
      game.computer_move
    end
  end

  session[:game] = game
  game.to_json
end

get '/reset' do
  session.clear
  redirect '/'
end

__END__

@@index
<!DOCTYPE html>
<html>
<head>
  <title>Tic-Tac-Toe</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Arial', sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      color: #333;
    }

    .container {
      background: white;
      border-radius: 20px;
      padding: 40px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      text-align: center;
    }

    h1 {
      color: #667eea;
      margin-bottom: 30px;
      font-size: 2.5em;
    }

    #choiceScreen, #gameScreen {
      display: none;
    }

    #choiceScreen.active, #gameScreen.active {
      display: block;
    }

    .choice-buttons {
      display: flex;
      gap: 20px;
      justify-content: center;
      margin-top: 20px;
    }

    .choice-btn {
      background: #667eea;
      color: white;
      border: none;
      padding: 20px 40px;
      font-size: 24px;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.3s;
      font-weight: bold;
    }

    .choice-btn:hover {
      background: #764ba2;
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(0,0,0,0.3);
    }

    #status {
      font-size: 1.5em;
      margin-bottom: 20px;
      min-height: 40px;
      color: #667eea;
      font-weight: bold;
    }

    .board {
      display: grid;
      grid-template-columns: repeat(3, 120px);
      grid-gap: 10px;
      margin: 30px auto;
      justify-content: center;
    }

    .cell {
      width: 120px;
      height: 120px;
      background: #f0f0f0;
      border: 3px solid #667eea;
      font-size: 48px;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.3s;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #333;
    }

    .cell:hover:not(.filled) {
      background: #e0e0ff;
      transform: scale(1.05);
    }

    .cell.filled {
      cursor: not-allowed;
    }

    .cell.x {
      color: #e74c3c;
    }

    .cell.o {
      color: #3498db;
    }

    .reset-btn {
      background: #764ba2;
      color: white;
      border: none;
      padding: 15px 30px;
      font-size: 18px;
      border-radius: 10px;
      cursor: pointer;
      margin-top: 20px;
      transition: all 0.3s;
    }

    .reset-btn:hover {
      background: #667eea;
      transform: translateY(-2px);
    }

    .instructions {
      color: #666;
      margin-bottom: 20px;
      font-size: 18px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>🎮 Tic-Tac-Toe</h1>

    <div id="choiceScreen" class="active">
      <p class="instructions">Choose your symbol:</p>
      <div class="choice-buttons">
        <button class="choice-btn" onclick="startGame('X')">X</button>
        <button class="choice-btn" onclick="startGame('O')">O</button>
      </div>
    </div>

    <div id="gameScreen">
      <div id="status">Your turn!</div>
      <div class="board" id="board"></div>
      <button class="reset-btn" onclick="resetGame()">New Game</button>
    </div>
  </div>

  <script>
    let gameState = null;

    function showScreen(screen) {
      document.getElementById('choiceScreen').classList.remove('active');
      document.getElementById('gameScreen').classList.remove('active');
      document.getElementById(screen).classList.add('active');
    }

    async function startGame(symbol) {
      const response = await fetch('/start', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `symbol=${symbol}`
      });

      gameState = await response.json();
      renderBoard();
      updateStatus();
      showScreen('gameScreen');
    }

    async function makeMove(row, col) {
      if (gameState.game_over) return;
      if (gameState.board[row][col]) return;

      const response = await fetch('/move', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `row=${row}&col=${col}`
      });

      gameState = await response.json();
      renderBoard();
      updateStatus();
    }

    function renderBoard() {
      const board = document.getElementById('board');
      board.innerHTML = '';

      for (let row = 0; row < 3; row++) {
        for (let col = 0; col < 3; col++) {
          const cell = document.createElement('div');
          cell.className = 'cell';
          const value = gameState.board[row][col];
          
          if (value) {
            cell.textContent = value;
            cell.classList.add('filled');
            cell.classList.add(value.toLowerCase());
          }
          
          cell.onclick = () => makeMove(row, col);
          board.appendChild(cell);
        }
      }
    }

    function updateStatus() {
      const status = document.getElementById('status');

      if (gameState.game_over) {
        if (gameState.winner === 'user') {
          status.textContent = '🎉 Congratulations! You won!';
          status.style.color = '#27ae60';
        } else if (gameState.winner === 'computer') {
          status.textContent = '😔 Computer won! Try again.';
          status.style.color = '#e74c3c';
        } else {
          status.textContent = '🤝 It\'s a draw!';
          status.style.color = '#f39c12';
        }
      } else {
        status.textContent = `Your turn! You are ${gameState.user_symbol}`;
        status.style.color = '#667eea';
      }
    }

    function resetGame() {
      window.location.href = '/reset';
    }
  </script>
</body>
</html>
