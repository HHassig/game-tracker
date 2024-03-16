class ResultsController < ApplicationController
  def index
    @game = Game.find(params[:game_id])
    @average = get_average(@game, current_user)
    @results = Result.where(game: @game.id, user: current_user)
    @results = @results.sort_by(&:edition_int).reverse
    @results = @results.paginate(:page => params[:page], per_page: 8)
    # @results = @results.paginate(:page => params[:page])
    # @results = @results.reorder("edition")
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
    @result.score = @result.get_score(@result.guess)
    @result.edition = @result.get_edition(@result.guess)
    @result.display_score = @result.get_display_score(@result.guess)
    @result.edition_int = @result.get_edition_int(@result.guess)
    unless @result.score.nil?
      @result.save!
      set_average(@game, current_user)
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
    @friends = Follow.where(followee: current_user.id)
    @results = Result.where(game: @game, edition: @edition)
    @leader = User.find(@results.min_by(&:score).user)
  end

  def edit
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
  end

  def update
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
    @result.score = @result.get_score(@result.guess)
    @result.edition = @result.get_edition(@result.guess)
    @result.display_score = @result.get_display_score(@result.guess)
    @result.edition_int = @result.get_edition_int(@result.guess)
    @average = set_average(@game, current_user)
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

  def set_average(game, user)
    results = Result.where(game: @game, user: current_user)
    if Average.find_by(game: game, user: user).nil?
      avg = Average.create!(game: game, user: user, average: results.first.score)
    else
      avg = Average.find_by(game: game, user: user)
      sum_score = 0
      results.each do |result|
        sum_score += result.score.to_i
      end
      avg.average = '%.2f' % (sum_score / results.size.to_f)
      avg.save!
    end
    return avg
  end

  def get_average(game, user)
    return 0 unless Average.find_by(game: game, user: user).nil?
    return Average.find_by(game: game, user: user)
  end
end
