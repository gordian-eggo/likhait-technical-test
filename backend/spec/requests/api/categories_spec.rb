require 'rails_helper'

RSpec.describe "Api::Categories", type: :request do
  describe "GET /api/categories" do
    let!(:food) { Category.create!(name: "Food") }
    let!(:transport) { Category.create!(name: "Transport") }
    let!(:supplies) { Category.create!(name: "Supplies") }

    it "returns all categories" do
      get "/api/categories"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.map { |c| c["name"] }).to include("Food", "Transport", "Supplies")
    end

    it "returns categories in alphabetical order" do
      get "/api/categories"

      json = JSON.parse(response.body)
      expect(json.map { |c| c["name"] }).to eq([ "Food", "Supplies", "Transport" ])
    end
  end

  describe "POST /api/categories" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          category: {
            name: "Personal"
          }
        }
      end

      it "posts and creates new category successfully" do
        expect {
          post "/api/categories", params: valid_params, as: :json
        }.to change(Category, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Personal")
      end
    end

    context "with invalid parameters" do
      it "with empty name" do
        no_name_param = {
          category: {
            name: ""
          }
        }

        expect {
          post "/api/categories", params: no_name_param, as: :json
        }.to change(Category, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "with non-string name value" do
        non_string_name = {
          category: {
            name: 100
          }
        }
        expect {
          post "/api/categories", params: non_string_name, as: :json
        }.to change(Category, :count).by(1)
        expect(response).to have_http_status(:created)
       end
    end
  end
end
