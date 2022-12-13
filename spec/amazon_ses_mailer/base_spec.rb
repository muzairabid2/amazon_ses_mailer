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

    it 'should return values into string' do
      expect(AmazonSesMailer::Base.transform_value('string')).to eq('string')
    end

    it 'should not return string into array' do
      expect(AmazonSesMailer::Base.transform_value('string')).not_to eq(["1","2","3"])
    end

    it 'should return empty string it nil encounters' do
      expect(AmazonSesMailer::Base.transform_value(nil)).to eq('')
    end

    it 'should not return nil' do
      expect(AmazonSesMailer::Base.transform_value(nil)).not_to eq(nil)
    end

    it 'should return array if it encounters a array' do
      expect(AmazonSesMailer::Base.transform_value([1,2,3])).to eq(["1","2","3"])
    end

    it 'should not return array into string' do
      expect(AmazonSesMailer::Base.transform_value([1,2,3])).not_to eq('string')
    end

    it 'should return hash if it encounters a hash' do
      expect(AmazonSesMailer::Base.transform_value({value: "val"})).to eq({value: "val"})
    end

    it 'should not return hash into string' do
      expect(AmazonSesMailer::Base.transform_value({value: "val"})).not_to eq('string')
    end

    it 'should return hash into json' do
      expect(AmazonSesMailer::Base.process_merge_vars({value: "val"})).to eq({value: "val"}.to_json)
    end

    it 'should not return hash into hash' do
      expect(AmazonSesMailer::Base.process_merge_vars({value: "val"})).not_to eq({value: "val"})
    end

  end

end
