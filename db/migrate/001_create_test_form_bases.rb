class CreateTestFormBases < ActiveRecord::Migration[ENV["RAILS_VERSION"]]
  def change
    puts "here"
    create_table :test_form_bases do |t|
      t.integer :integer_field
      t.string :string_field
      t.text :text_field
      t.timestamps
    end
  end
end
