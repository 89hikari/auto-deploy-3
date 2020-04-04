# frozen_string_literal: true

require 'sinatra'
require 'psych'
require_relative 'lib/train'
require_relative 'lib/train_list'

set :bind, '0.0.0.0'

DATA = File.expand_path('data/database.yaml', __dir__)

def read_yaml
  @train_list = TrainList.new
  return train_list if !File.exist?(DATA)

  Psych.load_file(DATA).each do |value|
    @train_list.add_train(Train.new(value['number'].to_i, value['point_a'], value['date_a'], value['time_a'],
                                    value['point_b'], value['date_b'], value['time_b'], value['cost'].to_i))
  end

  @train_list
end

configure do
  set :date_trains, read_yaml
end

get '/' do
  erb :main
end

get '/list_trains' do
  @list = settings.date_trains
  erb :list_trains
end

get '/list_trains/add_train' do
  @error = @exist = {}
  @train = Train.new('', '', '', '', '', '', '', '')
  erb :add
end

post '/list_trains/add_train' do
  @train = Train.new(params['number'].to_i, params['point_a'], params['date_a'], params['time_a'],
                     params['point_b'], params['date_b'], params['time_b'], params['cost'].to_i)

  @error = @train.check_fields
  @exist = settings.date_trains.check_id(params['number'].to_i)

  if @error.empty? && @exist.empty?
    settings.date_trains.add_train(@train)
    redirect to('/list_trains')
  else
    erb :add
  end
end

post '/list_trains/delete_train/:id' do
  settings.date_trains.delete_train(params['id'].to_i)
  redirect to('/list_trains')
end

get '/sort_range' do
  @list = []
  @errors = {}
  erb :sort_range
end

post '/sort_range' do
  @errors = Check.sort_range(params['point_a'], params['date_a'], params['date_b'])
  if @errors.empty?
    @list = settings.date_trains.sort_range(params['point_a'], params['date_a'], params['date_b'])
    erb :list_sort
  else
    erb :sort_range
  end
end

get '/sort_point_date_cost' do
  @list = []
  @errors = {}
  erb :sort_cost
end

post '/sort_point_date_cost' do
  @errors = Check.sort_cost(params['point_a'], params['point_b'], params['date_a'], params['cost'].to_i)
  if @errors.empty?
    @list = settings.date_trains.sort_cost(params['point_a'], params['point_b'], params['date_a'], params['cost'].to_i)
    erb :list_sort
  else
    erb :sort_cost
  end
end

get '/come_not_leave' do
  @list = settings.date_trains.find_cities
  erb :list_cities
end

get '/all_cities' do
  @list = settings.date_trains.all_cities
  erb :list_cities
end
