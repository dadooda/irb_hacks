module IrbHacks
  # IrbHacks configuration object.
  class Config
    # System command to invoke pager for <tt>less</tt>. Default:
    #
    #   less -R
    attr_accessor :less_cmd

    # Snippet (<tt>a</tt>, <tt>ae</tt>) history file. Default:
    #
    #   ~/.irb_snippet_history
    attr_accessor :snippet_history_file

    # Snippet history size. Default is <tt>100</tt>.
    attr_accessor :snippet_history_size

    # Snippet input prompt. Default:
    #
    #   (snippet)>>
    attr_accessor :snippet_prompt

    def initialize(attrs = {})
      defaults = {
        :less_cmd => "less -R",
        :snippet_history_file => "~/.irb_snippet_history",
        :snippet_history_size => 100,
        :snippet_prompt => "(snippet)>> ",
      }

      defaults.merge(attrs).each {|k, v| send("#{k}=", v)}
    end
  end
end
