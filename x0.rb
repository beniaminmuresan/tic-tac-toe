def print_board(array)
  puts
  puts '--------'
  array.each do |sub_array|
    sub_array.each do |el|
      print "#{el} "
    end
    puts
  end
  puts '--------'
  puts
end

def user_won?(array, users_decision)
  return true if array[0][0] == users_decision && array[0][1] == users_decision && array[0][2] == users_decision
  return true if array[1][0] == users_decision && array[1][1] == users_decision && array[1][2] == users_decision
  return true if array[2][0] == users_decision && array[2][1] == users_decision && array[2][2] == users_decision
  return true if array[0][0] == users_decision && array[1][0] == users_decision && array[2][0] == users_decision
  return true if array[0][1] == users_decision && array[1][1] == users_decision && array[2][1] == users_decision
  return true if array[0][2] == users_decision && array[1][2] == users_decision && array[2][2] == users_decision
  return true if array[0][0] == users_decision && array[1][1] == users_decision && array[2][2] == users_decision
  return true if array[0][2] == users_decision && array[1][1] == users_decision && array[2][0] == users_decision

  false
end

puts "Choose X or 0"

users_decision = gets.chomp

while !['X', '0'].include?(users_decision)
  puts "Wrong choice: Choose X or 0"
  users_decision = gets.chomp
end

if users_decision == 'X'
  computers_decision = '0'
else
  computers_decision = 'X'
end

array = [
  ['00', '01', '02'],
  ['10', '11', '12'],
  ['20', '21', '22']
]

print_board(array)

users_choice = ''

loop do
  puts "Choose a correct position"
  users_choice = gets.chomp
  while !array.flatten.include?(users_choice)
    puts "Choose a correct position"
    users_choice = gets.chomp
  end

  formatted_users_choice = users_choice.split('').map(&:to_i)
  array[formatted_users_choice[0]][formatted_users_choice[1]] = " #{users_decision}"

  print_board(array)

  if user_won?(array, " #{users_decision}")
    puts "Congrats, you won"
    break
  end

  # check for draw (no remaining numeric positions)
  if array.flatten.none? { |el| el =~ /^\d{2}$/ }
    puts "It's a draw"
    break
  end

  # Computer picks from available positions only
  available = array.flatten.select { |el| el =~ /^\d{2}$/ }
  computers_choice = available.sample
  formatted_computers_choice = computers_choice.split('').map(&:to_i)
  array[formatted_computers_choice[0]][formatted_computers_choice[1]] = " #{computers_decision}"

  print_board(array)

  if user_won?(array, " #{computers_decision}")
    puts "Computer won"
    break
  end

  if array.flatten.none? { |el| el =~ /^\d{2}$/ }
    puts "It's a draw"
    break
  end
end