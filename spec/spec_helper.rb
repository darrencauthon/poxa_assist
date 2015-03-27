require_relative '../lib/poxa_assist'
require 'minitest/autorun'
require 'minitest/spec'
require 'timecop'
require 'mocha/setup'

def random_string
  SecureRandom.uuid.gsub('-', '')
end
