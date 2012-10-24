class SchemaTable
  @@tables = {}
  @@last_id = 0

  attr_reader :columns, :table_id, :primary_key_column, :relations

  def initialize(table_name)
    @table_id = get_id
    @name = table_name
    @relations = []
    @@tables[table_name] = self
    @columns = ActiveRecord::Base.connection.columns(table_name).map { |c| SchemaColumn.new(c) }
    set_indexes
    set_primary_key
  end

  def column(name)
    @columns.select { |c| c.name == name }[0]
  end

  def attributes
    attr = { "id" => @table_id.to_s,
             :title => @name }
    attr
  end

  def create_relation(reflection)
    referenced_table = @@tables[reflection.class_name.tableize]
    from_column_name = reflection.foreign_key.to_s
    raise "Field '#{from_column_name}' that should reference #{reflection.class_name} is not present in the database" if column(from_column_name).nil?
    column(from_column_name).foreign_key = true
    return if reflection.options[:polymorphic]
    return if referenced_table.nil? # bail out if referenced table could not be found for other reason
    @relations << SchemaRelation.new(@table_id,
                                     column(from_column_name).column_id,
                                     referenced_table.table_id,
                                     referenced_table.primary_key_column.column_id)
  end

  def gather_relations
    return unless instantiated?
    my_class.reflect_on_all_associations(:belongs_to).each do |reflection|
      create_relation(reflection)
    end
  end

  protected

  def get_id
    @@last_id += 1
  end

  def set_indexes
    @indexes = ActiveRecord::Base.connection.indexes(@name)
    @indexes.each do |index|
      column_name = get_column_name_from_index_name(index.name)
      if column_name
        if column(column_name)
          column(column_name).index = true
        end
      end
    end
  end

  def set_primary_key
    return unless instantiated?
    column_name = my_class.primary_key
    @primary_key_column = column(column_name)
    if @primary_key_column
      @primary_key_column.primary_key = true
    end
  end

  def get_column_name_from_index_name(index_name)
    index_name =~ Regexp.new("index_#{@name}_on_(.*)")
    $1
  end

  def my_class
    @name.classify.constantize
  end

  def instantiated?
    begin
      my_class
    rescue
      return false
    end
    return true
  end
end
