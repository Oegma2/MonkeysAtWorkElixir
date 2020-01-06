defmodule MonkeysAtWorkElixir do 
  def rand_key() do
    data = {65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90}
    elem(data, :rand.uniform(26) - 1)    
  end

  def spawn_monkies([], _, count), do: count
  def spawn_monkies(message, default_msg, count) do        
      count = count + 1
      [head | tail] = message

      nextKey = rand_key()       
      
      if head == nextKey do
        spawn_monkies(tail, default_msg, count)
      else
        spawn_monkies(default_msg, default_msg, count)
      end
  end    

  def find_word(message) do
    message = to_charlist(message)
    totalMonkiesUsed = spawn_monkies(message, message, 0)        
    IO.puts "   >>> Monkey #{inspect self()} hit [#{totalMonkiesUsed}] keys to find word"    
  end  
end

defmodule BossMonkey do
  use Supervisor

  def start_link(limits) do
    Supervisor.start_link(__MODULE__, limits)
  end

  def init(limits) do
    children = Enum.map(limits, fn(limit_num) ->
      worker(Child, [limit_num], [id: limit_num, restart: :permanent])
    end)

    supervise(children, strategy: :one_for_one)
  end
end

defmodule Child do
  def start_link(limit) do
    pid = spawn_link(__MODULE__, :init, [limit])
    {:ok, pid}
  end

  def init(limit) do
    IO.puts ">>> Monkey spawed pid #{inspect self()}"
    MonkeysAtWorkElixir.find_word("FOX")
  end
end

BossMonkey.start_link([1,2,3,4,5,6,7,8])
Process.sleep 60_000

# Benchee.run(
#   %{
#     "test1" => fn -> TestRun.test1() end,
#     "test2" => fn -> TestRun.test2() end
#   }
# )