MRuby::Gem::Specification.new('mruby-schash') do |spec|
  spec.license = 'MIT'
  spec.authors = [
    'Ryota Arai',
    'Tatsushi Demachi',
  ]
  spec.summary = 'Ruby hash validator for mruby'

  spec.add_dependency 'mruby-struct',     core: 'mruby-struct'
  spec.add_dependency 'mruby-array-ext',  core: 'mruby-array-ext'
  spec.add_dependency 'mruby-hash-ext',   core: 'mruby-hash-ext'
  spec.add_dependency 'mruby-symbol-ext', core: 'mruby-symbol-ext'

  spec.add_test_dependency 'mruby-onig-regexp', github: 'mattn/mruby-onig-regexp'
end
