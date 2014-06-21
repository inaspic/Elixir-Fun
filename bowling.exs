defmodule Bowling do

  def score([10, lastButOne, last]), do: 10 + lastButOne + last

  def score([lastButTwo, lastButOne, last]) when lastButTwo + lastButOne == 10 do
    lastButTwo + lastButOne + last
  end

  def score([lastButOne, last]), do: lastButOne + last

  def score([10 | [second | [third | rest]]]) do
    10 + second + third + score([second | [third | rest]])
  end

  def score([first | [second | [third | rest]]]) when first + second == 10 do
      first + second + third + score([third | rest])
  end

  def score([first | [second | rest]]), do: first + second + score(rest)

end

IO.puts Bowling.score([1, 4])
IO.puts Bowling.score([1, 4, 4, 5])
IO.puts Bowling.score([1, 4, 4, 5, 6, 4, 5])
IO.puts Bowling.score([1, 4, 4, 5, 6, 4, 5, 5, 10, 0, 1])
IO.puts Bowling.score([1, 4, 4, 5, 6, 4, 5, 5, 10, 0, 1, 7, 3, 6])
IO.puts Bowling.score([1, 4, 4, 5, 6, 4, 5, 5, 10, 0, 1, 7, 3, 6, 4, 10, 2, 8, 6])
