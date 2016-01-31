require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    keys, values = params.keys, params.values
    where_line = keys.map!{|k| "#{k} = ?"}.join(" AND ")

    result = DBConnection.instance.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
         #{where_line}
    SQL
    result.map{|obj| self.new(obj)}
  end
end

class SQLObject
  extend Searchable
end
