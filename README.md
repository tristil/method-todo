Method Todo
===========

![Travis CI badge showing build status](https://secure.travis-ci.org/tristil/method-todo.png?branch=master)

What Is It?
-----------

Watch a [video showing the current features of Method Todo](http://www.youtube.com/watch?v=4zTIwNvOMOs&feature=youtu.be)

![Screenshot of mobile view of app](https://github.com/tristil/method-todo/raw/master/screenshot.png)
Mobile View

This is a simple todo list app, built for my personal use. The design goals for
it are:

* It will follow the standard GTD scheme: Context, Project, Priority, Deferred
  Tasks, etc.
* It will allow entry through a single text input that has auto-suggest and
  allows setting context, project and user-delegation through markup (e.g., @
  for context, + for project) 
* It will be highly usable on mobile devices (uses Bootstrap's responsive
  layout)
* It will allow collaboration with other users by allowing users to enable
  shared viewing of projects and delegation of todos
* It will support "deferred" actions

How to Use
----------

* Use @, +, and # in the description line of your todo action to assign
  Context, Project and Tag associations respectively 
* Click on the 'badges' in the Todo list to sort the list for just the Context,
  Badge or Tag
* Click the checkbox next to a Todo to complete it

Notes
-----

* Uses jQuery, Bootstrap and Backbone
* Uses Rspec and Cucumber for BDD
* See http://rubydoc.info/github/tristil/method-todo/frames for code documentation
* CI through Travis CI: http://travis-ci.org/#!/tristil/method-todo

Installation
------------

* Follows normal Ruby on Rails application setup 
* Requires Rails 3.1+
* Run `bundle install`
* Configure database in `config/database.yml`
* Run `rake db:migrate RAILS_ENV=production`
* Use Unicorn or Modrails to host
