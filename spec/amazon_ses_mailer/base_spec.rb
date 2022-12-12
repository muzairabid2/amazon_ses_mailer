RSpec.describe AmazonSesMailer::Base do
  let(:options) { {} }
  let(:template_name) { 'test template' }
  let(:delivery_method) { nil }
  subject { described_class.new(template_name) }

  describe '#mail' do

    before do
      allow(AmazonSesMailer::Base).to receive(:delivery_method)
        .and_return(delivery_method)
    end

    it 'creates a new message' do
      expect(AmazonSesMailer::Message).to receive(:new)
      subject.mail(options)
    end

    it 'default option contain template name' do
      expect(AmazonSesMailer::Base.new(template_name).default_options[:template] == 'test template')
    end

    it 'it initialize template name and interceptor' do
      expect(AmazonSesMailer::Base.initialize('val')).to eq([])
    end

  end

end
