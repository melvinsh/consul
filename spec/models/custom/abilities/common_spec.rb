require "rails_helper"
require "cancan/matchers"

describe Abilities::Common do
  subject(:ability) { Ability.new(user) }

  let(:geozone)     { create(:geozone)  }

  let(:user) { create(:user, geozone: geozone) }

  let(:accepting_budget) { create(:budget, phase: "accepting") }
  let(:reviewing_budget) { create(:budget, phase: "reviewing") }
  let(:selecting_budget) { create(:budget, phase: "selecting") }
  let(:balloting_budget) { create(:budget, phase: "balloting") }

  let(:investment_in_accepting_budget) { create(:budget_investment, budget: accepting_budget) }
  let(:investment_in_reviewing_budget) { create(:budget_investment, budget: reviewing_budget) }
  let(:investment_in_selecting_budget) { create(:budget_investment, budget: selecting_budget) }
  let(:investment_in_balloting_budget) { create(:budget_investment, budget: balloting_budget) }
  let(:own_investment_in_accepting_budget) { create(:budget_investment, budget: accepting_budget, author: user) }
  let(:own_investment_in_reviewing_budget) { create(:budget_investment, budget: reviewing_budget, author: user) }
  let(:own_investment_in_selecting_budget) { create(:budget_investment, budget: selecting_budget, author: user) }
  let(:own_investment_in_balloting_budget) { create(:budget_investment, budget: balloting_budget, author: user) }

  describe "when level 2 verified" do
    before{ user.update(residence_verified_at: Time.current, confirmed_phone: "1") }

    describe "Budgets" do
      it { should be_able_to(:edit, own_investment_in_accepting_budget) }
      it { should_not be_able_to(:edit, own_investment_in_reviewing_budget) }
      it { should_not be_able_to(:edit, own_investment_in_selecting_budget) }
      it { should_not be_able_to(:edit, own_investment_in_balloting_budget) }

      it { should_not be_able_to(:edit, investment_in_accepting_budget) }
      it { should_not be_able_to(:edit, investment_in_accepting_budget) }
      it { should_not be_able_to(:edit, investment_in_accepting_budget) }
      it { should_not be_able_to(:edit, investment_in_accepting_budget) }
    end
  end

end
