require "rails_helper"
require "sessions_helper"

describe "Budget Investments" do

  let(:author)      { create(:user, :level_two) }
  let(:budget)      { create(:budget) }
  let(:group)       { create(:budget_group, budget: budget) }
  let(:heading)     { create(:budget_heading, group: group) }
  let!(:investment) { create(:budget_investment, heading: heading, author: author, title: "Old title") }

  context "Edit" do

    before { login_as(author) }

    scenario "Author can edit own budget investment from my activity" do
      visit user_path(author, tab: :budget_investments)
      within("#budget_investment_#{investment.id}") do
        expect(page).to have_link "Edit"
      end

      click_link "Edit"
      fill_in "budget_investment_title", with: "New title"
      click_button "Update Investment"

      visit budget_investment_path(budget, investment)
      expect(page).to have_content "New title"
      expect(page).not_to have_content "Old title"
    end

    scenario "Author can edit own budget investment from show" do
      visit budget_investment_path(budget, investment)
      expect(page).to have_content "Old title"
      expect(page).to have_link "Edit"

      click_link "Edit"
      fill_in "budget_investment_title", with: "New title"
      click_button "Update Investment"

      visit budget_investment_path(budget, investment)
      expect(page).to have_content "New title"
      expect(page).not_to have_content "Old title"
    end

    scenario "User cannot edit budget investment of another author" do
      not_author = create(:user, :level_two)

      login_as(not_author)
      visit budget_investment_path(budget, investment)
      expect(page).not_to have_link "Edit"

      visit edit_budget_investment_path(investment.budget, investment)
      expect(page).to have_content "You do not have permission to carry out the action 'edit' on budget/investment"
    end

    scenario "Edit button only appears on accepting phase" do
      visit budget_investment_path(budget, investment)
      expect(page).to have_link "Edit"

      %w[reviewing selecting valuating publishing_prices balloting reviewing_ballots finished].each do |phase|
        budget.update(phase: phase)

        visit budget_investment_path(budget, investment)
        expect(page).not_to have_link "Edit"
      end
    end
  end
end
