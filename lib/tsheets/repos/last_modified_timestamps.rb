class TSheets::Repos::LastModifiedTimestamps < TSheets::Repository
  url "/last_modified_timestamps"
  model TSheets::Models::LastModifiedTimestamps, singleton: true
  actions :list
end
