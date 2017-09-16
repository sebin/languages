module Concerns
  # Extra methods for language search
  module Languages
    # Search
    # Search terms are split into an array and compared with the terms from
    # each language and sorting score is calculated.
    # Then languages with highest score are the results
    def search(term)
      terms_array, non_match_term = split_terms(term)
      file = File.read('public/data.json')
      languages = JSON.parse(file)
      match_scores = match_scores(terms_array, non_match_term, languages)
      best_matches(match_scores)
    end

    # Calculate matching terms.
    def match_scores(terms_array, non_match_term, languages)
      output_array = []
      languages.each_with_index do |language, index|
        score_hash = { position: index, name: language['Name'], score: 0 }
        ['Name', 'Type', 'Designed by'].each do |key|
          items_array = split_to_array(language[key])
          score_hash[:score] += (items_array & terms_array).size
          score_hash[:score] -= 1 if items_array.include?(non_match_term)
        end
        output_array << score_hash
      end
      output_array
    end

    # Find languages with high matching scores
    def best_matches(match_scores)
      max = match_scores.map { |s| s[:score] }.max
      match_scores.select { |s| s[:score] == max }
    end

    # Convert search query to an array, find out the non matching term also
    def split_terms(string)
      terms_array = split_to_array(string)
      non_match_term = string.partition('-').last.downcase.strip
      [terms_array, non_match_term]
    end

    # Split string to array
    def split_to_array(string)
      string.downcase.split(/\W+/)
    end
  end
end
