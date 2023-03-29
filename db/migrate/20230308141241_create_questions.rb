class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.integer :category_id
      t.integer :round_id
      t.string :text
      t.integer :user_answer_id
      t.integer :correct_answer_id

      t.timestamps
    end
    add_index :questions, :category_id
    add_index :questions, :round_id
    add_index :questions, :user_answer_id
    add_index :questions, :correct_answer_id
  end
end
