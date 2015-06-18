class ObjModel < TSheets::Model
  field :id, :integer
  field :name, :string
end

class ObjRepo < TSheets::Repository
  url '/objects'
  model ObjModel
  actions :list, :add, :edit
  filter :ids, [ :integer ]
end


