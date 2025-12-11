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
