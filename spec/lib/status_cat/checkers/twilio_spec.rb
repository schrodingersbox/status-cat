describe StatusCat::Checkers::Twilio do

  let( :checker ) { StatusCat::Checkers::Twilio.new.freeze }

  it_should_behave_like 'a status checker'

  describe '#initialize' do

    it 'sets the value' do
      expect( checker.value ).to eql( ENV[ 'TWILIO_SID' ] )
    end

    context 'pass' do

      it 'passes if it can connect to Twilio' do
        expect( checker.status ).to be_nil
      end
    end

    context 'fail' do

      it 'fails if it receives nil' do
        expect( @twilio_messages ).to receive( :total ).and_return( nil )
        expect( checker.status ).to_not be_nil
      end

      it 'fails if there is an exception' do
        expect( @twilio_messages ).to receive( :total ).and_raise( 'This is only a test' )
        expect( checker.status ).to_not be_nil
      end
    end
  end
end