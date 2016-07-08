require 'rails_helper'
require 'factory_girl_rails'

describe Config::Table do
  describe "Config::Table" do
    it "should get correct table name" do
      name = Config::Table.name("table_name")

      # pattern: <table_prefix_>table_name_<env>
      # env == test_local
      expect(name).to eq ENV["table_prefix"] + "_table_name_test_local"
    end
  end

  describe Config::Queue do
    it "should get correct queue name" do
      name = Config::Queue.name("patient")

      # pattern: <queue_prefix_>table_name_<env>
      # env == test_local
      expect(name).to eq "#{ENV["queue_prefix"]}_patient_test_local"
    end
  end
end
