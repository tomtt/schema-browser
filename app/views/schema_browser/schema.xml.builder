schema_browser = SchemaBrowser.new
xml.instruct!
xml.sql {
  schema_browser.tables.each { |table|
    xml.table(table.attributes) {
      table.columns.each { |column|
        xml.row(column.attributes) {
          xml.title(column.name)
          xml.default(column.default)
          xml.type(column.type)
        }
      }
    }
  }

  schema_browser.relations.each { |relation|
    xml.relation {
      xml.table_1(relation.origin_table_id)
      xml.row_1(relation.origin_row_id)
      xml.table_2(relation.destination_table_id)
      xml.row_2(relation.destination_row_id)
    }
  }
}
