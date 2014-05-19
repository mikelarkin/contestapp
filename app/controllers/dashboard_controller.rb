class DashboardController < ApplicationController
  def index
    # Load past results in reverse order
    @contests = Contest.order("created_at desc")

    # Instantiate a new Contest so the form loads properly
    @contest = Contest.new

    # Load the Products we want to use for Contests
    @products = Product.all.order(:name)

  end


  # This method creates a Contest and returns the winner(s) in the
  # notice message
  def create_contest
    @contest = Contest.new(contest_params)

    # Store the name of the product for easier readability
    @contest.product_name = Product.find_by_shopify_product_id(contest_params[:product_id]).try(:name) if contest_params[:product_id].present?

    respond_to do |format|
      if @contest.save
        # Pick a winner
        candidates = Order.candidate_list(params)
        contest_results = ContestResults.new(candidates)

        # Save the winner        
        @contest.update_attribute(:order_id, contest_results.results)

        format.html { redirect_to root_path, notice: "Contest Winner: <a href='#{order_path(@contest.order)}'>#{@contest.order.email}</a>" }
        format.json { render action: 'show', status: :created, location: @contest }

      else
        format.html { redirect_to root_path, alert: "Unable to create a Contest #{@contest.errors.full_messages.to_s}" }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def contest_params
    params.require(:contest).permit(:name, :product_id, :start_date, :end_date, :max_results, :order_id, :criteria)
  end


end
