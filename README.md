# Ruby on Rails 4 - Sample App
## Implementation

Sample application from the [*Ruby on Rails Tutorial*][railstutorial] by [Michael Hartl][hartl].
The deployed application can be visited here: http://morning-beach-8502.herokuapp.com/.

## Test Suite

[Rspec][rspec] with [Capybara DSL][capybara]. 

## Extensions

### @Replies
2/21/2014

### Messaging
2/26/2014

### Follower notifications
2/27/2013

### Password resets
2/28/2014

### Signup confirmation
3/3/2014 
Users cannot make posts until they have visited a confirmation link sent to their email.

### RSS feeds for a user's microposts and a user's status feed
3/4/2014

### REST API
3/7/2014
Users can interact with the app through a json API. Try it with a client such as [POSTman][postman] available in Chrome as a browser app. To get an access token, sign in to the app and go to Account > Settings > Get API key. To use the token and interact with the app, set up your http headers as follows:

| Header | Value |
| :----- | :---- |
| Content-Type | application/json |
| Accept | application/json |
| Authorization | Token token="token_provided_by_app" |

Most routes require token authorization. Some routes, such as show user and create user, don't. 


#### Create a user
    POST   /api/users(.:format)                api/v1/users#create {:format=>"json"}
No authentication required here. The json should look like: 

```
{
    "user": 
        { "name": "Homer Simpson", 
            "email": "homer@springfield.com", 
            "username": "donut_man", 
            "password": "password", 
            "password_confirmation": "password" }
}
```


#### Show a single user
    GET    /api/users/:id(.:format)            api/v1/users#show {:format=>"json"}
No authentication required. Retrieves a user record.



    GET		 /api/users/:id/following(.:format)  api/v1/users#following {:format=>"json"}
Requires authentication, view any user. Retrieves list of users the user is following.


    GET    /api/users/:id/followers(.:format)  api/v1/users#followers {:format=>"json"}
Requires authentication, view any user. Retrieves list of users following the user.


    GET    /api/users(.:format)                api/v1/users#index {:format=>"json"}
Requires authentication. Retrieves a list of all users.


    PATCH  /api/users/:id(.:format)            api/v1/users#update {:format=>"json"}
    PUT    /api/users/:id(.:format)            api/v1/users#update {:format=>"json"}
Authentication required. Access_token must match user id. Format the json like a POST #create user, but leave off any user particulars that do not require updating.


    DELETE /api/users/:id(.:format)            api/v1/users#destroy {:format=>"json"}
Only administrator has access.


    POST   /api/relationships(.:format)        api/v1/relationships#create {:format=>"json"}
Authentication required. Follow a user. The json needs to include the user id to be followed.

    { "id": 86 }


    DELETE /api/relationships/:id(.:format)    api/v1/relationships#destroy {:format=>"json"}
Authentication required. Stop following a user. The URL needs to include the user id of the user to stop following.


    POST   /api/microposts(.:format)           api/v1/microposts#create {:format=>"json"}
Authentication required. The json should look like:

```
{
	"micropost":
	{ "content": "Eating oats" }
}
```

    DELETE /api/microposts/:id(.:format)       api/v1/microposts#destroy {:format=>"json"}
Authentication required. 


    GET    /api/feed(.:format)                 api/v1/users#feed {:format
Authentication required. Retrieves your status feed.

### User search
3/11/2014

The last extension relies on the [pg_search gem][pg_search] to search the app's users. The gem makes it easy to do this without a 3rd party provider by using [Postgresql's own full text searching][pg-docs-search] capabilities. This is what [Heroku's docs][heroku-search-options] recommend for full text searching. It certainly seems to be the only free option. 

It searches against the user's name, email and username fields.

#### Issue with will_paginate

I ran into an issue paginating the search results using the [will_paginate gem][will_paginate] that Hartl installs in Chapter 9. 

The issue arrises because pg_search returns an ActiveRecord_Relation that would throw an error if `count` was called on it which was breaking `<%= will_paginate %>`. The search result seems to require `count(:all)` instead. The only solution I had found on StackOverflow was to remove will_paginate and install the [kaminari gem][kaminari] for pagination instead. [Kaminari views for Twitter Bootstrap here][kaminari-tw-bs-views]. 


[postman]: http://www.getpostman.com/
[rspec]: https://github.com/rspec/rspec-rails
[capybara]:https://github.com/jnicklas/capybara
[hartl]: http://michaelhartl.com
[railstutorial]: http://railstutorial.org/
[pg_search]: https://github.com/Casecommons/pg_search
[will_paginate]: https://github.com/mislav/will_paginate
[kaminari]: https://github.com/amatsuda/kaminari
[kaminari-tw-bs-views]: https://github.com/gabetax/twitter-bootstrap-kaminari-views
[heroku-search-options]: https://devcenter.heroku.com/articles/full-text-search
[pg-docs-search]: http://www.postgresql.org/docs/current/static/textsearch.html