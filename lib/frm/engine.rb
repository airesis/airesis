
require 'simple_form'
require 'emoji/railtie'

# We need one of the two pagination engines loaded by this point.
# We don't care which one, just one of them will do.
begin
  require 'kaminari'
end
