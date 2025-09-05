require 'spec_helper'

describe "the health page", :type => :feature do
  before :all do
    module AboutPage
      class HealthTest < AboutPage::Configuration::Node
        attr_reader :healthy
        validates_each :healthy do |r, a, v|
          r.errors.add(a, message: ': should be healthy') unless v
        end
        def initialize(state, options = {})
          @healthy = state
          @timeout = options[:timeout]
        end
      end
    end
  end

  after :all do
    AboutPage.send(:remove_const, :HealthTest)
  end

  describe "report" do
    before do
      AboutPage.reset!
      AboutPage.configure do |config|
        config.yup  = AboutPage::HealthTest.new(true)
        config.nope = AboutPage::HealthTest.new(false)
      end
    end

    describe "html" do
      before do
        visit('/about/health')
      end

      describe "healthy" do
        before do
          @context = page.find('li[class=component][1]')
        end

        it "should report the service name" do
          expect(@context).to have_content('yup')
        end

        it "should contain an ok status" do
          expect(@context).to have_xpath('span[@class="label label-success"][text() = "ok"]')
        end

        it "should not contain an error list" do
          expect(@context).to_not have_xpath('ul/li[@class="component-error"]')
        end
      end

      describe "unhealthy" do
        before do
          @context = page.find('li[class=component][2]')
        end

        it "should report the service name" do
          expect(@context).to have_content('nope')
        end

        it "should contain an error status" do
          expect(@context).to have_xpath('span[@class="label label-important"][text() = "error"]')
        end

        it "should contain an error list" do
          expect(@context).to have_xpath('ul/li[@class="component-error"]')
          expect(@context).to have_content('healthy : should be healthy')
        end
      end

      describe 'timeout' do
        before do
          timeout = AboutPage::HealthTest.new(false, timeout: 5)
          allow(timeout).to receive(:valid?).and_raise(Timeout::Error)
          AboutPage.configuration[:timeout] = timeout
          visit('/about/health')
          @context = page.find('li[class=component][3]')
        end

        it 'should report the service name' do
          expect(@context).to have_content('timeout')
        end

        it 'should contain an error status' do
          expect(@context).to have_xpath('span[@class="label label-important"][text() = "error"]')
        end

        it 'should contain an error list' do
          expect(@context).to have_xpath('ul/li[@class="component-error"]')
          expect(@context).to have_content('timeout : component check took too long. Timed out after 5 seconds.')
        end
      end
    end
  end
end
