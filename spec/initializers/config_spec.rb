require 'rails_helper'
require 'factory_girl_rails'

describe Config::Table do
  describe "Config::Table" do
    it "should get correct table name" do
      name = Config::Table.name("table_name")

      # pattern: <table_prefix_>table_name_<env>
      # env == test_local
      expect(name).to eq ENV["table_prefix"] + "_table_name_#{Rails.env}"
    end
  end

  describe Config::Queue do
    it "should get correct queue name" do
      name = Config::Queue.name("patient")

      # pattern: <queue_prefix_>table_name_<env>
      # env == test_local
      expect(name).to eq "#{ENV["queue_prefix"]}_#{ENV["queue_name"]}_#{Rails.env}"
    end
  end
end
