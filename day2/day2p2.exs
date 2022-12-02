#!/usr/bin/env elixir

defmodule Day2 do
  def main do
    File.read!("day2.txt")
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn round ->
      [opponent,you] = String.split(round," ")
      outcome(opponent,you)
    end)
    |> Enum.reduce(&Kernel.+/2)
    |> IO.puts
  end

  def points(move) do
    case move do
      "rock" -> 1
      "paper" -> 2
      "scissors" -> 3
    end
  end

  def outcome(opponent, result) do
    case {opponent, result} do
      {"A", "X"} -> points("scissors") + 0
      {"A", "Y"} -> points("rock") + 3
      {"A", "Z"} -> points("paper") + 6
      {"B", "X"} -> points("rock") + 0
      {"B", "Y"} -> points("paper") + 3
      {"B", "Z"} -> points("scissors") + 6
      {"C", "X"} -> points("paper") + 0
      {"C", "Y"} -> points("scissors") + 3
      {"C", "Z"} -> points("rock") + 6
    end
  end
end

Day2.main
