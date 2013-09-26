
require 'simple_form'
require 'emoji/railtie'

# We need one of the two pagination engines loaded by this point.
# We don't care which one, just one of them will do.
begin
  require 'kaminari'
rescue LoadError
  begin
    require 'will_paginate'
  rescue LoadError
    puts "Please add the kaminari or will_paginate gem to your application's Gemfile. The Forem engine needs either kaminari or will_paginate in order to paginate."
    exit
  end
end