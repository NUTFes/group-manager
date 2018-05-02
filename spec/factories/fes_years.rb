FactoryGirl.define do
  factory :this_year, class: FesYear do
    fes_year Time.now.year

    initialize_with do
      FesYear.find_or_initialize_by(fes_year: fes_year)
    end
  end
end
