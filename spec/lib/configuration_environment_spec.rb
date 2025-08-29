require 'spec_helper'

describe "AboutPage::Environment" do
  describe "#to_h" do
    it "should" do
      AboutPage::Environment.new.to_h
    end

  end
  it "should" do
    expect(AboutPage::Environment.new).to be_a_kind_of(AboutPage::Environment)
  end
end
