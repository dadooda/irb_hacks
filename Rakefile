require "yaml"
#require 'rake/gempackagetask'

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
  # Yet found no way to ask Jeweler forge a complete version string for us.
  vh = YAML.load(File.read("VERSION.yml"))
  version = [vh[:major], vh[:minor], vh[:patch], (if (v = vh[:build]); v; end)].compact.join(".")
  pkgfile = File.join("pkg", [GEM_NAME, "-", version, ".gem"].join)
  Kernel.system("gem", "push", pkgfile)
end

#Rake::GemPackageTask.new(spec) do |p|
#  p.need_tar = true if RUBY_PLATFORM !~ /mswin/
#end

desc "Compile README preview"
task :readme do
  require "kramdown"

  doc = Kramdown::Document.new(File.read "README.md")

  fn = "README.html"
  puts "Writing '#{fn}'..."
  File.open(fn, "w") do |f|
    f.write(File.read "dev/head.html")
    f.write(doc.to_html)
  end
  puts ": ok"
end
