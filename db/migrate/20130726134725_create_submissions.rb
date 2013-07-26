class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.belongs_to :problem
      t.belongs_to :user
      t.string :language
      t.text :code
      t.string :judge_status
      t.text :judge_result

      t.timestamps
    end
  end
end
