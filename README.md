# Tsundoku 積読

Manage pile of unread books  

["Tsundoku"](https://en.wikipedia.org/wiki/Tsundoku) From Wikipedia  
[Tsundoku: Japan's Word for 'Books You Buy But Don't Read'](https://www.tofugu.com/japanese/tsundoku/)  

![books-922321_1280](https://cloud.githubusercontent.com/assets/275284/25094616/f7640402-23d2-11e7-96b8-24c22c435745.jpg)

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
