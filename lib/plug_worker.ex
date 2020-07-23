defmodule PlugWorker do
  use GenServer

  defmodule PlugState do
    defstruct check_interval: nil, url: nil, status: :off
  end

  def start_link(worker_config) do
    GenServer.start(__MODULE__, worker_config, name: __MODULE__)
  end

  def init(worker_config) do
    init(worker_config, %PlugState{})
  end

  def init([{:time_on, time_on} | rest], state) do
    init(rest, %{state | time_on: time_on})
  end

  def init([{:check_interval, check_interval} | rest], state) do
    init(rest, %{state | check_interval: check_interval})
  end

  def init([{:url, url} | rest], state) do
    init(rest, %{state | url: url})
  end

  def init([], state) do
    schedule_work(:check_status, state)
    {:ok, state}
  end

  def handle_info({:check_status, url}, state) do
    IO.puts(url)
    schedule_work(:check_status, state)
    {:noreply, state}
  end

  defp schedule_work(action, state) do
    Process.send_after(self(), {action, state.url}, state.check_interval)
  end
end
