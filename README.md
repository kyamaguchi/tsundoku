# Tsundoku 積読

Manage pile of unread books  

["Tsundoku"](https://en.wikipedia.org/wiki/Tsundoku) From Wikipedia  
[Tsundoku: Japan's Word for 'Books You Buy But Don't Read'](https://www.tofugu.com/japanese/tsundoku/)  

![books-922321_1280](https://cloud.githubusercontent.com/assets/275284/25094616/f7640402-23d2-11e7-96b8-24c22c435745.jpg)

## Sites

Currently, Kindle(Amazon) books are only supported.

## Setup

### Setup db

```
bundle
rails db:migrate
```

### Setup fetching of kindle books data (kindle_manager gem)

See [amazon_auth gem](https://github.com/kyamaguchi/amazon_auth) and [kindle_manager gem](https://github.com/kyamaguchi/kindle_manager)  

[chromedriver](https://sites.google.com/a/chromium.org/chromedriver/downloads) is required. Please [download chromedriver](http://chromedriver.storage.googleapis.com/index.html) and update chromedriver regularly.  

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

### How to manage books

You can manage books with adding tags to books.  
You can find some filters(Read, Reading, Hope to read) in https://kindle.amazon.co.jp/your_reading .  
<img width="521" alt="kindle_your_reading_filter" src="https://user-images.githubusercontent.com/275284/26866394-dd13ecf2-4b9b-11e7-99b9-1da816b3a107.png" style="max-width:100%;border: 1px gray solid;">

Example of tags:

- Checked - The books you managed their tags
- Hope to read
- Read

The task `rails tags:guess_from_title` will add the following tags and some guessed tags.

- Sample
- Owner - Owner library

<img width="533" alt="example_of_tags" src="https://user-images.githubusercontent.com/275284/26866399-e23be234-4b9b-11e7-9d45-765bcee4b0e6.png" style="max-width:100%;border: 1px gray solid;">

## Update books

```
rails kindle:fetch
rails kindle:import
rails tags:guess_from_title
```

Fetch all kindle books data with new download directory.

```
rails kindle:fetch[10000,true]
```

### Using envchain

`envchain` can be used to secure credentials

See https://github.com/kyamaguchi/amazon_auth#envchain-for-security

```
envchain amazon rails kindle:fetch
envchain amazon rails kindle:import

envchain amazon rails console
```

## TODO

- Update tags without reloading page
- Update(fetch) books based on last update
- Import books data from several services
