class SchemaRelation
  attr_reader :origin_table_id, :origin_row_id, :destination_table_id, :destination_row_id

  def initialize(oti, ori, dti, dri)
    @origin_table_id = oti
    @origin_row_id = ori
    @destination_table_id = dti
    @destination_row_id = dri
  end
end
