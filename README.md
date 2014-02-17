Yet another set of IRB hacks
============================

IMPORTANT INFORMATION for Rails 4.0.x users
-------------------------------------------

2014-02-17: I've noticed that under Rails 4.0.2 and Ruby 2.1.0 `irb_hacks`
is badly affecting the development backtrace reporter.
I.e., "We're sorry ..." is displayed even in development environment with no details in logs, too.

This is causing major inconvenience and I'm looking for opportunities to fix this issue when time permits.
Until then, please stay warned.


Setup
-----

~~~
$ gem sources --add http://rubygems.org
$ gem install irb_hacks
~~~

Add to your `~/.irbrc`:

~~~
require "rubygems"
require "irb_hacks"
~~~

Now fire up IRB for a quick test:

~~~
$ irb
irb> ae
(snippet)>>
~~~

If you see `(snippet)`, you're ready to go.


The hacks
---------

### Code snippets -- `a` and `ae` ###

There's often a need to invoke our work-in-progress code a number of times using the same arguments, wrapping block, etc. For that, "code snippets" feature is quite handy.

`irb_hacks` provides the two methods with short, meaningless (and thus conflict-free) names -- `a` and `ae`. `a` means nothing, it's just the first letter of the alphabet. `a` **invokes** the last-edited snippet. `ae` **lets you edit** the actual snippet (it roughly stands for "a" + "edit").

A very basic example:

~~~
irb> ae
(snippet)>> puts "Hello, world!"
irb> a
Hello, world!
~~~

Snippet arguments are supported. It's an array called `args` in snippet context.

~~~
irb> ae
(snippet)>> p "args", args
irb> a 10, 1.0, "a string"
"args"
[10, 1.0, "a string"]
~~~

Snippets work just like normal Ruby methods -- they return the value of the last statement executed.

~~~
irb> ae
(snippet)>> ["alfa", "zulu", "bravo"] + args
irb> puts a("charlie").sort
alfa
bravo
charlie
zulu
~~~

Snippets support code blocks. It's a `Proc` object called `block` in snippet context. Usage example follows. Suppose you're building a simplistic `/etc/passwd` parser. You put the actual reading in the snippet, but do line data manipulation in a block:

~~~
irb> ae
(snippet)>> File.readlines("/etc/passwd").map(&block).each {|s| p s}; nil
irb> a {|s| ar = s.split(":"); {:name => ar[0], :uid => ar[2]}}
{:uid=>"0", :name=>"root"}
{:uid=>"1", :name=>"bin"}
{:uid=>"2", :name=>"daemon"}
{:uid=>"3", :name=>"adm"}
...
~~~

Snippets are **persistent** thoughout IRB invocations. That's quite handy, since not all stuff can be dynamically reloaded and sometimes we have to restart IRB to ensure a clean reload.

~~~
irb> ae
(snippet)>> puts "Snippets are persistent!"
irb> exit
$ irb
irb> a
Snippets are persistent!
~~~

Just in case, snippet history file is called `~/.irb_snippet_history` by default.

Snippets maintain **their own** Readline history. When you press [Up] and [Down] keys in `ae`, you browse the previously used snippets, not just your previous IRB input. So don't retype the snippet you used yesterday -- press [Up] a few times and you'll see it.

~~~
irb> ae
(snippet)>> puts "snippet one"
irb> hala
irb> bala
irb> ae
(snippet)>> puts "snippet two"
irb> foo
irb> moo
irb> ae
(snippet)>>
# Pressing [Up] will give you...
(snippet)>> puts "snippet two"
# Pressing [Up] again will give you...
(snippet)>> puts "snippet one"
~~~

You can configure some aspects of the snippets. Read "Configuration" chapter below.


### Browse program data with GNU `less` ###

Sometimes the data your code works with is too long to fit in a console window. The clearest example of this are variables filled with text content, e.g. [Hpricot](http://github.com/whymirror/hpricot) documents/elements.

To solve that, the greatest paging program of all times, GNU `less`, comes to the rescue.

~~~
$ irb
irb> files = Dir["/etc/*"].sort
# Some bulky array...
irb> less files
# ...which you browse interactively!
~~~

In block form, `less` hack intercepts everything output to `STDOUT` (and, optionally, to `STDERR`), and feeds it to the pager.

~~~
$ irb
irb> less do
puts "Hello, world"
end
~~~

Now with `STDERR` capture:

~~~
$ irb
irb> less(:stderr) do
puts "to stdout"
STDERR.puts "to stderr"
end
~~~

You can configure which pager program to use and with which options. Read "Configuration" chapter below.


### Break execution and return instant value ###

By using `IrbHacks.break(value)` you break snippet (`a`) execution and make it return `value`. This is a simple yet powerful debugging technique.

Suppose you're debugging the code which contains something like:

~~~
csv.each_with_index do |fc_row, i|
  row = Hash[*fc_row.map {|k, v| [(k.to_sym rescue k), (v.to_s.strip rescue v)]}.flatten(1)]
  ...
~~~

There's something wrong with the code and you want to see if `row` is given the correct value. To do it, use `IrbHacks.break`:

~~~
csv.each_with_index do |fc_row, i|
  row = Hash[*fc_row.map {|k, v| [(k.to_sym rescue k), (v.to_s.strip rescue v)]}.flatten(1)]
  IrbHacks.break(row)
~~~

Now all you have to do is write an `ae` snippet and call it. `row` value will be available in IRB for inspection:

~~~
irb> ae
(snippet)>> Klass.new.method(args)
irb> row = a
# Back in IRB. Do whatever you want with `row` value now.
irb>
~~~

Each `IrbHacks.break` call raises an `IrbHacks::BreakException`. If you see them popping out runtime, find the appropriate `IrbHacks.break` calls and defuse them.


Configuration
-------------

Via `IrbHacks.conf` object you can configure various features of `irb_hacks`. Add `IrbHacks.conf` manipulation code to your `.irbrc`:

~~~
require "rubygems"
require "irb_hacks"

IrbHacks.conf.snippet_prompt = ">>> "
~~~

### Configuration variables (`IrbHacks.conf.*`)###

* `less_cmd` -- System command to invoke pager for `less`.
* `snippet_history_file` -- Snippet (`a`, `ae`) history file.
* `snippet_history_size` -- Snippet history size.
* `snippet_prompt` -- Snippet input prompt.


Copyright
---------

Copyright &copy; 2010-2012 Alex Fortuna.

Licensed under the MIT License.


Feedback
--------

Send bug reports, suggestions and criticisms through [project's page on GitHub](http://github.com/dadooda/irb_hacks).
