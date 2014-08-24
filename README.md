Flickr Public Photos Search
=========

This project is hosted in [heroku server].This is a single page web in Rails to search for public photos in [Flickr]. This web application does not use any database.

  - Ruby version 2.1.1
  - Rails version 4.0.4

This text you see here is *actually* written in Markdown! To get a feel for Markdown's syntax, type some text into the left window and watch the results in the right.  

Running on Local dev machine
--------------
```sh
git clone https://github.com/dibayendu/flickr_photo_search.git
cd flickr_photo_search
```

> Before installing on local machine, you need to [get api key from flickr].
> The api key and shared secret need to be added in config/local_env.yml (instructions are in the file how to add them).
> Otherwise it will show error on the webpage.

```sh
bundle install
rails server --debugger
```
##### Running tests
```sh
bundle exec rspec spec/
```

Dependencies
-----------

* [webmock] - Used in test to mock HTTP resonse.
* [flickraw] - Used to get public photos while searching.
* [blueimp] - Used to show full page images which uses lightbox.

Deploy
-----------
* Create account in [Heroku].
* Create app.
* Follow [instructions] in Heroku.

```sh
git push heroku master
```

License
----

MIT


**Free Software, Hell Yeah!**

[Flickr]:https://www.flickr.com/explore
[get api key from flickr]:https://www.flickr.com/services/apps/create/apply
[heroku server]:http://flickr-photo-search-by-dibs.herokuapp.com/
[webmock]:https://github.com/bblimke/webmock
[flickraw]:https://github.com/hanklords/flickraw
[blueimp]:http://blueimp.github.io/Bootstrap-Image-Gallery/
[Heroku]:https://www.heroku.com/
[instructions]:https://devcenter.heroku.com/articles/getting-started-with-rails4