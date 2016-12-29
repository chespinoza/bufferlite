defmodule Bufferlite do
  use GenServer
  def start_link(db_path, opts \\ []) do
    GenServer.start_link(__MODULE__, db_path, opts)
  end

  ## GenServer callbacks
  def init(db_path) do
    case Sqlitex.open(db_path) do
      {:ok, db} -> {:ok, db}
      {:error, reason} -> {:stop, reason}
    end
  end

  def handle_call({:new_buffer, buff_name}, _from, db) do
    result = Sqlitex.exec(db, "CREATE TABLE IF NOT EXISTS #{buff_name}(id INTEGER PRIMARY KEY, data BLOB);")
    {:reply, result, db}
  end

  def handle_call({:push, buff_name, term}, _from, db) do
    data = :erlang.term_to_binary(term)
    case Sqlitex.query(db, "INSERT INTO #{buff_name} (data) VALUES ($1);", bind: [data]) do
      {:error, {:sqlite_error, e}} -> {:reply, {:error, e}, db}
      result -> {:reply, result, db}
    end
  end

  def handle_call({:pop, buff_name}, _from, db) do
    case Sqlitex.query(db, "SELECT * FROM #{buff_name} LIMIT 1;") do
      {:ok, [[ did | [{:data, data}]]]} ->
        id = elem(did, 1)
        Sqlitex.exec(db, "DELETE FROM #{buff_name} WHERE id=#{id};")
        case data do
          nil -> {:reply, {:ok, nil}, db}
          _ -> {:reply, :erlang.binary_to_term(data), db}
        end
      {:ok, []} -> {:reply, {:ok, []}, db}
      {:error, {:sqlite_error, e}} -> {:reply, {:error, e}, db}
    end
  end

  def handle_call({:buffer_len, buff_name}, _from, db) do
    case Sqlitex.query(db, "SELECT COUNT(*) FROM #{buff_name};") do
      {:ok, [[{_, len}]]} -> {:reply, {:len, len}, db}
      {:error, []} -> {:reply, {:error, []}, db}
      {:error, {:sqlite_error, e}} -> {:reply, {:error, e}, db}
    end
  end

  def handle_call(:get_buffers, _from, db) do
    case Sqlitex.query(db, "SELECT name FROM sqlite_master WHERE type='table';") do
      {:ok, bffs} -> {:reply, {:ok, bffs}, db}
      anything -> {:reply, anything, db}
    end
  end

## Public API

  def new_buffer(pid, buff_name) do
    GenServer.call(pid, {:new_buffer, buff_name})
  end

  def push(pid, buff_name, term) do
    GenServer.call(pid, {:push, buff_name, term})
  end

  def pop(pid, buff_name) do
    GenServer.call(pid, {:pop, buff_name})
  end

  def buffer_len(pid, buff_name) do
    GenServer.call(pid, {:buffer_len, buff_name})
  end

  def get_buffers(pid) do
    GenServer.call(pid, :get_buffers)
  end
end
