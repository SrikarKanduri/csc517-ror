require 'rails_helper'

RSpec.describe "reviews/index", type: :view do
  before(:each) do
    assign(:reviews, [
      Review.create!(
        :subject => "Subject",
        :message => "MyText"
      ),
      Review.create!(
        :subject => "Subject",
        :message => "MyText"
      )
    ])
  end

  it "renders a list of reviews" do
    render
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
