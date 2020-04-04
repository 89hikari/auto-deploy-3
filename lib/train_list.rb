# frozen_string_literal: true

require_relative 'check'

# creating list of trains
class TrainList
  def initialize
    @train_list = []
  end

  def each
    @train_list.each { |train| yield train }
  end

  def empty?
    @train_list.empty?
  end

  def check_id(number)
    exist = {}
    @train_list.each { |train| exist[:number] = 'ID already exists' if number == train.number }
    exist
  end

  def add_train(train)
    @train_list.append(train)
  end

  def delete_train(number)
    @train_list.delete_if { |train| number == train.number }
  end

  def sort_range(point, date1, date2)
    new_list = []
    @train_list.each do |train|
      new_list.append(train) if train.point_a == point &&
                                Check.date(date1, train.date_a, date2)
    end
    new_list
  end

  def sort_cost(point_a, point_b, date_a, cost)
    new_list = []
    @train_list.each do |train|
      new_list.append(train) if train.point_a == point_a &&
                                train.point_b == point_b &&
                                train.date_a == date_a &&
                                train.cost <= cost
    end
    new_list
  end

  def find_cities
    list = []
    @train_list.each do |train1|
      city = train1.point_b
      flag = false

      @train_list.each do |train2|
        flag = true if city == train2.point_a
      end
      list.append(city) unless flag
    end
    list
  end

  def all_cities
    list = []
    @train_list.each do |train|
      list.append(train.point_a)
      list.append(train.point_b)
    end
    list.uniq
  end
end
