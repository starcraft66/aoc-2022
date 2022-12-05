#!/usr/bin/env elixir

defmodule Day5 do
  def main do
    [drawing, commands] = File.read!("day5.txt")
    |> String.split("\n\n", trim: true)

    yard = drawing
    |> String.split("\n")
    |> Enum.drop(-1)
    |> Enum.with_index()
    |> Enum.map(fn {cell, i} ->
      row = cell
      |> String.to_charlist()
      |> Enum.chunk_every(4)
      |> Enum.with_index()
      |> Enum.map(fn {crate, j} ->
        crate = crate
        |> Enum.at(1)

        crate = <<crate :: utf8>>
        case crate do
          " " -> %{}
          _ -> %{j + 1 => [crate]}
        end
      end)
      |> Enum.reduce(&Map.merge/2)
      %{i => row}
    end)
    |> Enum.reduce(&Map.merge/2)
    |> Map.to_list()
    |> Enum.map(&(elem(&1, 1)))
    |> Enum.reduce(&(Map.merge(&1, &2, fn _k, v1, v2 -> v1 ++ v2 end)))

    commands
    |> String.split("\n", trim: true)
    |> Enum.reduce(yard, fn command, acc ->
      [_, amount, from, to] = Regex.run(~r/move (\d+) from (\d) to (\d)/, command)
      Enum.reduce(1..String.to_integer(amount), acc, fn _, acc2 ->
        move(acc2, String.to_integer(from), String.to_integer(to))
      end)
    end)
    |> Enum.to_list()
    |> Enum.reduce("", fn stack, acc ->
      acc <> List.last(elem(stack,1))
    end)
    |> IO.puts

  end

  defp move(yard, from, to) do
    {take, remainder} = List.pop_at(Map.get(yard, from), -1)
    Map.merge(yard,%{from => remainder, to => Map.get(yard, to, []) ++ [take]})
  end
end

Day5.main()
