defmodule Dojo.PageController do
  use Dojo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
