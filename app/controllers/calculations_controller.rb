class CalculationsController < ApplicationController

  def word_count
    @text = params[:user_text]
    @special_word = params[:user_word]

    # ================================================================================
    # Your code goes below.
    # The text the user input is in the string @text.
    # The special word the user input is in the string @special_word.
    # ================================================================================
    text_ary = @text.split(" ")

    @character_count_with_spaces = @text.length

    @character_count_without_spaces = text_ary.join.length

    @word_count = text_ary.length
    lc_text_ary = text_ary.map { |z| z.downcase }
    @occurrences = lc_text_ary.count(@special_word.downcase)

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("word_count.html.erb")
  end

  def loan_payment
    @apr = params[:annual_percentage_rate].to_f
    @years = params[:number_of_years].to_i
    @principal = params[:principal_value].to_f

    # ================================================================================
    # Your code goes below.
    # The annual percentage rate the user input is in the decimal @apr.
    # The number of years the user input is in the integer @years.
    # The principal value the user input is in the decimal @principal.
    # ================================================================================
    periods = @years * 12
    monthly_interest = @apr/1200 #divided by 100 to get percent and then by 12 to get per month
    pv_annuity = ((1 -((1+monthly_interest)**(-1*periods)))/monthly_interest) # Present Value of Annuity
    @monthly_payment = (@principal/pv_annuity).round(2)

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("loan_payment.html.erb")
  end

  def time_between
    @starting = Chronic.parse(params[:starting_time])
    @ending = Chronic.parse(params[:ending_time])

    # ================================================================================
    # Your code goes below.
    # The start time is in the Time @starting.
    # The end time is in the Time @ending.
    # Note: Ruby stores Times in terms of seconds since Jan 1, 1970.
    #   So if you subtract one time from another, you will get an integer
    #   number of seconds as a result.
    # ================================================================================

    @seconds = @ending - @starting
    @minutes = @seconds/60
    @hours = @minutes/60
    @days = @hours/24
    @weeks = @days/7
    @years = @days/365.25

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("time_between.html.erb")
  end

  def descriptive_statistics
    @numbers = params[:list_of_numbers].gsub(',', '').split.map(&:to_f)

    # ================================================================================
    # Your code goes below.
    # The numbers the user input are in the array @numbers.
    # ================================================================================

    @sorted_numbers = @numbers.sort

    @count = @numbers.length

    def find_minimum x
      tick = 0
      while tick < x.length
        if tick == 0
          y = x[tick]
        else
          if x[tick] < y
            y = x[tick]
          end
        end
        tick = tick + 1
      end
      y
    end

    @minimum = find_minimum @numbers

    def find_maximum x
      tick = 0
      while tick < x.length
        if tick == 0
          y = x[tick]
        else
          if x[tick] > y
            y = x[tick]
          end
        end
        tick = tick + 1
      end
      y
    end

    @maximum = find_maximum @numbers

    @range = @maximum - @minimum

    def find_median x
      x = x.sort
      if x.length.odd?
        point = x.length/2
        median = x[point]
      else
        point_1 = (x.length/2) - 1
        point_2 = x.length/2
        median = (x[point_1] + x[point_2])/2
      end
      median
    end

    @median = find_median @numbers

    def find_sum x
      tick = 0
      sum = 0
      while tick < x.length
        sum = sum + x[tick]
        tick = tick + 1
      end
      sum
    end

    @sum = find_sum @numbers

    @mean = @sum/@count

    ave_diff_sq = @numbers.map { |x| (x - @mean)**2 }

    @variance = (find_sum ave_diff_sq)/ave_diff_sq.length

    @standard_deviation = @variance**0.5


    def find_mode x_array

      def find_unique_array x #Creates an array of only unique value and the counts of their occurrance
        tick = 0
        y = Array.new
        while tick < x.length
          if tick == 0
            y.push  [x[tick], 1]
          else
            sub_tick = 0
            while sub_tick < y.length
              if y[sub_tick][0] == x[tick]
                unique = false
                y[sub_tick][1] = y[sub_tick][1] + 1
                break
              else
                unique = true
                sub_tick = sub_tick + 1
              end
            end
            if unique
              y.push [x[tick], 1]
            end
          end
          tick = tick + 1
        end
        y
      end

      def max_position x #Finds and returns the maximum position
        tick = 0
        position = tick
        while tick < x.length
          y = x[position]
          if y[1] < x[tick][1]
            position = tick
          end
          tick = tick + 1
        end
        position
      end

      unique_array = find_unique_array x_array
      mode_position = max_position unique_array
      mode_found = unique_array[mode_position][0]
    end

    @mode = find_mode @numbers

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("descriptive_statistics.html.erb")
  end
end
