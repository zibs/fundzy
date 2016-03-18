require 'rails_helper'

RSpec.describe "discussions/new", type: :view do
  before(:each) do
    assign(:discussion, Discussion.new(
      :title => "MyString",
      :body => "MyString"
    ))
  end

  it "renders new discussion form" do
    render

    assert_select "form[action=?][method=?]", discussions_path, "post" do

      assert_select "input#discussion_title[name=?]", "discussion[title]"

      assert_select "input#discussion_body[name=?]", "discussion[body]"
    end
  end
end
