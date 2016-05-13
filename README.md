## ORM inspired by the functionality of ActiveRecord
Uses sqlite3 and extensive use of 'active_support/inflector' and heavy use of metaprogramming to explore
functionalities of a web framework application

## How to use
- Create a class that inherits from SQLObject
- If the plural for the class has an irregular conjugation, one can manually set the plural
to specify the table name
`class Human
  self.table_name = "humans"
end`
- Call `self.finalize` at the end of the subclass to create all setters and getters for the class
`class Cat < SQLObject
  finalize!
end`
- If your class that inherits from SQLObject is called `Cat` you can initialize a new `Cat`
`cat = Cat.new(name: "Fluffy", owner_id: 1)`
`cat.name #=>"Fluffy"`
`cat.owner_id #=> 123`
- If you want to fetch all the records from the database. You can call `::all`
If you have a SQLObject `Cat`. Under the hood, ruby takes the query in the form of a hash and
calls `::parse_all` to iterate through the query and create new objects
`Cat.all`
`# SELECT`
`#  cats.*`
`# FROM`
`#  cats  `
- Supports `::find` by using the ruby Hash `find` after querying all records from the database by calling `::all`
`c = Cat.find(1)`
- Supports `#insert` and `#update` via ruby Heredoc
- `#save` calls `#insert` or `#update` upon checking whether the id of the Object is nil or not

- Searchable module takes in a params hash and builds a query to implement via Heredoc

- Can create Associations `belongs_to`, `has_many` and `has_one_through`

## Extensions
- [ ] Write where so that it is lazy and stackable. Implement a Relation class.
- [ ] Validation methods/validator class.
- [ ] has_many :through
- [ ] This should handle both belongs_to => has_many and has_many => belongs_to.
- [ ] Write an includes method that does pre-fetching.
- [ ] joins
