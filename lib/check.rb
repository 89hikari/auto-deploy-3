# frozen_string_literal: true

require 'date'

# 1
module Check
  def self.date(date1, date2, date3)
    d1 = DateTime.parse(date1)
    d2 = DateTime.parse(date2)
    d3 = DateTime.parse(date3)

    return true if d2.between?(d1, d3)

    false
  end

  def self.date_format(date)
    items = date.split('-').map(&:to_i)
    return false if items.size != 3
    return false unless items[0] > 2000 || (items[1].positive? && items[1] <= 12) ||
                        (items[2].positive? && items[2] <= 31)

    true
  end

  def self.date_hit(date1, date2)
    return true if DateTime.parse(date1) > DateTime.parse(date2)

    false
  end

  def self.time_format(time)
    items = time.split(':').map(&:to_i)
    return false if items.size != 2
    return false unless items[0].positive? && items[0] <= 23 ||
                        (items[1].positive? && items[1] <= 59)

    true
  end

  def self.sort_range(point_a, date_a, date_b)
    errors = {}

    errors[:point_a] = 'String is empty!' if point_a.empty?
    errors[:date_a] = 'Invalid format date!' unless date_format(date_a)
    errors[:date_b] = 'Invalid format date!' unless date_format(date_b)

    errors
  end

  def self.sort_cost(point_a, point_b, date_a, cost)
    errors = {}

    errors[:point_a] = 'String is empty!' if point_a.empty?
    errors[:point_b] = 'String is empty!' if point_b.empty?
    errors[:date_a] = 'Invalid format date!' unless date_format(date_a)
    errors[:cost] = 'Input positive number!' if cost <= 0

    errors
  end
end
