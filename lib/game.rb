# frozen_string_literal: true

# Game logic for Tic-Tac-Toe
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
    available = available_positions
    return nil if available.empty?

    row, col = available.sample
    make_move(row, col, @computer_symbol)
    [row, col]
  end

  def to_hash
    {
      board: @board,
      user_symbol: @user_symbol,
      computer_symbol: @computer_symbol,
      game_over: @game_over,
      winner: @winner
    }
  end

  private

  def available_positions
    positions = []
    3.times do |row|
      3.times do |col|
        positions << [row, col] if @board[row][col].nil?
      end
    end
    positions
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
    check_rows(symbol) || check_columns(symbol) || check_diagonals(symbol)
  end

  def check_rows(symbol)
    @board.any? { |row| row.all? { |cell| cell == symbol } }
  end

  def check_columns(symbol)
    3.times.any? { |col| (0..2).all? { |row| @board[row][col] == symbol } }
  end

  def check_diagonals(symbol)
    diagonal1 = (0..2).all? { |i| @board[i][i] == symbol }
    diagonal2 = (0..2).all? { |i| @board[i][2 - i] == symbol }
    diagonal1 || diagonal2
  end

  def board_full?
    @board.all? { |row| row.all? { |cell| !cell.nil? } }
  end
end
