require_relative '03_associatable'

# Phase IV
module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      t_opts = self.class.assoc_options[through_name]
      s_opts = self.class.assoc_options[source_name]

      puts t_opts
      puts s_opts
    end
  end
end
