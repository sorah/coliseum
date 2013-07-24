class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :body
      t.text :test_examples
      t.string :source
      t.text :copyright
      t.references :user, index: true

      t.timestamps
    end
  end
end
