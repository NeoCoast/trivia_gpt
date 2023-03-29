class RoundsController < ApplicationController
  # This line ensures that the user is authenticated before they can access any of the controller's actions.
  before_action :authenticate_user!

  # This action renders the `index` view, which is typically a list of all the rounds in the application.
  def index
  end

  # This action creates a new round object by calling the `round_params` method to ensure that the permitted attributes are used, and assigns it to the current user. If the round is successfully saved, the user is redirected to the root path with a success flash message. Otherwise, an error message is displayed on the new page.
  def create
    @round = current_user.rounds.build(round_params)
    if @round.save
      flash[:success] = "Round created successfully!"
      redirect_to root_path
    else
      flash.now[:error] = "Round could not be created."
      render :new
    end
  end

  # This action sets the `@categories_played` instance variable to the categories associated with the current round, which is then used to display the categories played on the `show` view.
  def show
    @round = current_user.rounds.includes(questions: [:user_answer, :correct_answer]).find(params[:id])
  end

  # This action updates the current round by setting its `ended` attribute to `true`. It is typically called when the round has ended.
  def end_round
    @round = current_user.rounds.find(params[:round_id])
    @round.update(ended: true)
    redirect_to root_path
  end

  private

  # This method permits the `name` attribute when creating a new round, and is used by the `create` action.
  def round_params
    params.require(:round).permit(:name)
  end
end
