class GenerateStatistics < ActiveRecord::Migration
  def change
    create_table :mad_lib_terms do |t|
      t.string :name
    end
    create_table :mad_lib_fields do |t|
      t.string :name
    end
  end
end
