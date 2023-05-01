class Result < ApplicationRecord
  # belongs_to :user
  # belongs_to :game

  def get_score(guess)
    as_array = guess.split()
    if as_array[0] == "Wordle"
      score = as_array[2][0]
      score = 7 if score == "X"
      return score
    end
    if as_array[0] == "Framed"
      as_array[3..8].each_with_index do |line, index|
        return index + 1 if line == "🟩"
      end
      return 7
    end
    if as_array[1] == "NewsGuesser"
      score = as_array[3].index("🟩")
      return 7 if score.nil?
      return score + 1
    end
    if as_array[0] == "Poeltl"
      score = as_array[3][0]
      score = 9 if score == "X"
      return score
    end
  end

  def get_edition(guess)
    as_array = guess.split()
    if as_array[0] == "Framed"
      return as_array[1]
    end
    if as_array[0] == "Wordle"
      return "##{as_array[1]}"
    end
    if as_array[1] == "NewsGuesser"
      return as_array[2]
    end
    if as_array[0] == "Poeltl"
      return "##{as_array[1]}"
    end
  end

  def get_display_score(guess)
    as_array = guess.split()
    if as_array[0] == "Wordle"
      score = as_array[2][0]
      score = 7 if score == "X"
      return "#{score}/6"
    end
    if as_array[0] == "Framed"
      as_array[3..8].each_with_index do |line, index|
        return "#{index + 1}/6" if line == "🟩"
      end
      return "7/6"
    end
    if as_array[1] == "NewsGuesser"
      score = as_array[3].index("🟩")
      return "7/6" if score.nil?
      return "#{score + 1}/6"
    end
    if as_array[0] == "Poeltl"
      score = as_array[3][0]
      score = 9 if score == "X"
      return "#{score}/8"
    end
  end

  def clean(guess)
    as_array = guess.split()
    return as_array[3..as_array.size - 2].join() if as_array[0] == "Framed"
    return as_array[2..] if as_array[0] == "Wordle"
    return as_array[3] if as_array[1] == "NewsGuesser"
    if as_array[0] == "Poeltl"
      poetl_guess = as_array[3..]
      poetl_guess.delete_at(2)
      poetl_guess.delete_at(1)
      return poetl_guess
    end
  end
end
