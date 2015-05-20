class TSheets::Repos::CurrentUser < TSheets::Repo
  url "/current_user"
  model TSheets::Models::User
  actions :get

end
