class ProductsController < ApplicationController
  before_action :authenticate_user!, :set_user
  before_action :set_scrapper, only: [:show]

  def show
    slug = get_slug(params[:url])
    if @user.allowed? slug
      product = Product.find_by slug: slug
      if !product.nil? && get_hours_from(product.updated_at) < 24
        @product = product
      else
        try_scrape slug
      end
    else
      @error_message = t('msg_prohibited_url')
    end
  end

  private

  def try_scrape(slug)
    product = @scrapper.scrape(ENV['URL_BASE_SCRAPPER'], slug)
    @product = Product.find_or_initialize_by(slug: slug)
    @product.title = product[:title]
    @product.price_net = product[:price_net]
    @product.price_gross = product[:price_gross]
    @product.save
  rescue Capybara::ElementNotFound
    @error_message = t('msg_not_found')
  rescue Capybara::Poltergeist::StatusFailError
    @error_message = t('msg_problem_with_connection')
  end

  def get_slug(url)
    matcher = url.match(/^#{ENV['URL_BASE_SCRAPPER']}([\w-]+)$/)
    matcher.captures[0] unless matcher.nil?
  end

  def get_hours_from(time)
    (Time.parse(DateTime.now.to_s) - Time.parse(time.to_s)) / 3600
  end

  def set_scrapper
    @scrapper = ::ProductScrapper.instance
  end

  def set_user
    @user = current_user
  end
end
