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

# collect data for each match and return an hash of them (today_matches)
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
    
    

    def extract_OPS_data(table)
        rows = table.css("tr")
        rows.delete rows.first
        counter = 0

        values = Array.new

        (0..12).each do |index|
            value =  rows[index].css("td")[1].content
            
            if value =~ Regexp.new('.*/')
                
                val = value.sub(Regexp.new('.*/'), '').to_f
                if val != 0
                    values << val
                    counter = counter + 1
                end
            else
                # do nothing
            end
        end
        average = values.inject{ |sum, el| sum + el.to_f }.to_f / values.size
        return average, counter
    end

    tables = preview.css(".x_small_text.border")

    table_away = tables.pop
    table_home = tables.pop
    match_data["OPS_away"], match_data["counter_OPS_away"] = extract_OPS_data table_away
    match_data["OPS_home"], match_data["counter_OPS_home"] = extract_OPS_data table_home
    ap today_matches

    exit # evita di farlo per ogni match, da togliere dopo debug


end

# ap today_matches
