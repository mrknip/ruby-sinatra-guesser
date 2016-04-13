require 'sinatra'
require 'sinatra/reloader'

configure do
  set :number, rand(101)
  set :guesses, 5
end

helpers do
  def check_guess(guess)
    guess_colour = '#000'
    return "Have a guess" unless guess

    settings.guesses -= 1
    diff = guess.to_i - settings.number
    
    return win if diff == 0
    return lose if settings.guesses == 0

    [guess_message(guess, diff), guess_colour(diff)]
  end

  def guess_colour(diff)
    case diff.abs 
    when 0 then '#6D6'
    when (1...5) then '#FAA'
    else '#D41'
    end
  end

  def guess_message(guess, diff)
    message = "#{guess} is "
    message << (diff.abs >= 5 ? "way " : "") << (diff > 0 ? "too high" : "too low")
  end

  def reset
    settings.guesses = 5
    settings.number = rand(101)
  end

  def lose
    message = "Game over - the number was #{settings.number}"
    reset
    return [message, '#000']
  end

  def win
    message = "You win! The number was #{settings.number}"
    reset
    return [message, '#6D6']
  end
end

get '/' do 
  guess = params['guess']
  message, guess_colour = check_guess(guess)
  number = params['cheat'] == 'true' ? settings.number : ""

  erb :index, :locals => {message: message, 
                          number: number,
                          guess_colour: guess_colour,
                          guesses: settings.guesses}
end
