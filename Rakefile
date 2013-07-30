require File.expand_path(%q{../lib/ontopia/tldr/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{ontopia-tldr},
      :version      => Ontopia::TLDR::VERSION,
      :summary      => %q{Tolog Document Retrieval with Ontopia.},
      :author       => %q{Jens Wille},
      :email        => %q{jens.wille@gmail.com},
      :license      => %q{AGPL},
      :homepage     => :blackwinter,
      :platform     => 'java',
      :dependencies => %w[json ontopia-topicmaps ruby-nuggets sinatra],
      :extra_files  => FileList['*.sample', 'lib/ontopia/tldr/{public,views}/*'].to_a
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
