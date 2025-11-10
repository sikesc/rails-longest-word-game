require "json"
require "open-uri"


class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    @letters = 10.times.map { alphabet.sample }
  end

  def score
    @score = session[:score] || 0
    @word = params[:answer]
    @letters = params[:letters].chars
    url = "https://dictionary.lewagon.com/#{@word}"
    word_serialized = URI.parse(url).read
    @word_test = JSON.parse(word_serialized)
    if @word.chars.all? { |letter| @letters.include?(letter)} == false
      @message = "Sorry #{@word} can't be built out of #{@letters.join(", ")}. Your score: #{session[:score]}"
    elsif @word_test["found"] == false
      @message = "Sorry #{@word} does not seem to be a valid English word. Your score: #{session[:score]}"
    else
      @score += @word_test["length"].to_i
      session[:score] = @score
      @message = "Congratulations #{@word} is a valid English word. Your score: #{session[:score]}"
    end
  end
end
