defmodule BufferliteTest do
  use ExUnit.Case
  doctest Bufferlite

  @test_stor 'test.db'
  @test_buff 'buff1'

  setup do
    on_exit fn ->
      File.rm(@test_stor)
    end
  end

  test "create/delete buffer" do
    {:ok, pid} = Bufferlite.start_link(@test_stor)
    assert :ok = Bufferlite.new_buffer(pid, @test_buff)
    assert :ok = Bufferlite.del_buffer(pid, @test_buff)
    Bufferlite.stop(pid)
  end

  test "push and extracting data into buffer" do
    {:ok, pid} = Bufferlite.start_link(@test_stor)
    Bufferlite.new_buffer(pid, @test_buff)
    #Pushing
    assert {:ok, []} = Bufferlite.push(pid, @test_buff, [1, 2, 3, 4])
    assert {:ok, []} = Bufferlite.push(pid, @test_buff, :data)
    assert {:ok, []} = Bufferlite.push(pid, @test_buff, "this")
    assert {:ok, []} = Bufferlite.push(pid, @test_buff, 12.678288831221)
    assert {:ok, []} = Bufferlite.push(pid, @test_buff, {:ok, 1, 2, 4, [1, 2]})
    assert {:ok, []} = Bufferlite.push(pid, @test_buff, fn x -> x * x end)
    # Retrieving
    assert [1, 2, 3, 4] = Bufferlite.pop(pid, @test_buff)
    assert :data = Bufferlite.pop(pid, @test_buff)
    assert "this" = Bufferlite.pop(pid, @test_buff)
    assert 12.678288831221 = Bufferlite.pop(pid, @test_buff)
    assert {:ok, 1, 2, 4, [1, 2]} = Bufferlite.pop(pid, @test_buff)

    #Bufferlite.pop(pid, @test_buff)
    Bufferlite.del_buffer(pid, @test_buff)
    Bufferlite.stop(pid)
  end

  test "getting buffer lenght" do
    {:ok, pid} = Bufferlite.start_link(@test_stor)
    Bufferlite.new_buffer(pid, @test_buff)
    Bufferlite.push(pid, @test_buff, -1)
    Bufferlite.push(pid, @test_buff, "yay")
    Bufferlite.push(pid, @test_buff, {:ok, 1, 2, "1"})
    assert {:len, 3} = Bufferlite.buffer_len(pid, @test_buff)

    Bufferlite.del_buffer(pid, @test_buff)
    Bufferlite.stop(pid)
  end

  test "getting existing buffers" do
    {:ok, pid} = Bufferlite.start_link(@test_stor)
    Bufferlite.new_buffer(pid, "buff1")
    Bufferlite.new_buffer(pid, "buff2")
    Bufferlite.new_buffer(pid, "buff3")
    Bufferlite.new_buffer(pid, "buff4")
    assert {:ok, [[name: "buff1"], [name: "buff2"], [name: "buff3"], [name: "buff4"]]} = Bufferlite.get_buffers(pid)

    Bufferlite.del_buffer(pid, @test_buff)
    Bufferlite.stop(pid)
  end
end
