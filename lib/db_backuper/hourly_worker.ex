defmodule DbBackuper.HourlyWorker do
  use GenServer
  alias DbBackuper.Backup

  @hour 3_600_000 # milliseconds

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # Start timer
    Process.send_after(self(), :work, @hour)

    Backup.execute

    {:ok, state}
  end

  def handle_info(:work, state) do
    # Start the timer again
    Process.send_after(self(), :work, @hour)

    Backup.execute

    {:noreply, state}
  end
end
