defmodule Dojo.RoomChannel do
  use Dojo.Web, :channel
  alias Dojo.Message

  def join("rooms:lobby", payload, socket) do
    if authorized?(payload) do
      IO.inspect payload["name"]
      socket = assign(socket, :name, payload["name"])
      {:ok, %{chave: last_message}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def last_message do
    query = from m in Message, 
      order_by: [desc: m.inserted_at],
      limit: 10
    Repo.all(query) |> Enum.map(&Message.presente/1) 
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    IO.puts("é nois que pinga, boy!")
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  def handle_in("shout", payload, socket) do
    person_name = socket.assigns.name
    Repo.insert! Message.changeset(%Message{}, %{
      user_name: person_name,
      content: payload["message"]
    })
    IO.inspect payload
    payload = %{message: "<#{person_name}>: #{payload["message"]}\n"}
    broadcast socket, "shout", payload  

    {:reply, {:ok, payload}, socket}
  end

  def handle_in("change_name", payload, socket) do
    IO.inspect payload
    person_name = payload["name"]
    socket = assign(socket, :name, person_name)
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    IO.inspect "HANDLE OUT" <> payload.message
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
