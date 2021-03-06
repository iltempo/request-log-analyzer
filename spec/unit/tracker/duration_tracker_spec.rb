require 'spec_helper'

describe RequestLogAnalyzer::Tracker::Duration do

  describe '#report' do

    before(:each) do
      @tracker = RequestLogAnalyzer::Tracker::Duration.new(:category => :category, :value => :duration)
      @tracker.prepare
    end

    it "should generate a report without errors when one category is present" do
      @tracker.update(request(:category => 'a', :duration => 0.2))
      lambda { @tracker.report(mock_output) }.should_not raise_error
    end

    it "should generate a report without errors when no category is present" do
      lambda { @tracker.report(mock_output) }.should_not raise_error
    end

    it "should generate a report without errors when multiple categories are present" do
      @tracker.update(request(:category => 'a', :duration => 0.2))
      @tracker.update(request(:category => 'b', :duration => 0.2))
      lambda { @tracker.report(mock_output) }.should_not raise_error
    end

    it "should generate a YAML output" do
      @tracker.update(request(:category => 'a', :duration => 0.2))
      @tracker.update(request(:category => 'b', :duration => 0.2))
      @tracker.to_yaml_object.should == {"a"=>{:hits=>1, :min=>0.2, :mean=>0.2, :max=>0.2, :sum_of_squares=>0.0, :sum=>0.2}, "b"=>{:hits=>1, :min=>0.2, :mean=>0.2, :max=>0.2, :sum_of_squares=>0.0, :sum=>0.2}}
    end
  end
  
  describe '#display_value' do
    before(:each) { @tracker = RequestLogAnalyzer::Tracker::Duration.new(:category => :category, :value => :duration) }
    
    it "should only display seconds when time < 60" do
      @tracker.display_value(33.12).should == '33.12s'
    end

    it "should display minutes and wholeseconds when time > 60" do
      @tracker.display_value(63.12).should == '1m03s'
    end

    it "should display minutes and wholeseconds when time > 60" do
      @tracker.display_value(3601.12).should == '1h00m01s'
    end
  end
end
