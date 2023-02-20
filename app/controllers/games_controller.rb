require 'open-uri'

class GamesController < ApplicationController

  before_action :set_score_count

  def new
    i = 0
    @letters = []
    while i < 10
      @letters << Array('A'..'Z').sample(1)[0].to_s
      i += 1
    end
  end

  def score
    if !possible_with_grid?(params[:word], params[:letters])
      @score = "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters].chars.join(', ')}"
    else
      result = []
      URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word]}") { |f| f.each_line { |line| result = JSON.parse(line) } }
      if result['found'] == true
        @score = "Congratulations! #{params[:word].upcase} is a valid English word!"
        @score_count = params[:word].length
        cookies[:score_count] = cookies[:score_count].to_i + @score_count
      else
        @score = "Sorry but #{params[:word].upcase} is not an english word..."
      end
    end
  end

  def set_score_count
    cookies[:score_count] = 0 if cookies[:score_count].nil?
  end

  def possible_with_grid?(attempt, grid)
    a = attempt.downcase.chars
    grid = grid.downcase.chars.dup
    # debugger
    while a.length.positive?
      a.each do |letter|
        return false unless grid.include?(letter)

        grid.delete_at(grid.index(letter))
        a.delete_at(a.index(letter))
      end
    end
    return true
  end
end
