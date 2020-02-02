install:
	bundle install --path vendor/bundle

build:
	bundle exec middleman build

start:
	bundle exec middleman server
