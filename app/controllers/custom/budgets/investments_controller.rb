require_dependency Rails.root.join("app", "controllers", "budgets", "investments_controller").to_s

class Budgets::InvestmentsController
  before_action :load_categories, only: [:index, :new, :create, :edit]

  def edit
  end

  def update
    @investment.update(investment_params)
    redirect_to budget_investment_path(@budget, @investment),
                notice: t("budgets.investments.form.updated_notice")
  end
end
