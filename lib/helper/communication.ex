defmodule Kasandra.Helper.Communication do
  @on '{"system":{"set_relay_state":{"state":1}}}'
  @off '{"system":{"set_relay_state":{"state":0}}}'
  @status '{"system":{"get_sysinfo":null}}'

  def switch_off(url) do
    communicate(url, @on)
  end

  def switch_on(url) do
    communicate(url, @off)
  end

  def get_status(url) do
    communicate(url, @status)
  end

  defp communicate(url, message) do
    # socket = Socket.TCP.connect!(url, 9999, packet: :line)
    # :ok = Socket.Stream.send!(socket, Kasandra.Helper.CryptHelper.encrypt(message))
    # socket |> Socket.packet!(:raw)
    # {:ok, recv} = Socket.Stream.recv!(socket)
    # Kasandra.Helper.CryptHelper.decrypt(recv)
    {:ok, sock} = :gen_tcp.connect(url |> String.to_charlist(), 9999, active: true, packet: :line)
    :gen_tcp.send(sock, message)
    a = :gen_tcp.recv(sock, 0)
    :gen_tcp.close(sock)
    a
  end
end
