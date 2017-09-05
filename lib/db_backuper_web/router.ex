defmodule DbBackuperWeb.Router do
  use DbBackuperWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DbBackuperWeb do
    pipe_through :api
  end
end
