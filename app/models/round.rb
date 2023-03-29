class Round < ApplicationRecord
  belongs_to :user
  has_many :questions
  has_many :categories, through: :questions
  has_many :user_answers, through: :questions

  def questions_played
    questions.count
  end

  def score
    user_answers.where(correct: true).count
  end
end
