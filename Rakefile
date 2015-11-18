require File.expand_path(%q{../lib/ontopia/tldr/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{ontopia-tldr},
      version:      Ontopia::TLDR::VERSION,
      summary:      %q{Tolog Document Retrieval with Ontopia.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      platform:     'java',
      extra_files:  FileList['*.sample', 'lib/ontopia/tldr/{public,views}/*'].to_a,
      dependencies: {
        'midos'             => '~> 0.2',
        'ontopia-topicmaps' => ['~> 0.0', '>= 0.0.4'],
        'sinatra-bells'     => '~> 0.2'
      }
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
