require 'coveralls'
require "codeclimate-test-reporter"
require 'pry'

Coveralls.wear!
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ccme'
