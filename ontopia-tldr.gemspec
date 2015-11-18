# -*- encoding: utf-8 -*-
# stub: ontopia-tldr 0.1.2 java lib

Gem::Specification.new do |s|
  s.name = "ontopia-tldr"
  s.version = "0.1.2"
  s.platform = "java"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2015-11-18"
  s.description = "Tolog Document Retrieval with Ontopia."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "config.ru.sample", "lib/ontopia-tldr.rb", "lib/ontopia/tldr.rb", "lib/ontopia/tldr/public/site.css", "lib/ontopia/tldr/public/site.js", "lib/ontopia/tldr/version.rb", "lib/ontopia/tldr/views/document.erb", "lib/ontopia/tldr/views/documents.erb", "lib/ontopia/tldr/views/index.erb", "lib/ontopia/tldr/views/layout.erb", "lib/ontopia/tldr/views/topic.erb", "lib/ontopia/tldr/views/topics.erb"]
  s.homepage = "http://github.com/blackwinter/ontopia-tldr"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nontopia-tldr-0.1.2 [2015-11-18]:\n\n* Updated for sinatra-bells 0.2.\n\n"
  s.rdoc_options = ["--title", "ontopia-tldr Application documentation (v0.1.2)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.rubygems_version = "2.5.0"
  s.summary = "Tolog Document Retrieval with Ontopia."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<midos>, ["~> 0.2"])
      s.add_runtime_dependency(%q<ontopia-topicmaps>, [">= 0.0.4", "~> 0.0"])
      s.add_runtime_dependency(%q<sinatra-bells>, ["~> 0.2"])
      s.add_development_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<midos>, ["~> 0.2"])
      s.add_dependency(%q<ontopia-topicmaps>, [">= 0.0.4", "~> 0.0"])
      s.add_dependency(%q<sinatra-bells>, ["~> 0.2"])
      s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<midos>, ["~> 0.2"])
    s.add_dependency(%q<ontopia-topicmaps>, [">= 0.0.4", "~> 0.0"])
    s.add_dependency(%q<sinatra-bells>, ["~> 0.2"])
    s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
