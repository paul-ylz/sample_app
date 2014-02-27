# Ruby on Rails 4 - Sample App
## Implementation

Sample application from the [*Ruby on Rails Tutorial*](http://railstutorial.org/) by [Michael Hartl](http://michaelhartl.com).
The deployed application can be visited here: [http://morning-beach-8502.herokuapp.com/](http://morning-beach-8502.herokuapp.com/).

## Test Suite

[Rspec](https://github.com/rspec/rspec-rails) with [Capybara DSL](https://github.com/jnicklas/capybara). 

## Extensions

### @Replies

2/21/2014 - Replies feature complete. 
I went about it in this order:
- test for username attribute on user
- migrate username. Add index and unique: true
- add username to factory and sample data
- test for username validations (length, allowed chars, uniqueness)
- User model validations for username
- test for in_reply_to on Micropost
- migrate in_reply_to. Add index on [user_id, in_reply_to]
- integration test for @replies feature
- query for adding replies to feed
- include username in user_info views 

### Messaging
2/26/2013 - Messaging feature complete.
My work flow:
- Test: User responds to 'message'
- Message model - fields to, from, content, index on to and from.
- Tests for message / user associations
- Build model associations
- Integration test for message index and reading
- Views and controller for message
- Test for sending message via micropost content
- Build message capture mechanism
- Integration test for ability to reply message in message view
- Build form function for message reply
- Test message validations
- Build message model validations
- Delete functions for message
- Sent messages
- Authorizations
- Testing errors for message creation via micropost 
- Refactor to pass tests
- Styling for message pages

### Follower notifications
2/27/2013 - Complete