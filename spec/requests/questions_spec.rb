require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "Questions Controller", type: :request do
  describe "GET /rounds/:round_id/questions/:id" do
    let(:user) { create(:user) }
    let(:round) { create(:round, user: user) }
    let(:category) { create(:category) }
    let(:question) { create(:question, round: round, category: category) }

    context "when user is authenticated" do
      before { sign_in user }

      it "displays the question" do
        get round_question_path(round, question)
        expect(response).to have_http_status(200)
        expect(response.body).to include(question.text)
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        get round_question_path(round, question)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /rounds/:round_id/questions" do
    let(:user) { create(:user) }
    let(:round) { create(:round, user: user) }

    context "when question is valid" do
      before { sign_in user }

      it "creates a new question" do
        expect {
          post round_questions_path(round)
        }.to change(Question, :count).by(1)
      end

      it "redirects to the question show page" do
        post round_questions_path(round)
        question = Question.last
        expect(response).to redirect_to(round_question_path(round, question))
      end
    end

    context "when question is invalid" do
      before do
        sign_in user
        allow_any_instance_of(Question).to receive(:save).and_return(false)
      end

      it "does not create a new question" do
        expect {
          post round_questions_path(round)
        }.not_to change(Question, :count)
      end

      it "sets flash error message" do
        post round_questions_path(round)
        expect(flash[:error]).to eq("Question could not be created.")
      end

      it "redirects to the round page" do
        post round_questions_path(round)
        expect(response).to redirect_to(round_path(round))
      end
    end

    context "when user is not authenticated" do
      it "redirects to the sign-in page" do
        post round_questions_path(round)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT /rounds/:round_id/questions/:id' do
    let(:category) { create(:category) }
    let(:user) { create(:user) }
    let(:round) { create(:round, user: user) }
    let(:question) { create(:question, round: round) }

    before do
      sign_in user
    end

    context 'when the OpenAI request is successful' do
      before do
        stub_request(:post, "https://api.openai.com/v1/chat/completions")
          .to_return(
            status: 200,
            body: {
              choices: [
                {
                  message: {
                    content: "What is the capital of France?\nA. Paris\nB. London\nC. Berlin\nD. Madrid\nE. Rome",
                  },
                },
              ],
            }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it 'updates the question with the OpenAI-generated question and answers' do
        put "/rounds/#{round.id}/questions/#{question.id}", params: { category: category.name }

        expect(response).to have_http_status(:success)

        question.reload
        expect(question.text).to eq('What is the capital of France?')
        expect(question.answers.count).to eq(5)
        expect(question.answers.where(correct: true).count).to eq(1)
      end
    end

    context 'when the OpenAI request fails' do
      before do
        stub_request(:post, "https://api.openai.com/v1/chat/completions").to_return(status: 200, body: "", headers: {})
      end

      it 'renders an error message' do
        put "/rounds/#{round.id}/questions/#{question.id}", params: { category: category.name }

        expect(response).to have_http_status(:unprocessable_entity)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('Failed to generate a question. Please try again later.')
      end
    end
  end
end
