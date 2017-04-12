# Tsundoku

Manage pile of unread books

## Setup

### Setup db

```
bundle
rake db:migrate
```

### Setup fetching of kindle books data (kindle_manager gem)

See [amazon_auth gem](https://github.com/kyamaguchi/amazon_auth)

```
amazon_auth
vi .env

rails console
```

On console

```
client = KindleManager::Client.new(debug: true)
client.fetch_kindle_list
books = client.load_kindle_books
```

### Run Rails app

```
rails server
```

## Update books

```
rake kindle:fetch
rake kindle:import
rake tags:guess_from_title
```

## TODO

- Update tags without reloading page
- Update books based on last update
