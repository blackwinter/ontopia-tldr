# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ontopia-tldr"
  s.version = "0.0.1"
  s.platform = "java"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2013-07-30"
  s.description = "Tolog Document Retrieval with Ontopia."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/ontopia-tldr.rb", "lib/ontopia/tldr.rb", "lib/ontopia/tldr/version.rb", "COPYING", "ChangeLog", "README", "Rakefile"]
  s.homepage = "http://github.com/blackwinter/ontopia-tldr"
  s.licenses = ["AGPL"]
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "ontopia-tldr Application documentation (v0.0.1)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Tolog Document Retrieval with Ontopia."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<ontopia-topicmaps>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-nuggets>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<ontopia-topicmaps>, [">= 0"])
      s.add_dependency(%q<ruby-nuggets>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<ontopia-topicmaps>, [">= 0"])
    s.add_dependency(%q<ruby-nuggets>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
  end
end
