require 'spec_helper'
require 'aws-sdk'

describe StatusCat::Checkers::S3 do

  let( :checker ) { StatusCat::Checkers::S3.new.freeze }

  before( :each ) do
    AWS::S3.stub( :new ).and_return( @s3 = double( AWS::S3 ) )
  end

  it_should_behave_like 'a status checker'

  it 'tolerates AWS being undefined' do
    aws = Object.send(:remove_const, :AWS)
    expect( checker.status ).to_not be_nil
    Object.const_set( :AWS, aws )
  end

  it 'uses the aws access key as the value' do
    expect( checker.value ).to eql( AWS.config.access_key_id )
  end

  it 'fails if there is an exception talking to S3' do
    expect( @s3 ).to receive( :buckets ).and_raise( 'error' )
    expect( checker.status ).to_not be_nil
  end

  it 'fails if there are no S3 buckets' do
      expect( @s3 ).to receive( :buckets ).and_return( [] )
      expect( checker.status ).to_not be_nil
    end

  it 'passes if it finds S3 buckets' do
    expect( @s3 ).to receive( :buckets ).and_return( [ 1 ] )
    expect( checker.status ).to be_nil
  end

end