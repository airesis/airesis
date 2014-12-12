web: rm -f tmp/unicorn.pid && nginx && bundle exec unicorn -c /app/unicorn.rb
worker: sidekiq
solr:   rake sunspot:solr:run
faye: rackup private_pub.ru -s thin -E production