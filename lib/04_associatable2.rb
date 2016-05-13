require_relative '03_associatable'

module Associatable
  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      t_table = through_options.table_name
      t_pk = through_options.primary_key
      t_fk = through_options.foreign_key

      s_table = source_options.table_name
      s_pk = source_options.primary_key
      s_fk = source_options.foreign_key

      key_val = self.send(t_pk)

      results = DBConnection.execute(<<-SQL, key_val)
        SELECT
          #{s_table}.*
        FROM
          #{t_table}
        JOIN
          #{s_table}
        ON
          #{t_table}.#{s_fk} = #{s_table}.#{s_pk}
        WHERE
          #{t_table}.#{t_pk} = ?
      SQL
      source_options.model_class.parse_all(results).first
    end
  end
end
