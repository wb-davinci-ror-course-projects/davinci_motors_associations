# Read about factories at https://github.com/thoughtbot/factory_girl
require 'gaussian'
# the gaussian generates a daussian distributed random number
# with given mean and standard deviation
gauss = Gaussian.new(1995,6)
gauss2 = Gaussian.new(25000, 7000)


FactoryGirl.define do
  factory :car do
    make { Faker::Name.make }
    model { Faker::Name.model }
    year { gauss.rand.floor }
    price { gauss2.rand.round(2).to_f }
  end
end
