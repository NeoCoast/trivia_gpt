class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.boolean :correct
      t.string :text

      t.timestamps
    end
    add_index :answers, :question_id
  end
end
