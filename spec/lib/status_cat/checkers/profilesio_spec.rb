describe StatusCat::Checkers::Profilesio do

  let(:checker) { StatusCat::Checkers::Profilesio.new.freeze }
  let(:response) { double('response', code: 200) }
  let(:key) { 'env_profilesio_key' }

  before(:each) do
    allow(HTTParty).to receive(:get).and_return(response)
    StatusCat::Checkers::Profilesio.api_key = key
  end

  it_should_behave_like 'a status checker'

  it 'sets the value' do
    expect(checker.value).to eql(key)
  end

  context 'pass' do

    it 'passes on connection to Profilesio' do
      expect(checker.status).to be_nil
    end

  end

  context 'fail' do

    it 'fails if it receives a non 200 code' do
      expect(response).to receive(:code).and_return(404)
      expect(checker.status).to_not be_nil
    end

    it 'fails if there is an exception' do
      expect(response).to receive(:code).and_raise('No code for you!')
      expect(checker.status).to_not be_nil
    end
  end
end
