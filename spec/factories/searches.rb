FactoryGirl.define do
  factory :search, class: TpbSearch::Search do
    search 'modern family s08e10'
    initialize_with { new(search) }
  end

  factory :search_failed, class: TpbSearch::Search do
    search 'suits s05e72'
    initialize_with { new(search) }
  end
end
