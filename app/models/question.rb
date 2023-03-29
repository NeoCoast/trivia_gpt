class Question < ApplicationRecord
  belongs_to :round
  belongs_to :category, optional: true
  has_many :answers
  belongs_to :user_answer, class_name: "Answer", optional: true
  belongs_to :correct_answer, class_name: "Answer", optional: true
end
