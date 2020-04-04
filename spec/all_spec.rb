# frozen_string_literal: true

RSpec.describe 'Trains', type: :feature do
  before(:example) do
    Capybara.app = Sinatra::Application.new
  end

  it 'главная страница' do
    visit('/')
    expect(page).to have_content('Лабораторная №2: Железнодорожная система')
  end

  it 'ошибка добавления' do
    visit('/')
    click_on('Добавление')
    click_on('Добавить поезд')
    expect(page).to have_content('String is empty!')
    expect(page).to have_content('Input positive number!')
    expect(page).to have_content('Invalid format date!')
    expect(page).to have_content('Invalid format time!')
  end

  it 'добавление' do
    visit('/')
    click_on('Добавление')

    fill_in('number', with: 12)
    fill_in('point_a', with: 'point_a')
    fill_in('date_a', with: '2019-05-30')
    fill_in('time_a', with: '12:00')
    fill_in('point_b', with: 'point_b')
    fill_in('date_b', with: '2019-06-02')
    fill_in('time_b', with: '13:00')
    fill_in('cost', with: 123)

    click_on('Добавить поезд')
    expect(page).to have_content('Список поездов')

    expect(page).to have_content('point_a')
    expect(page).to have_content('2019-05-30')
    expect(page).to have_content('12:00')
    expect(page).to have_content('point_b')
    expect(page).to have_content('13:00')
    expect(page).to have_content('2019-06-02')
    expect(page).to have_content('123')
  end

  it 'удаление' do
    visit('/')
    click_on('Список поездов')

    train = find_by_id('train', match: :first).text
    find_button('Удалить', match: :first).click

    expect(page).not_to have_content(include(train))
  end

  it 'пункт отправления, время отправления, диапазон дат' do
    visit('/')

    click_on('По дате, времени и пункту отправления')
    click_on('Найти')
    expect(page).to have_content('String is empty!')
    expect(page).to have_content('Invalid format date!')

    fill_in('point_a', with: 'Moscow')
    fill_in('date_a', with: '2019-05-05')
    fill_in('date_b', with: '2019-05-07')

    click_on('Найти')
    expect(page).to have_content('Moscow')
    expect(page).to have_content('Vologda')
    expect(page).to have_content('13')
  end

  it 'пункт отправления, пункт назначения, день отправления, ограничение по стоимости' do
    visit('/')

    click_on('По пунктам отправления и назначения, дате и цене')
    click_on('Найти')
    expect(page).to have_content('String is empty!')
    expect(page).to have_content('Invalid format date!')
    expect(page).to have_content('Input positive number!')

    fill_in('point_a', with: 'Vologda')
    fill_in('point_b', with: 'Helsinki')
    fill_in('date_a', with: '2019-09-30')
    fill_in('cost', with: '10000')

    click_on('Найти')
    expect(page).to have_content('Vologda')
    expect(page).to have_content('Helsinki')
    expect(page).to have_content('9545')
  end

  it 'города, в которые можно приехать, но нельзя уехать' do
    visit('/')
    click_on('В которые можно приехать, но нельзя уехать')

    expect(page).to have_content('Города')
    expect(page).to have_content('Saint-Petersburg')
    expect(page).to have_content('Helsinki')
  end

  it 'все города' do
    visit('/')
    click_on('С железнодорожным обращением')

    expect(page).to have_content('Города')
    expect(page).to have_content('Saint-Petersburg')
    expect(page).to have_content('Helsinki')
  end
end
