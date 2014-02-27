require 'active_record'

class Player < ActiveRecord::Base
  attr_accessor :name, :password, :level, :client
end
