class Addindexes < ActiveRecord::Migration
  def change
    add_index :submissions, :user_id
    add_index :submissions, [:user_id, :judge_status]
    add_index :submissions, :problem_id
    add_index :submissions, :judge_status
  end
end
