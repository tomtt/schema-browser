module SchemaSpecHelper
  def stub_tables(tables)
    ActiveRecord::Base.connection.stub!(:tables).and_return(tables + ["schema_info"])
    # return empty array for indexes method by default
    ActiveRecord::Base.connection.stub!(:indexes).and_return([])

    @relations ||= {}

    tables.each do |table|
      eval "class #{table.classify};end"
      @relations[table] ||= []
      table_class = table.classify.constantize
      table_class.stub!(:reflect_on_all_associations).and_return(@relations[table])
      table_class.stub!(:primary_key).and_return("id")
    end
  end

  def add_relation(model, reference)
    @relations[model.tableize] << create_relation(model, reference)
  end

  def create_relation(model, reference, options = {})
    relation = mock("#{model}_relation")
    relation.stub!(:name).and_return(reference.to_sym)
    relation.stub!(:class_name).and_return(reference.camelize)
    relation.stub!(:primary_key_name).and_return("#{reference}_id")
    relation.stub!(:options).and_return(options)
    relation
  end

  def stub_columns(tables)
    @stubbed_columns = {}
    tables.each do |table|
      @stubbed_columns[table] = []
      ActiveRecord::Base.connection.stub!(:columns).with(table).and_return(@stubbed_columns[table])
    end
  end

  def add_mock_column(table, column, options = {})
    @stubbed_columns[table] << mock_column(column, options)
  end

  def add_mock_index(table, column)
    @stubbed_indexes ||= {}
    @stubbed_indexes[table] ||= []
    mock_column = mock("column")
    mock_column.stub!(:name).and_return("index_#{table}_on_#{column}")
    @stubbed_indexes[table] << mock_column
    ActiveRecord::Base.connection.stub!(:indexes).with(table).and_return(@stubbed_indexes[table])
  end

  def mock_column(name, options)
    col = mock("column")
    col.stub!(:name).and_return(name)
    col.stub!(:primary).and_return(options[:primary] ? options[:primary] : nil)
    col.stub!(:default).and_return(options[:default] ? options[:default] : nil)
    col.stub!(:type).and_return(options[:type])
    col
  end
end
