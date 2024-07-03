  require "#{Rails.root}/lib/elasticclass.rb"

module Api
  module V1
  

    class ElasticsController < ApplicationController
      skip_before_action :verify_authenticity_token
      protect_from_forgery with: :null_session

      def search
        token = params[:user]
        searchtype = params[:searchtype]
        searchterm = params[:searchterm]
        team = params[:team]
        video = params[:video]
        if video.nil?
          video = false
        end
        user = User.find_by(authentication_token: token)

        if user
          email = "#{user.email}"
          sources = user.sources.ids
        else
          email = "NOT FOUND"
          sources = "BLANK"
        end

        elastic = ElasticClass.new()
        result = elastic.search1(searchtype,searchterm,sources,team,video)
        count = result.size

        if count == 100
          searchafter = result[99]["sort"][0]
          puts result
        end

        

        render json: {
          status: "Found #{token} #{searchtype} #{email} sources: #{sources} searchterm: #{searchterm} team: #{team}",
          sucessful: true,
          searchafter: searchafter,
          count: count,
          hits: result
         
        }
      end
    end
  end
end
