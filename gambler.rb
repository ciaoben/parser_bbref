class Gambler
    attr_accessor :matches

    def initialize today_matches
        @matches = today_matches
    end

    def predict_a_class
        
        self.matches.each do |match|
            name = match[0]
            match = match[1]
            if ((match["era_pitcher_home"]) && (match["era_pitcher_away"]) && (match["era_pitcher_home"] < 3) && (match["era_pitcher_away"] > 3 ))
                if ((match["OPS_home"]) && (match["OPS_away"]) && (match["OPS_home"] > 0.800 && match["counter_OPS_home"] > 7) && (match["OPS_away"] < 0.750 && match["counter_OPS_away"] >= 7))
                    p name
                    p "yes"
                else
                    next
                end
            else
                next
            end
        end
    end
end
