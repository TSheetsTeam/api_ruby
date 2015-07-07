  class TSheets::Repos::CurrentUser < TSheets::Repository
    url "/current_user"
    model TSheets::Models::User
    actions :list
  end
