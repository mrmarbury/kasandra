defmodule Kasandra.Helper.Communication do
  @on '{"system":{"set_relay_state":{"state":1}}}'
  @off '{"system":{"set_relay_state":{"state":0}}}'
  @status '{"system":{"get_sysinfo":null}}'
  @emeter '{"emeter":{"get_realtime":null}}'
  @time '{"time":{"get_time":{}}}'
  @reset '{"system":{"reset":{"delay":1}}}'

  def switch_off(url) do
    communicate(url, @off)
  end

  def switch_on(url) do
    communicate(url, @on)
  end

  def get_status(url) do
    communicate(url, @status)
  end

  def get_emeter(url) do
    communicate(url, @emeter)
  end

  def get_time(url) do
    communicate(url, @time)
  end

  def reset(url) do
    communicate(url, @reset)
  end

  defp communicate(url, message) do
    opts = [active: false, keepalive: true, packet: :line]
    {:ok, sock} = :gen_tcp.connect(url |> String.to_charlist(), 9999, opts)
    sock |> :gen_tcp.send(Kasandra.Helper.CryptHelper.encrypt(message))
    msg = sock |> get_message_from_socket()
    sock |> :gen_tcp.close()
    msg
  end

  defp get_message_from_socket(sock) do
    case :gen_tcp.recv(sock, 0) do
      {:ok, recv} ->
        {:ok, recv |> Kasandra.Helper.CryptHelper.decrypt()}

      {:error, status} ->
        {:error, status}
    end
  end
end
