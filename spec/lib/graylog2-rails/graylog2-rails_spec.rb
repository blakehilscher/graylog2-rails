require 'spec_helper'

describe Graylog2Rails do
  
  describe "#configuration" do
    subject{ Graylog2Rails.configuration }
    its(['message_backtrace']){ should eq true }
    its(['message_args']){ should eq true }
    its(['hostname']){ should eq '127.0.0.1' }
    its(['port']){ should eq 12201 }
  end
  
end