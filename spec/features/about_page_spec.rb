require 'spec_helper'

describe "the about page", :type => :feature do
  before :all do
    AboutPage.reset!

    AboutPage.configure do |config|
      config.app = { :name => 'Application Name', :version => '0.0.0' }

      config.dependencies = AboutPage::Dependencies.new

      config.environment = AboutPage::Environment.new({ 
        'Ruby' => /^(RUBY|GEM_|rvm)/
      })

      config.request = AboutPage::RequestEnvironment.new({
        'HTTP Server' => /^(SERVER_|POW_)/,
        'WebAuth' => /^WEBAUTH_/
      })
    end
  end
  describe "dependency versions" do
    before do
      visit("/about")
    end

    it "should contain a list of dependencies" do
      expect(page).to have_content "about_page"
    end
  end

  describe "environment section" do
    before do
      visit("/about")
    end

    it "should contain a list of environment variables" do
      expect(page).to have_content "GEM_HOME"
    end
  end

  describe "xml" do
    before do
      visit("/about.xml")
    end
    
    it "should" do
      expect(page.response_headers['Content-Type']).to match(/xml/)
      expect(page.body).to_not be_empty
    end
  end

  describe "json" do
    before do
      visit("/about.json")
    end
    
    it "should" do
      expect(page.response_headers['Content-Type']).to match(/json/)
      expect(page.body).to_not be_empty
    end
  end

  describe "yaml" do
    before do
      visit("/about.yaml")
    end

    it "should" do
      expect(page.response_headers['Content-Type']).to match(/yaml/)
      expect(page.body).to_not be_empty
    end
  end
end
