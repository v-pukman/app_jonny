RSpec.shared_context "baidu_api_client_with_default_params" do
  let(:api_client) { Baidu::ApiClient.new }
  before do
    api_client.define_singleton_method(:default_params) do |default_params_name|
      self.send(:original_default_params, default_params_name)
    end
    allow(Baidu::ApiClient).to receive(:new).and_return(api_client)
  end
end
