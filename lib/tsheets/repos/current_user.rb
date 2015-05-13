      class CurrentUser < TSheets::Repo
        url "/current_user"
        model User
        actions :get

      end
