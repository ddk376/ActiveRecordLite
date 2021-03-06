require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    return @columns if @columns
    results = DBConnection.execute2("SELECT * FROM #{self.table_name}")
    @columns = results.first.map!(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |entry|
      define_method(entry) { self.attributes[entry] }

      define_method("#{entry}=") {|val| self.attributes[entry] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.name.underscore.pluralize
  end

  def self.all
    results = DBConnection.execute("SELECT * FROM #{self.table_name}" )
    parse_all(results)
  end

  def self.parse_all(results)
    results.map{ |result| self.new(result) }
  end

  def self.find(id)
    self.all.find {|obj| obj.id == id }
  end

  def initialize(params = {})
    params.each do |key, value|
      attr_name = key.to_sym
      raise "unknown attribute '#{attr_name}'"  unless self.class.columns.include?(attr_name)
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map{|col| attributes[col]}
  end

  def insert
    col_names = self.class.columns.drop(1).join(",")

    question_marks = []
    (self.class.columns.length-1).times { question_marks << "?"}
    question_marks = question_marks.join(",")
    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
         (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_phrase = self.class.columns.drop(1).map{|attr_name| attr_name.to_s + " = ?"}.join(',')
    attr_vals = attribute_values
    attr_vals.rotate!
    DBConnection.execute(<<-SQL, *attr_vals )
      UPDATE
        #{self.class.table_name}
      SET
        #{set_phrase}
      WHERE
        id = ?
      SQL
  end

  def save
     self.id.nil? ? self.insert : self.update
  end
end
