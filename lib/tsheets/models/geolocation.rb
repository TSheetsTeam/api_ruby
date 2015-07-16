class TSheets::Models::Geolocation < TSheets::Model
  field :id, :integer
  field :user_id, :integer
  field :accuracy, :integer
  field :altitude, :float
  field :latitude, :float
  field :longitude, :float
  field :speed, :float
  field :heading, :integer
  field :source, :string
  field :device_identifier, :string
  field :created, :datetime
end
