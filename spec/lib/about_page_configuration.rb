require 'spec_helper'

describe "AboutPage::Configuration" do
  it "" do
    expect(AboutPage.configuration.environment).to be_a_kind_of AboutPage::Environment
  end
end
