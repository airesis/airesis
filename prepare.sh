#!/bin/sh

bundle exec rake1.9 assets:precompile
cp -r app/assets/stylesheets/redmond/images/ public/assets/
