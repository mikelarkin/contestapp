class AccountsController < ApplicationController
    before_action :set_account, only: [:edit, :update]
    before_action :require_login

    # GET /account
    def edit
    end

    # PATCH/PUT /account
    # PATCH/PUT /account
    def update
        respond_to do |format|
            if @account.update(account_params)
                format.html { redirect_to account_path, notice: 'Account was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @account.errors, status: :unprocessable_entity }
            end
        end
    end

    private

    def set_account
        @account = current_account
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
        params.require(:account).permit(:paid)
    end
end
