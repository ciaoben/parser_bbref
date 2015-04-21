#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'awesome_print'
p "start"

def compose_url segment
    base = "http://www.baseball-reference.com"
    url = base + segment
end

home = Nokogiri::HTML(open("http://www.baseball-reference.com/"))
urls =  Array.new
home.css("#todays_games a").each do |el| 
    urls << compose_url(el.attribute("href").value) if el.content =~/Preview/
end

today_matches = Hash.new 

# collect data for each match
urls.each do |url|

    preview = Nokogiri::HTML(open(url))

    # grab and clean the name of the match
    today_matches[preview.css("h1")[0].content.sub(/,.*/,'')] = Hash.new

    match_data = today_matches[preview.css("h1")[0].content.sub(/,.*/,'')]
    

    tables = preview.css("#div_")

    # the last table (  = the second ) in the page is the one of the away team
    table_away = tables.pop


    if table_away.css(".blank_table")[1].css("+ tr td")[0].content =~ /never/
        team_away = nil 
    else
        match_data["record_pitcher_away"] = table_away.css(".blank_table")[1].css("+ tr td")[0].next_element.next_element.content
        match_data["era_pitcher_away"] = table_away.css(".blank_table")[1].css("+ tr td")[10].content
    end 

    table_home = tables.pop
    if table_home.css(".blank_table")[1].css("+ tr td")[0].content =~ /never/
        team_home = nil
    else
        match_data["record_pitcher_home"] = table_home.css(".blank_table")[1].css("+ tr td")[0].next_element.next_element.content
        match_data["era_pitcher_home"] = table_home.css(".blank_table")[1].css("+ tr td")[10].content
    end 

    



    ap match_data
    ap "-----"
end

