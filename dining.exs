defmodule Dining do

  defmodule Philosopher do
    def go(id, butler, left, right, master) do
      for _ <- 1 .. 10 do
        send butler, {:enter}
        IO.puts "Philosopher #{id} entered room"

        send left, {:pickup}
        IO.puts "Philosopher #{id} pickuped left fork"

        send right, {:pickup}
        IO.puts "Philosopher #{id} pickuped right fork"

        IO.puts "Philosopher #{id} eating"

        send left, {:putdown}
        IO.puts "Philosopher #{id} putdowned left fork"

        send right, {:putdown}
        IO.puts "Philosopher #{id} pickdowned right fork"

        send butler, {:leave}
        IO.puts "Philosopher #{id} left room"
      end
      send master, {:full, id}
    end
  end

  defmodule Fork do
    def go() do
      receive do
        {:pickup} ->
          {:putdown}
          go
      end
    end
  end

  defmodule Butler do
    def go(0) do
      receive do
        {:leave} -> go(1)
      end
    end

    def go(n) do
      receive do
        {:enter} -> go(n - 1)
        {:leave} -> go(n + 1)
      end
    end
  end

  def go() do
    maxPhilosophers = 5
    maxForks = maxPhilosophers

    butler = spawn(Butler, :go, [maxPhilosophers - 1])

    forks = for _ <- 0 .. maxForks - 1 do
      spawn(Fork, :go, [])
    end
    forks = List.to_tuple(forks)

    phils = for i <- 0 .. maxPhilosophers - 1 do
      left = rem(i, maxPhilosophers)
      right = rem(i + 1, maxPhilosophers)
      spawn(Philosopher, :go, [i, butler, elem(forks, left), elem(forks, right), self])
    end

    for _ <- 1 .. maxPhilosophers do
      receive do
        {:full, id} -> IO.puts "Philosopher #{id} full"
      end
    end
  end

end
