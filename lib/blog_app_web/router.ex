defmodule BlogAppWeb.Router do
  use BlogAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BlogAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogAppWeb do
    pipe_through :browser

    get "/", PageController, :home

    # blog posts
    live "/posts", PostLive.Index, :index
    live "/posts/new", PostLive.Index, :new
    live "/posts/:id/edit", PostLive.Index, :edit

    live "/posts/:id", PostLive.Show, :show
    live "/posts/:id/show/edit", PostLive.Show, :edit
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:blog_app, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BlogAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
