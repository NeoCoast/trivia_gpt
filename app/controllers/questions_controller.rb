class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_round

  def show
    @question = Question.find(params[:id])
  end

  def create
    unless @round.ended
      @question = @round.questions.build
      if @question.save
        redirect_to round_question_path(@round, @question)
      else
        flash.now[:error] = "Question could not be created."
        redirect_to round_path(@round)
      end
    else
      flash.now[:error] = "Round has ended."
      redirect_to round_path(@round)
    end
  end

  def update
    @question = Question.find(params[:id])
    unless @question.round.ended
      category = Category.find_or_create_by(name: params[:category])
      @question.category = category

      openai_client = OpenAI::Client.new
      prompt = "Generate a random multiple choice question for the category #{category.name} with 5 possible answers, one of them MUST be correct. First line should be the question, the following 5 lines should be an answer each, no extra lines before or after. Make the correct answer allways be the first one, and retrain from including letters nor numbers indexing the possible answers
      example: Question? n valid_answer \n invalid \n invalid \n invalid \n invalid"
      response = openai_client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: prompt}],
          temperature: 0.7,
        }
      )

      if response.parsed_response
        # Parse the API response to get the question and answers
        answer_texts = response.dig("choices", 0, "message", "content").split("\n").map(&:strip).reject(&:empty?)
        question_text = answer_texts.shift
        correct_answer_text = answer_texts.first

        # Create the question and answers
        @question.text = question_text
        @question.answers.destroy_all # Remove existing answers
        answer_texts.shuffle.take(5).each do |answer_text|
          correct = answer_text == correct_answer_text
          answer = @question.answers.build(text: answer_text, correct: correct)
          @question.correct_answer = answer if correct
        end

        @question.save

        render json: { url: round_question_path(@round, @question) }
      else
        render json: { error: "Failed to generate a question. Please try again later." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Round has ended." }, status: :bad_request
    end
  end

  def answer
    @question = Question.find(params[:id])
    @question.update(question_params)
    redirect_to round_path(@round)
  end

  private

  def set_round
    @round = Round.find(params[:round_id])
  end

  def question_params
    params.require(:question).permit(:user_answer_id)
  end
end
