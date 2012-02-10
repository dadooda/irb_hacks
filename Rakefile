require "rake/rdoctask"
require "yaml"

GEM_NAME = "irb_hacks"

begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = GEM_NAME
    gem.summary = "Yet another set of IRB hacks"
    gem.description = "Yet another set of IRB hacks"
    gem.email = "alex.r@askit.org"
    gem.homepage = "http://github.com/dadooda/irb_hacks"
    gem.authors = ["Alex Fortuna"]
    gem.files = FileList[
      "[A-Z]*",
      "*.gemspec",
      "lib/**/*.rb",
    ]
  end
rescue LoadError
  STDERR.puts "This gem requires Jeweler to be built"
end

desc "Rebuild gemspec and package"
task :rebuild => [:gemspec, :build]

desc "Push (publish) gem to RubyGems.org"
task :push do
  # NOTE: Yet found no way to ask Jeweler forge a complete version string for us.
  vh = YAML.load(File.read("VERSION.yml"))
  version = [vh[:major], vh[:minor], vh[:patch], vh[:build]].compact.join(".")
  pkgfile = File.join("pkg", "#{GEM_NAME}-#{version}.gem")
  Kernel.system("gem", "push", pkgfile)
end

desc "Generate RDoc documentation"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.title    = "IrbHacks"
  #rdoc.options << "--line-numbers"
  #rdoc.options << "--inline-source"
  rdoc.rdoc_files.include("lib/**/*.rb")
end
