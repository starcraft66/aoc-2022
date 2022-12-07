#!/usr/bin/env elixir

defmodule AdventFile do
  defstruct parent: "", name: "", filesize: 0, children: []
end

defmodule Day7 do
  def main do
    {_, files} = File.read!("day7.txt")
    |> String.split("$ ", trim: true)
    |> Enum.reduce({"", []}, fn exec, _acc = {path, fs} ->
      [cmdline | lines] = exec
      |> String.split("\n", trim: true)

      case {path, cmdline} do
        {_, "ls"} -> {path, [parse_ls(path, lines) | fs]}
        {_, "cd .."} -> {go_up(path), fs}
        {"/", "cd " <> dir} -> {path <> dir, fs}
        {"", "cd " <> dir} -> {path <> dir, fs}
        {_, "cd " <> dir} -> {path <> "/" <> dir, fs}
      end
    end)

    fs =
    files
    |> Enum.drop(-1)
    |> build_entire_fs(List.last(files))

    # Part 1
    fs
    |> all_dir_sizes()
    |> dir_sizes_under(100000)
    |> Enum.sum()
    |> IO.puts()

    # Part 2
    fs
    |> all_dir_sizes()
    |> delete_to_free(70000000, 30000000)
    |> IO.puts()
  end

  defp build_entire_fs(list, file) do
    file_children = [list
      |> Enum.filter(& &1.parent == file.name)
      |> Enum.map(&(build_entire_fs(list, &1))) | file.children]
      |> List.flatten()
    %AdventFile{
      name: file.name,
      filesize: sum_filesize(file_children),
      parent: file.parent,
      children: file_children
    }
  end

  defp all_dir_sizes(fs = %AdventFile{}) do
    [fs.filesize | all_dir_sizes(fs.children)]
  end

  defp all_dir_sizes(fs) when is_list(fs) do
    fs
    |> Enum.filter(&(length(&1.children) > 0))
    |> Enum.map(&([&1.filesize]) ++ all_dir_sizes(&1.children))
    |> List.flatten()
  end

  defp dir_sizes_under(sizes, cutoff) do
    sizes
    |> Enum.filter(&(&1 <= cutoff))
  end

  def delete_to_free(files, total, want_free) do
    used = hd(files)
    avail = total - used
    needed = want_free - avail

    files
    |> Enum.filter(&(&1 >= needed))
    |> Enum.sort(:desc)
    |> List.last()
  end

  defp go_up(path) do
    parts = path
    |> String.split("/")

    cond do
      (length(parts) > 2) -> parts |> Enum.drop(-1) |> Enum.join("/")
      true -> "/"
    end
  end

  defp sum_filesize(children) do
    children
    |> Enum.map(&(&1.filesize))
    |> Enum.sum()
  end

  defp parse_ls(path, lines) do
    files = lines
    |> Enum.reject(fn x -> String.starts_with?(x, "dir") end)
    |> Enum.map(fn line ->
      [size, filename] = line
      |> String.split(" ")
      %AdventFile{parent: path, name: path <> "/" <> filename, filesize: String.to_integer(size), children: []}
    end)
    %AdventFile{parent: go_up(path), filesize: sum_filesize(files), name: path, children: files}
  end
end

Day7.main()
