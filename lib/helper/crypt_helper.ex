defmodule Kasandra.Helper.CryptHelper do
  use Bitwise

  @crypt_key 171

  # <<0, 0, 0, 42, 208, 242, 129, 248, 139, 255, 154, 247, 213, 239, 148, 182, 197, 139, 249, 156, 240, 145, 232, 183, 196, 176, 209, 165, 192, 226, 216, 163, 129, 242, 134, 231, 147, 246, 212, 238, 223, 162, 223, 162>>
  # {"system":{"set_relay_state":{"state":1}}}
  # <<0, 0, 0, 42, 208, 242, 129, 248, 139, 255, 154, 247, 213, 239, 148, 182, 209, 180, 192, 159, 236, 149, 230, 143, 225, 135, 232, 202, 240, 158, 235, 135, 235, 150, 235>>
  # {"system":{"get_sysinfo":null}}

  def encrypt(stream, crypted \\ <<0, 0, 0, 42>>, key \\ @crypt_key)

  def encrypt([byte | stream], crypted, key) do
    xored = key ^^^ byte
    encrypt(stream, crypted <> <<xored>>, xored)
  end

  def encrypt([], crypted, _) do
    crypted
  end

  @spec decrypt([Integer]) :: binary
  def decrypt(stream) do
    decryptor(Enum.drop(stream, 4), [], @crypt_key)
  end

  defp decryptor([byte | stream], decrypted, key) do
    decryptor(stream, [key ^^^ byte | decrypted], byte)
  end

  defp decryptor([], decrypted, _) do
    decrypted |> Enum.reverse() |> to_string()
  end
end
