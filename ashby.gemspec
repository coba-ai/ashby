$:.push File.expand_path('lib', __dir__)
require 'ashby/version'

Gem::Specification.new do |spec|
  spec.name          = 'ashby'
  spec.version       = Ashby::VERSION
  spec.authors       = ['Abraham Kuri']
  spec.email         = ['abkuri88@gmail.com']

  spec.summary       = ' Ashby CRM Integration '
  spec.description   = ' Ashby CRM Integration '
  spec.homepage      = 'https://github.com/coba-ai/ashby'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/coba-ai/ashby'
  spec.metadata['changelog_uri'] = 'https://github.com/coba-ai/ashby/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['{app,config,lib}/**/*', 'README.md']
  spec.require_paths = ['lib']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
end
