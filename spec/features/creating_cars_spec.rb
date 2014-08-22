require 'rails_helper'
require 'spec_helper'


feature 'Creating Cars' do
  scenario 'can create a car' do
    visit '/'

    click_link 'New Car'

    fill_in 'Make', with: 'Ford'
    fill_in 'Model', with: 'Mustang'
    fill_in 'Year', with: '1967'
    fill_in 'Price', with: '2300'

    click_button 'Create Car'

    expect(page).to have_content('has been created.')

  end

  scenario 'shows all cars on home page' do
    car1 = Car.create(make: 'Subaru', model: 'Impreza', year: '2002', price: '3000')
    car2 = Car.create(make: 'Honda', model: 'Civic', year: '1999', price: '1597')

    visit '/'

    expect(page).to have_content(car1.make)
    expect(page).to have_content(car2.make)

  end

  scenario 'can edit a car' do
    car = Car.create(make: 'Subaru', model: 'Impreza', year: '2002', price: '3000')
    visit edit_car_path(car)

    fill_in 'Year', with: '2005'
    click_button 'Update Car'

    expect(page).to have_content('2005')
  end

  scenario 'uses factory girl to create a car' do
    car = FactoryGirl.create(:car)

    expect(car.price).to be > 0
    expect(car.price).to be < 1_000_000
  end
end
