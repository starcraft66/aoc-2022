#!/usr/bin/env elixir

defmodule Day2 do
  def main do
    File.read!("day2.txt")
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn round ->
      [opponent,you] = String.split(round," ")
      points(you) + outcome(opponent,you)
    end)
    |> Enum.reduce(&Kernel.+/2)
    |> IO.puts
  end

  def points(you) do
    case you do
      "X" -> 1
      "Y" -> 2
      "Z" -> 3
    end
  end

  def outcome(opponent, you) do
    case {opponent, you} do
      {"A", "X"} -> 3
      {"A", "Y"} -> 6
      {"A", "Z"} -> 0
      {"B", "X"} -> 0
      {"B", "Y"} -> 3
      {"B", "Z"} -> 6
      {"C", "X"} -> 6
      {"C", "Y"} -> 0
      {"C", "Z"} -> 3
    end
  end
end

Day2.main
