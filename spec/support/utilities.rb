# Ex 5.6.4 Instead of duplicating the full_title method from application_helper
# in spec_helper, we do 2 things: 
# 1. Write a test for helper method (in spec/helpers/application_helper_spec.rb)
# 2. Create spec/support/utilities.rb and include ApplicationHelper to make
# helper methods available in ours tests.

include ApplicationHelper