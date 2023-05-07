class ResultsController < ApplicationController
  def index
    @game = Game.find(params[:game_id])
    @user = current_user
    # @results = Result.where(user: current_user.id)
    @results = Result.where(game: @game.id, user: current_user)
    if @results.length > 0
      @sum_score = 0
      @results.each do |result|
        @sum_score += result.score.to_i
        # TO REMOVE
        result.edition_int = result.get_edition_int(result.guess)
        result.save
        # TO REMOVE ^
      end
      @results = @results.sort_by(&:edition_int)
      @average = Average.find_by(game: @game, user: current_user)
    end
  end

  def new
    @game = Game.find(params[:game_id])
    @result = Result.new
  end

  def create
    @game = Game.find(params[:game_id])
    @result = Result.new(result_params)
    @result.user = current_user.id
    @result.game = @game.id
    @average = Average.find_by(game: @game, user: current_user)
    @result.score = @result.get_score(@result.guess)
    @result.edition = @result.get_edition(@result.guess)
    @result.display_score = @result.get_display_score(@result.guess)
    @result.edition_int = @result.get_edition_int(@result.guess)
    unless @result.score.nil?
      @result.save!
      unless @average.nil?
        @results = Result.where(game: @game, user: current_user)
        @sum_score = 0
        @results.each do |result|
          @sum_score += result.score.to_i
        end
        @average.average = '%.2f' % (@sum_score / @results.size.to_f)
      else
        @average = Average.new(game: @game.id, user: current_user.id, average: @result.score)
      end
      @average.save!
      redirect_to game_result_path(@game, @result), notice: 'Result noted.'
    else
      redirect_to new_game_result_path(@game), notice: 'Result not valid, try again.'
    end
  end

  def show
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
    @user = User.find(@result.user)
    @edition = @result.edition
    @friends = current_user.following
  end

  def edit
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
  end

  def update
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
    @average = Average.find_by(game: @game, user: current_user)
    @result.score = @result.get_score(@result.guess)
    @result.edition = @result.get_edition(@result.guess)
    @result.display_score = @result.get_display_score(@result.guess)
    @result.edition_int = @result.get_edition_int(@result.guess)
    if @result.update(result_params)
      redirect_to game_result_path(@game, @result)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
    @result.destroy!
    redirect_to game_results_path(@game), status: :see_other
  end

  private

  def result_params
    params.require(:result).permit(:user, :score, :guess, :game)
  end
end
