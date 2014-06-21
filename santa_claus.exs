# "A New Exercise in Concurrency - John A. Trono"

defmodule SantaClaus do

  defmodule Santa do
    def go(max_jobs) do
      for _ <- 1 .. max_jobs do
        IO.puts "Santa: sleeping ..."
        receive do
          {:ready, reindeer} -> send(reindeer, :deliver)
          {:ask, elf} -> send(elf, :answer)
        end
      end
    end
  end

  defmodule Group do
    defp _go(0) do
      # skip
    end

    defp _go(n) do
      receive do
        {:join, member} ->
          _go(n - 1)
          send(member, :go_ahead)
      end
      receive do
        :leave -> # skip
      end
    end

    def go(n) do
      _go(n)
      go(n)
    end
  end

  defmodule Reindeer do
    def go(id, santa, group) do
      send(group, {:join, self})
      receive do
        :go_ahead -> # skip
      end
      send(santa, {:ready, self})
      receive do
        :deliver ->
          send(group, :leave)
          IO.puts "Reindeer #{id}: Delivering gifts ..."
      end
      go(id, santa, group)
    end
  end

  defmodule Elf do
    def go(id, santa, group) do
      send(group, {:join, self})
      receive do
        :go_ahead -> # skip
      end
      send(santa, {:ask, self})
      receive do
        :answer ->
          send(group, :leave)
          IO.puts "Elf #{id}: Problem solved!"
      end
      go(id, santa, group)
    end
  end

  def go do
    max_jobs = 1000
    max_reindeers = 9
    max_elves = 100
    max_reindeer_members = 9
    max_elf_members = 3

    santa = spawn(Santa, :go, [max_jobs])
    reindeer_group = spawn(Group, :go, [max_reindeer_members])
    elf_group = spawn(Group, :go, [max_elf_members])
    reindeers = for reindeer <- 1 .. max_reindeers do
      spawn(Reindeer, :go, [reindeer, santa, reindeer_group])
    end
    elves = for elf <- 1 .. max_elves do
      spawn(Elf, :go, [elf, santa, elf_group])
    end
  end

end
