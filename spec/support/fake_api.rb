class ObjModel < TSheets::Model
  field :id, :integer
  field :name, :string
  field :group_id, :integer
end

class ObjTypedModel < TSheets::Model
  field :id, :integer
  field :name, :string
  field :created, :datetime
  field :born, :date
  field :active, :boolean
  field :endorsed, :boolean
  field :group_ids, [ :integer ]
  field :tags, [ :string ]
  field :significant_dates, [ :date ]
  field :answers_path, [ :boolean ]
end

class ObjTypedRepo < TSheets::Repository
  url '/typed_objects'
  model ObjTypedModel
  actions :list, :add, :edit
  filter :ids, [ :integer ]
  filter :name, :string
  filter :born, :boolean
  filter :endorsed, :boolean
  filter :tags, [ :string ]
  filter :significant_dates, [ :date ]
end

class ObjRepo < TSheets::Repository
  url '/objects'
  model ObjModel
  actions :list, :add, :edit
  filter :ids, [ :integer ]
end

module ScopedObjects
  class ObjModel2 < TSheets::Model
    field :id, :integer
    field :tag, :string
  end

  class ObjModel3 < TSheets::Model
    field :id, :integer
    field :tag, [ :string ]
  end

  class ObjRepo2 < TSheets::Repository
    url '/objects2'
    model ObjModel2
    actions :list, :add, :edit
    filter :ids, [ :integer ]
  end

  class ObjRepo3 < TSheets::Repository
    url '/objects3'
    model ObjModel3
    actions :add, :edit
    filter :ids, [ :integer ]
  end
end
