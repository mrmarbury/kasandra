defmodule Kasandra.Helper.Communicator do

  defstruct Commands do
    on: '{"system":{"set_relay_state":{"state":1}}}'
    off: '{"system":{"set_relay_state":{"state":0}}}'
    status: '{"system":{"get_sysinfo":null}}'
  end

  def switch_off(url) do
    communicate(url, %Commands.off)
  end

  def switch_on(url) do
    communicate(url, %Commands.on)
  end

  def get_status(url) do
    communicate(url, %Commands.status)
  end

  defp communicate(url, message) do
    socket = Socket.TCP.connect!(url, 9999, packet: :line)
    :ok = Socket.Stream.send!(socket, Kasandra.Helper.CryptHelper.encrypt(message))
    {:ok, recv} = Socket.Stream.recv!(socket)
    Kasandra.Helper.Crypthelper.decrypt(recv)
  end
end
