class SchemaColumn
  attr_reader :default, :name, :column_id
  attr_accessor :index, :foreign_key, :primary_key

  @@last_id = 0

  def initialize(ar_column)
    @name = ar_column.name
    @type = ar_column.type
    @default = ar_column.default
    @column_id = get_id
  end

  def title
    @name
  end

  def type
    @type.to_s.capitalize
  end

  def attributes
    attr = { "id" => @column_id.to_s }
    attr["fk"] = "fk" if @foreign_key
    attr["pk"] = "pk" if @primary_key
    attr["index"] = "index" if @index
    attr
  end

  protected

  def get_id
    @@last_id += 1
  end
end
