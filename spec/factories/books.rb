FactoryGirl.define do
  factory :book do
    sequence(:asin) {|n| "B00ABCDEF#{n}" }
    title  "Doe"
    raw_author "Test Author"
    date 2.months.ago.to_date
    collection_count 0
  end
end
