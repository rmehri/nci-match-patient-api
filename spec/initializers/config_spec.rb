require 'rails_helper'
require 'factory_girl_rails'

describe Config::Table do
  # describe "Config::Table" do
  #   it "should get correct table name" do
  #     expect(Config::Table.name("test")).to eq ENV["table_prefix"] + "test"  + ENV["table_suffix"]
  #   end
  # end

  describe Config::Queue do
    it "should get correct queue name" do
      expect(Config::Queue.name("test")).to eq "#{ENV["queue_prefix"]}#{ENV["queue_name"]}_#{Rails.env}"
    end
  end
end
