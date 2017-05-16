class CreateTestFormBases < ActiveRecord::Migration[ActiveRecord.version.version.split('.')[0..1].join('.')]
  def change
    create_table :test_form_bases do |t|
      t.integer :integer_field
      t.string :string_field
      t.text :text_field
      t.timestamps
    end
  end
end
