require 'rails_helper'
require 'factory_girl_rails'

describe Config::Table do

  #Test needs to be independent of system
  # describe Config::Queue do
  #   it "should get correct queue name" do
  #     name = Config::Queue.name("patient")
  #     expect(name).to eq "#{Rails.configuration.environment["queue_name"]}"
  #   end
  # end
end
