require 'rails_helper'

RSpec.describe "Memos", type: :request do
  describe "GET /memos" do
    it "works! (now write some real specs)" do
      get memos_index_path
      expect(response).to have_http_status(200)
    end
  end
end
