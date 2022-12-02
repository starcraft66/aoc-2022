#!/usr/bin/env elixir

File.read!("day1.txt")
|> String.trim
|> String.split("\n\n")
|> Enum.map(fn x ->
  String.split(x, "\n")
  |> Enum.map(&String.to_integer/1)
  |> Enum.reduce(&Kernel.+/2)
end)
|> Enum.sort
|> Enum.take(-3)
|> Enum.reduce(&Kernel.+/2)
