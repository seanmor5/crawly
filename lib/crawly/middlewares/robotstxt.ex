defmodule Crawly.Middlewares.RobotsTxt do
  @moduledoc """
  Obey robots.txt

  A robots.txt file tells search engine crawlers which pages or files the
  crawler can or can't request from your site. This is used mainly to avoid
  overloading a site with requests!

  No options are required for this middleware. Any tuple-based configurations options passed will be ignored.


  ### Example Declaration
  ```
  middlewares: [
    Crawly.Middlewares.RobotsTxt
  ]
  ```
  """

  @behaviour Crawly.Pipeline

  require Logger

  alias Crawly.Utils

  def run(request, state, _opts \\ []) do
    user_agent = Utils.get_header(request.headers, "User-Agent", "Crawly")

    case Gollum.crawlable?(user_agent, request.url) do
      :uncrawlable ->
        Logger.debug("Dropping request: #{request.url} (robots.txt filter)")

        {false, state}

      _ ->
        {request, state}
    end
  end
end
