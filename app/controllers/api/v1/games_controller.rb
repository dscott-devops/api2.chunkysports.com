module Api
  module V1
    class GamesController < ApplicationController
      skip_before_action :verify_authenticity_token
      protect_from_forgery with: :null_session

      def getgames
        user = User.find_by(authentication_token: params["id"])
        if user
          games = Game.where(source_id: user.sources)
          if games
            render json: {
              status: "Games Successful",
              successful: true,
              games: games,

            }
          else
            render json: {
              status: "Games Failed",
              successful: false,
              games: {},

            }
          end
        else # if user
          render json: {
            status: "User Not Found",
            successful: false,
            games: {},

          }
        end #if user
      end
    end
  end
end
