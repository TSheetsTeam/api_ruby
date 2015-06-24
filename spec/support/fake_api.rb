class ObjModel < TSheets::Model
  field :id, :integer
  field :name, :string
  field :group_id, :integer
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

  class ObjRepo2 < TSheets::Repository
    url '/objects2'
    model ObjModel2
    actions :list, :add, :edit
    filter :ids, [ :integer ]
  end
end
