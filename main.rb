#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require 'logger'
require_relative 'parser'
require_relative 'gambler'

logger = Logger.new 'matches.log', 'weekly'

parser = Parser.new 
today_matches = parser.parse
gambler = Gambler.new today_matches, logger
gambler.predict_a_class