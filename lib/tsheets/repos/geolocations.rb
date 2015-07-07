  class TSheets::Repos::Geolocations < TSheets::Repository
    url "/geolocations"
    model TSheets::Models::Geolocation
    actions :list, :add
    filter :ids, [ :integer ]
    filter :modified_before, :datetime
    filter :modified_since, :datetime
    filter :user_ids, [ :integer ]
    filter :group_ids, [ :integer ]
    filter :per_page, :integer
    filter :page, :integer
  end
