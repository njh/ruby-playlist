[![Build Status](https://travis-ci.org/njh/ruby-playlist.svg)](https://travis-ci.org/njh/ruby-playlist)

# Playlist

This ruby gem allows you to create and manipulate playlists of musical tracks.

It supports parsing and generating playlists in the following formats:

* M3U
* XSPF
* A simple human readable format

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'playlist'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install playlist

## Usage

For full details, please see the [API Documentation](https://www.rubydoc.info/gems/playlist/).

### Creating a Playlist

The `playlist` gem provides data model classes for creating and manipulating 
playlists and music metadata in ruby.

Playlists can be constructed by passing a list of attributes to the constructor or by setting the attributes directly:

```ruby
playlist = Playlist.new(:title => "My awesome playlist")
playlist.annotation = "Each week I add best tracks I can think of."
playlist.add_track(
  :performer => "Jon Hopkins",
  :title => "Everything Connected"
)

track = Playlist::Track.new(:title => "Get Your Shirt")
track.add_contributor(:name => "Underworld", :role => :performer)
track.add_contributor(:name => "Iggy Pop", :role => :performer)
playlist.add_track(track)
```

### Parsing a playlist file

The `playlist` gem supports a number of different playlist file formats.
Here is an example of parsing a M3U file:

```ruby
File.open("playlist.m3u") do |file|
  playlist = Playlist::Format::M3U.parse(file)
  puts "The playlist contains #{playlist.tracks.count} tracks"
end
```

### Generating a playlist file

Having created a `Playlist` object, it can be converted to a playlist file using:

```ruby
File.open("playlist.m3u", "wb") do |file|
  file.write Playlist::Format::M3U.generate(playlist)
end
```


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/njh/ruby-playlist.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
