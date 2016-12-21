require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'phantomjs'
require 'singleton'

# Example of using
# ps = ProductScrapper.instance
# hash = ps.scrape 'http://www.saxoprint.co.uk/shop/', 'desk-calendars'
class ProductScrapper
  include Capybara::DSL
  include Singleton

  def initialize
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, phantomjs: Phantomjs.path, js_errors: false)
    end
    @session = Capybara::Session.new :poltergeist
  end

  def scrape(url_base, slug)
    @session.visit url_base + slug
    product = { slug: slug }
    product[:title] = @session.find('.shopheadline h1').text
    @session.all('.priceCell').each do |cell|
      case cell[:id]
      when 'customerNetValue' then product[:price_net] = cell.text.tr('£', '')
      when 'customerGrossValue' then product[:price_gross] = cell.text.tr('£', '')
      end
    end
    product
  end
end
