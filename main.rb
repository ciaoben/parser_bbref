#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require_relative 'parser'
require_relative 'gambler'

p = Parser.new 
today_matches = p.parse
g = Gambler.new today_matches
g.predict_a_class