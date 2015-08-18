class ObjGroupModel < TSheets::Model
  field :id, :integer
  field :name, :string
end

class ObjTagModel < TSheets::Model
  field :id, :integer
  field :name, :string
end

class ObjTaggedModel < TSheets::Model
  field :id, :integer
  field :name, :string
  field :group_id, :integer
  field :tag, :obj_tag_model
end

class ObjModel < TSheets::Model
  field :id, :integer
  field :name, :string
  field :group_id, :integer
  field :tag, :obj_tag_model

  model :group, type: :obj_group_model, foreign: :group_id, primary: :id
end

class ObjExt < TSheets::Model
  field :id, :integer
  field :whoami, :string
end

class ObjExtTypedModel < TSheets::Model
  field :id, :integer, exclude: [ :add, :edit ]
  field :name, :string
  field :created, :datetime, exclude: [ :add, :edit ]
  field :born, :date
  field :active, :boolean
  field :endorsed, :boolean
  field :group_ids, [ :integer ]
  field :tags, [ :string ]
  field :significant_dates, [ :date ]
  field :answers_path, [ :boolean ]
  field :extended, :obj_ext
end

class ObjModelWithFloat < TSheets::Model
  field :id, :integer
  field :name, :string
  field :ratio, :float
end

class ObjModelWithObject < TSheets::Model
  field :id, :integer
  field :name, :string
  field :object, :object
end

class ObjReport < TSheets::Model
  field :user_id, :integer
  field :ratio, :float
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

class ObjReportRepo < TSheets::Repository
  url '/obj_report'
  model ObjReport
  actions :report
  filter :user_ids, [ :integer ]
end

class ObjExtTypedRepo < TSheets::Repository
  url '/ext_typed_objects'
  model ObjExtTypedModel
  actions :list, :add, :edit
  filter :ids, [ :integer ]
  filter :name, :string
  filter :born, :boolean
  filter :endorsed, :boolean
  filter :tags, [ :string ]
  filter :significant_dates, [ :date ]
end

class ObjExtTypedRepo2 < TSheets::Repository
  url '/ext_typed_objects'
  model ObjExtTypedModel
  actions :list, :edit
  filter :ids, [ :integer ]
  filter :name, :string
  filter :born, :boolean
  filter :endorsed, :boolean
  filter :tags, [ :string ]
  filter :significant_dates, [ :date ]
end

class ObjExtTypedRepoDeleteOnly < TSheets::Repository
  url '/ext_typed_objects'
  model ObjExtTypedModel
  actions :delete
end

class ObjTypedRepo < TSheets::Repository
  url '/typed_objects'
  model ObjTypedModel
  actions :list, :add, :edit
  filter :ids, [ :integer ]
  filter :name, :string
  filter :born, :boolean
  filter :created, :datetime
  filter :endorsed, :boolean
  filter :tags, [ :string ]
  filter :significant_dates, [ :date ]
  filter :since, :date
end

class ObjEffectiveSettings < TSheets::Model
  field :general, :hash
  field :time_entry, :hash
  field :invoicing, :hash
  field :alerts, :hash
  field :dialin, :hash
  field :sounds, :hash

  default_field_type :hash
end

class EmptyObject < TSheets::Model
  default_field_type :datetime
end

class ObjEffectiveSettingsRepo < TSheets::Repository
  url '/obj_effective_settings'
  model ObjEffectiveSettings, singleton: true
  actions :list
  filter :user_id, :integer
  filter :modified_before, :datetime
  filter :modified_since, :datetime
end

class ObjTaggedRepo < TSheets::Repository
  url '/objects'
  model ObjTaggedModel
  actions :list, :add, :edit
  filter :ids, [ :integer ]
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

  class ObjTagModel < TSheets::Model
    field :id, :integer
    field :name, :string
  end

  class ObjTaggedModel < TSheets::Model
    field :id, :integer
    field :name, :string
    field :group_id, :integer
    field :tag, :obj_tag_model
  end

end
