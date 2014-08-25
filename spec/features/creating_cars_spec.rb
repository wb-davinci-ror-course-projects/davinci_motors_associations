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

  scenario 'allow a logged in user to claim a car' do
    @user = FactoryGirl.create(:user)
    @car1 = FactoryGirl.create(:car)
    @car2 = FactoryGirl.create(:car)

    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Login'

    within("#car_#{@car1.id}") do
      click_link 'Claim'
    end

    expect(page).to have_text("#{@car1.make} #{@car1.model} has been moved to your inventory.")
    expect(page).to_not have_selector("#car_#{@car1.id}")
    expect(page).to have_selector("#car_#{@car2.id}")

    expect(page).to have_link('My Cars')
    click_link 'My Cars'

    expect(page).to have_selector("#car_#{@car1.id}")
    expect(page).to_not have_selector("#car_#{@car2.id}")
  end

  scenario 'can unclaim a car' do
    @user = FactoryGirl.create(:user, password: 's3krit')
    @car_1 = FactoryGirl.create(:car, user_id: @user.id, make: 'Fiat', price: 38465.29)
    @car_2 = FactoryGirl.create(:car, user_id: @user.id, model: "Gremlin")

    # log the user in
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 's3krit'
    click_button 'Login'

    click_link 'My Cars'

    expect(page).to have_content('Fiat')

    within("#car_#{@car_1.id}") do
      click_link 'Unclaim'
    end

    expect(page).to_not have_content(@car_1.price)
    expect(page).to have_content("Gremlin")
  end
end
