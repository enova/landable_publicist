# LandablePublicist

A CMS System made up of two applications Landable & Publicist. Landable is an API for building your CMS. It comes with many features such as Asset Uploading, and Visit Tracking.  Publicist is a Web UI for managing your Pages, Themes, Assets, and Authors. Together they form LandablePublicist which functions as a Rails Engine.   

## Installation

LandablePublicist requires [Postgres](https://github.com/ged/ruby-pg). Make sure you have Postgres installed and configured in your app.

Add `gem 'landable_publicist'` to your project's Gemfile and run `bundle`.
  
Run `bundle exec rails g landable_publicst:install`.  

Open your routes file, and ensure that the engine is mounted properly. Typically, this will be your final, catch-all route:

```ruby
My::Application.routes.draw do
  mount LandablePublicist::Engine => '/'
end
```

### Landable 

Run `bundle exec rails g landable:install`, and update the [landable initializer to taste](https://github.com/enova/landable/wiki/Configuration).

Install Landable's migrations:

```sh
rake landable:install:migrations
rake db:migrate
```

### Launching

You can navigate to the CMS System.  Launch your server and navigate to ```http://localhost:3000/publicist```, and login using the following credentials:

- *Author*: admin
- *Password*: password
