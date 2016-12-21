require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { create(:user, status: :normal) }
  let(:old_time) { Time.zone.local(2016, 12, 6, 15, 30, 45) }
  let!(:product) { create(:product, slug: 'my-product') }
  let!(:pp_product) { create(:product, slug: 'fifteen-chars-s') }
  let!(:o_product) { create(:product, slug: 'flyers', updated_at: old_time) }

  before { sign_in(user) }

  describe 'POST #show' do
    context 'not exists in db so scrape' do
      valid_url = "#{ENV['URL_BASE_SCRAPPER']}desk-calendars"
      subject { post :show, params: { url: valid_url } }

      it { expect { subject }.to change(Product, :count).by(1) }
      it 'check variables and status' do
        subject
        expect(assigns(:product).slug).to eq 'desk-calendars'
        expect(assigns(:product).valid?).to eq true
        expect(response).to have_http_status(:success)
      end
    end

    context 'exists in db and scrape for update' do
      subject do
        post :show, params: { url: ENV['URL_BASE_SCRAPPER'] + o_product.slug }
      end

      it { expect { subject }.to change { o_product.reload.updated_at } }
      it 'check variables and status' do
        subject
        expect(assigns(:product).slug).to eq o_product.slug
        expect(assigns(:product).valid?).to eq true
        expect(response).to have_http_status(:success)
      end
    end

    context 'get from db' do
      it 'check variables and status' do
        post :show, params: { url: ENV['URL_BASE_SCRAPPER'] + product.slug }
        expect(assigns(:product)).to eq(product)
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid url' do
      it 'check variables and status' do
        post :show, params: { url: ENV['URL_BASE_SCRAPPER'] + 'something-bad' }
        expect(assigns(:product)).to eq nil
        expect(assigns(:error_message)).to eq I18n.t('msg_not_found')
        expect(response).to have_http_status(:success)
      end
    end

    context 'forbidden url' do
      it 'check variables and status' do
        post :show, params: { url: ENV['URL_BASE_SCRAPPER'] + pp_product.slug }
        expect(assigns(:product)).to eq nil
        expect(assigns(:error_message)).to eq I18n.t('msg_prohibited_url')
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #search' do
    subject { get :search }

    it 'show search form' do
      is_expected.to render_template :search
      expect(response).to have_http_status(:success)
    end
  end
end
