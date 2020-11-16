require "rails_helper"

RSpec.describe "", type: :request do
  describe "" do
    it "正常なレスポンスを返すこと" do
      get root_path
      expect(response).to be_success
      expect(response). have_http_status "200"
    end
  end
end
