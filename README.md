# Assignment

## Up and Running

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `IGDB_CLIENT_ID=<client id> IGDB_CLIENT_SECRET=<client secret> iex -S mix phx.server`
- Browse to [https://localhost:4000/games](https://localhost:4000/games)

## Goals
  1. Fetch the games from the IGDB API. Hint: You will use the URL
  https://api.igdb.com/v4/games

  2. Render the games' names in a list on the UI with LiveView or via a controller and view.

  3. This is slow, every time we load the page, we need to fetch all the data again from the IGDB
  API. Let's implement a cache that stores this API call in memory so we don't need to keep
  fetching it on each page reload.

  4. Upper management really wants to know how often we are making requests to the IGDB API, so
  let's capture the timestamp of each successful API call into a database table.

  5. You will notice that the API is only giving us the first 10 results when we call it. Let's implement a
  pagination system to allow the users to see additional results in the UI. How does this affect our cache? Should we change anything?

  6. Let's add more test coverage. We want to mock the API calls, test the front end results, unit test the api authentication code, etc.

  7. What are some ways that we can improve the current code we just wrote? Think through the following:
  - Cache improvements (invalidation, pre-fetching, data optimization, handling api call failures, etc).
  - Improvements to the API interface.