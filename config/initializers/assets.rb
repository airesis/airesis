# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(endless_page.js paypal-button.min.js landing/main.js landing/all.js
homepage.js jquery.js jquery.qtip.js ice/index.js html2canvas.js i18n/*.js
proposals/show.js elfinder.full.js elFinderSupportVer1.js proposals/edit.js)
Rails.application.config.assets.precompile += %w(back_enabled.png landing.css landing/all.css redmond/custom.css
menu_left.css jquery.qtip.css foundation_and_overrides.css elfinder.min.css pdf/proposal.css
newsletters.css ckeditor/*)

