#!/bin/sh

rake assets:precompile
cp -r app/assets/stylesheets/redmond/images/ public/assets/
