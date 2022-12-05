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
      move(acc, String.to_integer(amount), String.to_integer(from), String.to_integer(to))
    end)
    |> Enum.to_list()
    |> Enum.reduce("", fn stack, acc ->
      acc <> List.last(elem(stack,1))
    end)
    |> IO.puts

  end

  defp move(yard, amount, from, to) do
    moved = Enum.reduce(1..amount, yard, fn _, acc ->
      {take, remainder} = List.pop_at(Map.get(acc, from), -1)
      Map.merge(acc,%{from => remainder, to => Map.get(acc, to, []) ++ [take]})
    end)

    size = Map.get(moved, to)
    |> length()

    {_, reversed_stack} = Map.get(moved, to)
    |> Enum.split(-1 * amount)
    reversed_stack = reversed_stack
    |> Enum.reverse()

    {unchanged, _} = Map.get(moved, to)
    |> Enum.split(size - amount)

    Map.put(moved, to, unchanged ++ reversed_stack)
  end
end

Day5.main()
