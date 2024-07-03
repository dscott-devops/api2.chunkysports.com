Rails.application.routes.draw do

  #devise_for :users
  root "pages#index"
 
  namespace :api do
    namespace :v1 do
      resources :lumps
      resources :sources
      resources :users, only: [:create, :destroy, :update]
      post "/bulkurls", to: "urls#bulkurls"
      get "loggedin/:id", to: "sessions#loggedin"
      get "click/:lump", to: "lumps#click"
      post "click", to: "lumps#postclick"
      get "click/:lump/:id", to: "lumps#click"
      get "loggedin", to: "sessions#loggedin"
      get "logout/:id", to: "sessions#logout"
      get "logout", to: "sessions#logout"
      get "isemail/:email", to: "users#isEmail"
      get "isemail", to: "users#isEmail"
      post "login", to: "sessions#login"
      post "team", to: "lumps#getteam"
      post "isemailexists", to: "users#isEmailExists"
      post "isusernameexists", to: "users#isUsername"
      post "createcomment", to: "comments#createcomment"
      post "updatecomment", to: "comments#updatecomment"
      post "teampages", to: "sources#teampages"
      post "pages", to: "lumps#pages"
      post "getdata", to: "lumps#getdata"
      post "getmore", to: "lumps#getMore"
      post "upload", to: "imagefiles#create"
      get "getsources/:id", to: "sources#getsources"
      get "getgames/:id", to: "games#getgames"
      get "getgamedetails/:id", to: "games#getGameDetails"
      get "standings", to: "standings#getAllStandings"
      get "standings/:category/:season", to: "standings#getStandings"
      get "removesource/:id/:team", to: "sources#removesource"
      get "addsource/:id/:team", to: "sources#addsource"
      get "getlumps/:id", to: "lumps#getlumps"
      get "getlumpsagain/:id", to: "lumps#getlumpsagain"
      get "getcomments/:id", to: "comments#getcomments"
      get "getlump/:id", to: "lumps#getlump"
      get "showlumps", to: "lumps#showlumps"
      get "/ban/:id", to: "lumps#banned"
      get "/daily/:id", to: "lumps#lumpdaily"
      get "/daily/:id/:category", to: "lumps#lumpdailyleague"
      get "sourcenames", to: "sources#sourcenames"
      get "/sl/:id", to: "sources#showsources"
      get "/nfl/:id", to: "sources#nfl"
      get "/team/:id", to: "sources#nba"
      get "/teams/:id", to: "sources#teams"
      get "/team/:id/:day", to: "sources#getDays"
      get "/7days/:id", to: "sources#get7Days"
      get "/nba/:id", to: "sources#nba"
      get "/nhl/:id", to: "sources#nhl"
      get "/mlb/:id", to: "sources#mlb"
      resources :chunks do
        resources :comments
      end
    end
  end

  get "*path", to: "pages#index", via: :all

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
