mruby-schash
============

[Schash][schash] for [mruby](http://mruby.org/)

## Installation

Please add `conf.gem` line to `build_config.rb` of mruby like following

```ruby
MRuby::Build.new do |conf|
  conf.gem 'mruby-schash', github: 'tatsushid/mruby-schash'
end
```

or add `add_dependency` line to your `mrbgem.rake` like following

```ruby
MRuby::Gem::Specification.new('your-mrbgem') do |spec|
  spec.add_dependency 'mruby-schash', github: 'tatsushid/mruby-schash'
end
```

After adding it, please compile mruby. The mrbgem will be included in the
built binaries.

Please note that to use `match` rule, something `RegExp` providing mrbgem (e.g.
[mruby-onig-regexp](https://github.com/mattn/mruby-onig-regexp)) must be
compiled with this.

## Usage

Its usage is as same as the original Schash.

```ruby
validator = Schash::Validator.new do
  {
    nginx: {
      user: string, # required field
      worker_processes: optional(integer), # optional field
      sites: array_of({
        server_name: string,
        root: string,
        allowed_ips: array_of(string),
      }),
      listen: match(/^(80|443)$/),
    },
  }
end

# valid example
valid = {
  nginx: {
    user: "www-data",
    worker_processes: 4,
    sites: [{
      server_name: "example.com",
      root: "/var/www/itamae",
      allowed_ips: ["127.0.0.1/32"],
    }],
    listen: "80"
  },
}

validator.validate(valid) # => []

# invalid example
invalid = {
  nginx: {
    user: 123,
    sites: {
      server_name: "example.com",
      root: "/var/www/itamae",
      allowed_ips: ["127.0.0.1/32"],
    },
    listen: "8080"
  },
}

validator.validate(invalid)
# => [#<struct Schash::Schema::Error position=["nginx", "user"], message="is not String">, #<struct Schash::Schema::Error position=["nginx", "sites"], message="is not an array">, #<struct Schash::Schema::Error position=["nginx", "listen"], message="does not match /^(80|443)$/">]
```

## Notes
This is just a mruby port of [Schash][schash], almost all code was taken from
the original.

Thanks for the original author!

## License
This program is under MIT license. Please see the [LICENSE.txt][license] file for details.

[schash]: https://github.com/ryotarai/schash
[license]: https://github.com/tatsushid/mruby-schash/blob/master/LICENSE.txt
