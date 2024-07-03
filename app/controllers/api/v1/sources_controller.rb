module Api
  module V1
   
    class SourcesController < ApplicationController
      skip_before_action :verify_authenticity_token
      protect_from_forgery with: :null_session
      include ActionController::HttpAuthentication::Token
      

      def index
        sources = Source.all
        render json: SourceSerializer.new(sources).serializable_hash.to_json
      end

      def show
        source = Source.find(params[:id])
        render json: SourceSerializer.new(source, options).serializable_hash.to_json
      end

      def sourcenames
        sources = Source.all.order(:username)
        render json: SourceSerializer.new(sources).serializable_hash.to_json
      end

      def lumpdaily
        lumps = Lump.where(source_id: params[:id]).limit(100).order("created_at DESC")
        render json: LumpSerializer.new(lumps).serializable_hash.to_json
      end

      def showsources
        source = Source.find(params[:id])
        render json: SourceSerializer.new(source, options).serializable_hash.to_json
      end

      def removesource
        user = User.find_by(authentication_token: params["id"])
        if user
          team = Source.find_by(username: params["team"])
          if team
            usersource = UserSource.find_by(user_id: user.id, source_id: team.id)
            if usersource
              usersource.destroy
              newusersource = UserSource.find_by(user_id: user.id, source_id: team.id)
              sources = Source.joins(:users).where(users: { id: user.id }).order(:username)

              if !newusersource
                render json: {
                         status: "Source removed successfully",
                         successful: true,
                         sources: sources,

                       }
              else
                render json: {
                         status: "Source removal failed",
                         successful: false,
                         sources: sources,

                       }
              end
            else
              render json: {
                       status: "Source does not exist",
                       successful: false,
                     }
            end
          end
        else
          render json: {
                   status: "User not found",
                   successful: false,
                 }
        end
      end

      def addsource
        user = User.find_by(authentication_token: params["id"])
        if user
          team = Source.find_by(username: params["team"])
          if team
            usersource = UserSource.find_by(user_id: user.id, source_id: team.id)
            if !usersource
              user.sources << team
              newusersource = UserSource.find_by(user_id: user.id, source_id: team.id)
              sources = Source.joins(:users).where(users: { id: user.id }).order(:username)
              lumps = Lump.where(source_id: team.id).where(created_at: (Time.now - 24.hours)..Time.now).order("created_at DESC")

              if newusersource
                render json: {
                         status: "Source added successfully",
                         successful: true,
                         sources: sources,
                         lumps: lumps,
                       }
              else
                render json: {
                         status: "Source addition failed",
                         successful: false,
                         sources: sources,

                       }
              end
            else
              render json: {
                       status: "Source already exist",
                       successful: false,
                     }
            end
          end
        else
          render json: {
                   status: "User not found",
                   successful: false,
                 }
        end
      end

      def getsources
        user = User.find_by(authentication_token: params["id"])
        if user
          result = Source.joins(:users).where(users: { id: user.id })

          if result
            render json: SourceSerializer.new(result).serializable_hash.to_json
          else
            render json: { error: result.errors.messages }, status: 422
          end
        else
          render json: { error: "User not found" }
        end
      end

      def nfl
        source = Source.find_by(username: params[:id])
        if source
          lumps = Lump.where(source_id: source.id).limit(50).order("created_at DESC")
          render json: LumpSerializer.new(lumps).serializable_hash.to_json
        else
          render json: { error: source.errors.messages }, status: 422
        end
      end

      def nba
        source = Source.find_by(username: params[:id])
        if source
          lumps = Lump.where(source_id: source.id).limit(100).order("created_at DESC")
          comments = Comment.where(lump_id: lumps)
          render json: {
                   status: "Successful",
                   successful: true,                 
                   lastupdated: Time.now,
                   source: source,
                   lumps: lumps,
                   comments: comments
                 }
        else
          render json: {
            status: "Failed: Team doesn't exist",
            successful: false,
            comments: [],
            lastupdated: Time.now,
            source: [],
            lumps: [],
          }
        end
      end

      def teams
        source = Source.find_by(username: params[:id])
        if source
          lumps = Lump.where(source_id: source.id).limit(100).order("created_at DESC")
          comments = Comment.where(lump_id: lumps)
          render json: {
                   status: "Successful",
                   successful: true,                  
                   lastupdated: Time.now,
                   source: source,
                   lumps: lumps,
                   comments: comments
                 }
        else
          render json: {
            status: "Failed: Team doesn't exist",
            successful: false,
            comments: [],
            lastupdated: Time.now,
            source: [],
            lumps: [],
          }
        end
      end

      def teampages
        page = params["page"]
        source = Source.find_by(username: params[:id])
        if source
          lumps = Lump.where(source_id: source.id).limit(5).offset(page * 5).order("created_at DESC")

          render json: LumpSerializer.new(lumps).serializable_hash.to_json
        else
          render json: { error: source.errors.messages }, status: 422
        end
      end

      def nhl
        source = Source.find_by(username: params[:id])
        if source
          lumps = Lump.where(source_id: source.id).limit(50).order("created_at DESC")
          render json: LumpSerializer.new(lumps).serializable_hash.to_json
        else
          render json: { error: source.errors.messages }, status: 422
        end
      end

      def mlb
        source = Source.find_by(username: params[:id])
        if source
          lumps = Lump.where(source_id: source.id).limit(50).order("created_at DESC")
          render json: LumpSerializer.new(lumps).serializable_hash.to_json
        else
          render json: { error: source.errors.messages }, status: 422
        end
      end

      def create
        source = Source.new(source_params)

        if source.save
          render json: SourceSerializer.new(source).serializable_hash.to_json
        else
          render json: { error: source.errors.messages }, status: 422
        end
      end

      def update
        source = Source.(params[:id])

        name = params[:name]

        if source.update(name: name)
          render json: SourceSerializer.new(source, options).serializable_hash.to_json
        else
          render json: { error: source.errors.messages }, status: 422
        end
      end

      def destroy
        source = Source.(params[:id])

        if Source.destroy
          head :no_content
        else
          render json: { error: source.errors.messages }, status: 422
        end
      end

      def getDays
        id = params[:id]
        day = params[:day]

        day = day.to_i

        source = Source.find_by(username: params[:id])
        if source
          thisDate = Date.today
          thisDate = thisDate - day

        lumps = Lump.where(created_at: thisDate.beginning_of_day..thisDate.end_of_day,source_id: source.id ).order("id DESC")
        if lumps
  
          render json: {
            status: "Successful",
            lumpcount: lumps.length,
            successful: true,
            thisDate: thisDate,
            lumps: lumps,
            source: source,
           
           
          }
        else
          render json: {
            status: "Failed",
            lumpcount: 0,
            successful: false,          
           
           
          }

        end

        else
          render json: {
            status: "Failed",
            lumpcount: 0,
            successful: false,          
           
           
          }


        end
       

        



      end

      def get7Days
        id = params[:id]
        

        source = Source.find_by(username: params[:id])
        if source
          thisDate = Date.today
          lastDate = thisDate - 7

        lumps = Lump.where(created_at: lastDate.end_of_day..thisDate.beginning_of_day,source_id: source.id ).order("id DESC")
        if lumps
  
          render json: {
            status: "Successful",
            lumpcount: lumps.length,
            successful: true,
            thisDate: thisDate,
            lastDate: lastDate,
            lumps: lumps,
            source: source,
           
           
          }
        else
          render json: {
            status: "Failed",
            lumpcount: 0,
            successful: false,          
           
           
          }

        end

        else
          render json: {
            status: "Failed",
            lumpcount: 0,
            successful: false,          
           
           
          }


        end
       

        



      end

      private

      def options
        @options ||= { include: %i[lumps] }
      end

      def authenticate_user

        token, options = token_and_options(request)

        user = User.find_by(authentication_token: token)
        if ! user
          render json: {
            status: :unauthorized,
            lumpcount: 0,
            successful: false,              
           
          }, status: 401      
        end
     
        
         
        
      end

      def source_params
        params.permit(:title, :description, :image, :sourcetype, :category, :subcategory, :username, :first_name, :last_name, :email, :source, :category, :conference)
      end
    end
  end
end
