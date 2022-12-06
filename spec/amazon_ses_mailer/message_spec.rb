RSpec.describe AmazonSesMailer::Message do

  let(:options) { {} }
  let(:interceptors) { [] }
  let(:delivery_proc) { nil }
  subject { described_class.new(options, interceptors, delivery_proc) }

  describe '#send_email' do

    before do
      subject.deliver
    end

    it 'deliver the email' do
      expect(AmazonSesMailer::Message).to receive(:send_email)
    end

  end

end