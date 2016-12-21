require 'rails_helper'

RSpec.feature 'Products', type: :feature do
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def submit_form
    find("form input[value='#{I18n.t('btn_search')}']").click
  end

  let!(:user) { create :user, status: :normal }
  let!(:product) { create(:product, slug: 'my-product') }
  let!(:pp_product) { create(:product, slug: 'fifteen-chars-s') }
  before { sign_in user }

  context 'products exist in db' do
    it 'show search form' do
      visit products_search_url
      expect(page).to have_css('form input#url')
      expect(find("form input[value='#{I18n.t('btn_search')}']")).to be_visible
    end

    it 'display product' do
      visit products_search_url
      fill_in 'url', with: "#{ENV['URL_BASE_SCRAPPER']}#{product.slug}"
      submit_form
      page.assert_selector('td', count: 4)
      expect(all('tr td')[0]).to have_text(product.slug)
      expect(all('tr td')[1]).to have_text(product.title)
      expect(all('tr td')[2]).to have_text(product.price_net)
      expect(all('tr td')[3]).to have_text(product.price_gross)
    end
  end

  context 'not exist url' do
    it 'show message' do
      visit products_search_url
      fill_in 'url', with: "#{ENV['URL_BASE_SCRAPPER']}something-bad"
      submit_form
      expect(find('.alert.alert-danger'))
        .to have_text(I18n.t('msg_not_found'))
    end
  end

  context 'forbidden url' do
    it 'show message' do
      visit products_search_url
      fill_in 'url', with: "#{ENV['URL_BASE_SCRAPPER']}#{pp_product.slug}"
      submit_form
      expect(find('.alert.alert-danger'))
        .to have_text(I18n.t('msg_prohibited_url'))
    end
  end
end
