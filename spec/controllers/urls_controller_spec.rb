require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe "GET #new" do
    it "assigns a new Url to @url" do
      get :new
      expect(assigns(:url)).to be_a_new(Url)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Url" do
        expect {
          post :create, params: { url: { long_url: "http://example.com" } }
        }.to change(Url, :count).by(1)
      end

      it "redirects to the show page" do
        post :create, params: { url: { long_url: "http://example.com" } }
        expect(response).to redirect_to(url_path(Url.last))
      end

      it "sets a success flash message" do
        post :create, params: { url: { long_url: "http://example.com" } }
        expect(flash[:notice]).to eq("Short URL created successfully!")
      end
    end

    context "with invalid params" do
      it "does not create a new Url" do
        expect {
          post :create, params: { url: { long_url: "" } }
        }.not_to change(Url, :count)
      end

      it "renders the new template with an error message" do
        post :create, params: { url: { long_url: "" } }
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq("Failed to create short URL.")
      end
    end
  end

  describe "GET #show" do
    let!(:url) { Url.create(long_url: "http://example.com", short_url: SecureRandom.hex(4)) }

    it "assigns the requested Url to @url" do
      get :show, params: { id: url.id }
      expect(assigns(:url)).to eq(url)
    end

    it "renders the show template" do
      get :show, params: { id: url.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #redirect" do
    let!(:url) { Url.create(long_url: "http://example.com", short_url: SecureRandom.hex(4)) }

    context "when the short URL exists" do
      it "redirects to the long URL" do
        get :redirect, params: { short_url: url.short_url }
        expect(response).to redirect_to(url.long_url)
      end
    end

    context "when the short URL does not exist" do
      it "returns a not found message" do
        get :redirect, params: { short_url: "nonexistent" }
        expect(response.body).to eq("Short URL not found")
        expect(response.status).to eq(404)
      end
    end
  end
end
