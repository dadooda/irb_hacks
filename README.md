Yet another set of IRB hacks
============================

Setup
-----

    $ gem sources --add http://gemcutter.org
    $ gem install irb_hacks

Add to your `~/.irbrc`:

    require "rubygems"
    require "irb_hacks"

Now fire up IRB for a quick test:

    $ irb
    irb> ae
    (snippet)>>

If you see "(snippet)", you're ready to go.


The Hacks
---------

### Code snippets -- `a` and `ae` ###

There's often a need to invoke our work-in-progress code a number of times using the same arguments, wrapping block, etc. For that, "code snippets" feature is quite handy.

`irb_hacks` gem provides the two methods with short, meaningless (and thus conflict-free) names -- `a` and `ae`. `a` means nothing, it's just the first letter of the alphabet. `a` **invokes** the last-edited snippet. `ae` **lets you edit** the actual snippet (it roughly stands for "a" + "edit").

A very basic example:

    irb> ae
    (snippet)>> puts "Hello, world"
    irb> a
    Hello, world

Snippet arguments are supported. It's an array called `args` in snippet context.

    irb> ae
    (snippet)>> p "args", args
    irb> a 10, 1.0, "a string"
    "args"
    [10, 1.0, "a string"]

Snippets work just like normal Ruby methods -- they return the value of the last statement executed.

    irb> ae
    (snippet)>> ["alfa", "zulu", "bravo"] + args
    irb> puts a("charlie").sort
    alfa
    bravo
    charlie
    zulu

Snippets support code blocks. It's a `Proc` called `block` in snippet context. Usage example follows (suppose we're building a simplistic `/etc/passwd` parser).

    irb> ae
    (snippet)>> File.readlines("/etc/passwd").map(&block).each {|s| p s}; nil
    irb> a {|s| ar = s.split(":"); {:name => ar[0], :uid => ar[2]}}
    {:uid=>"0", :name=>"root"}
    {:uid=>"1", :name=>"bin"}
    {:uid=>"2", :name=>"daemon"}
    {:uid=>"3", :name=>"adm"}
    ...

Snippets are **persistent** though IRB invocations. That's quite handy, since not all stuff can be dynamically reloaded and sometimes we have to restart IRB to ensure clean reload.

    irb> ae
    (snippet)>> puts "Snippets are persistent!"
    irb> exit
    $ irb
    irb> a
    Snippets are persistent!

Just in case, snippet history file is called `.irb_snippet_history` in your `$HOME`.

Snippets maintain **their own** Realine history. When you press [Up] and [Down] keys in `ae`, you browse the previously used snippets, not just your previous IRB input. Don't retype the snippet you used yesterday -- press [Up] a couple times and you'll see it.

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
    ## Pressing [Up] will give you...
    (snippet)>> puts "snippet two"
    ## Pressing [Up] again will give you...
    (snippet)>> puts "snippet one"

### Browse program data with GNU `less` ###

Sometimes the data your code works with is too long to fit in a console window. The clearest example of this are variables filled with text content, e.g. [Hpricot](http://github.com/whymirror/hpricot) documents/elements.

To solve that, the greatest paging program of all times, GNU `less`, comes to the rescue.

    $ irb
    irb> files = Dir["/etc/*"].sort
    ## Some bulky array...
    irb> less files
    ## ... which we browse interactively :).

In block form, `less` hack intercepts everything output to `STDOUT` (and, optionally, to `STDERR`), and feeds it to the pager.

    $ irb
    irb> less do
    puts "Hello, world"
    end

Now with `STDERR` capture:

    $ irb
    irb> less(:stderr) do
    puts "to stdout"
    STDERR.puts "to stderr"
    end

To specify another paging program or tweak `less` options, write in your `~/.irbrc`:

    IrbHacks.less_cmd = "more"

, or something else you find appropriate.


Feedback
--------

Send bug reports, suggestions and criticisms through [project's page on GitHub](http://github.com/dadooda/irb_hacks).
