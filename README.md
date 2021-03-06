Link-Up
========

### Bookmark Manager App

This simple application allows you to add and organise your links and 'favourite' other user's links. This light-weight Sinatra application was my first application using a PostgreSQL database through DataMapper. 

The approach taken to testing the app involved RSpec, Capybara for integration testing and DataMapper cleaner to maintain a fresh database during testing.

This application was modelled with Users, Favourites, Links and Tags classes, which was a good exercise in beginning to explore database associations.

The app is in beta mode while I improve the front-end, until then... 

![alt text](https://raw.github.com/HannahKnights/Bookmark-Manager/master/public/images/Screen%20Shot%202014-03-04%20at%2011.43.22.png "Link-Up")

Created while studying at [Makers Academy](http://www.makersacademy.com)

#### How to Use

Run the test coverage for this app using:

~~~
$ rspec
~~~ 


#### Technology

* Ruby
* Sinatra
* PostgreSQL
* DataMapper
* Bcrypt
* Capybara and RSpec