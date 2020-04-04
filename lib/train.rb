# frozen_string_literal: true

# 1
class Train
  attr_reader :number, :point_a, :point_b, :date_a, :date_b, :time_a, :time_b, :cost

  def initialize(number, point_a, date_a, time_a, point_b, date_b, time_b, cost)
    @number = number
    @point_a = point_a
    @point_b = point_b
    @date_a = date_a
    @date_b = date_b
    @time_a = time_a
    @time_b = time_b
    @cost = cost
  end

  def check_fields
    errors = {}

    empty_string(errors)
    negative_number(errors)
    date_format(errors)
    time_format(errors)
    city_hit(errors)
    date_hit(errors)

    errors
  end

  private

  def empty_string(errors)
    message = 'String is empty!'
    errors[:point_a] = message if @point_a.empty?
    errors[:point_b] = message if @point_b.empty?
  end

  def negative_number(errors)
    message = 'Input positive number!'
    errors[:number] = message if @number <= 0
    errors[:cost] = message if @cost <= 0
  end

  def date_format(errors)
    message = 'Invalid format date!'
    errors[:date_a] = message unless Check.date_format(@date_a)
    errors[:date_b] = message unless Check.date_format(@date_b)
  end

  def time_format(errors)
    message = 'Invalid format time!'
    errors[:time_a] = message unless Check.time_format(@time_a)
    errors[:time_b] = message unless Check.time_format(@time_b)
  end

  def city_hit(errors)
    message = 'Similar cities!'
    errors[:city_hit] = message if @point_a == @point_b
  end

  def date_hit(errors)
    message = 'Check range of dates!'
    if !@date_a.empty? && !@date_b.empty?
      errors[:date_hit] = message if Check.date_hit(@date_a, @date_b)
    end
  end
end
