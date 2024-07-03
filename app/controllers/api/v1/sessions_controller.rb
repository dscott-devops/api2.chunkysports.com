module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      protect_from_forgery with: :null_session
      before_action :set_user, only: [:update, :destroy]

      def create
        user = User.find_by(email: params["user"]["email"])

        if user.valid_password?(params["user"]["password"])
          sources = Source.joins(:users).where(users: { id: user.id }).order("first_name, last_name")
          lumps = Lump.where(source_id: user.sources).limit(50).order("created_at DESC")
          render json: {
                   status: "Successful",
                   isLoggedin: true,
                   user: user,
                   sources: sources,
                   lumps: lumps,
                 }
        else
          lumps = Lump.all.limit(50).order("created_at DESC")
          render json: { status: "Failed",
                         isLoggin: false,
                         lumps: lumps }
        end  # if user
      end

      def login
        user = User.find_by(email: params["user"]["email"])
        if user && user.valid_password?(params["user"]["password"])
          sources = Source.joins(:users).where(users: { id: user.id }).order("first_name, last_name")
          #lumps = Lump.where(source_id: user.sources).limit(50).order("created_at DESC")
          lumps = Lump.where(sources: user.sources).where(created_at: (Time.now - 24.hours)..Time.now).order("created_at DESC")
          if lumps.count == 0
            lumps = Lump.all.limit(100).order("created_at DESC")
            comments = Comment.where(lumps: lumps)
          else
            comments = Comment.where(sources: user.sources).where(created_at: (Time.now - 24.hours)..Time.now).order("created_at DESC")
          end
          render json: {
                   status: "Successful",
                   isLoggedin: true,
                   comments: comments,
                   user: user,
                   sources: sources,
                   lumps: lumps,
                   logintime: Time.now,

                 }
        else
          #lumps = Lump.all.limit(50).order("created_at DESC")
          render json: { status: "Failed",
                         isLoggin: false,
                         lumps: [] }
        end  # if user
      end

      def destroy
      end

      def loggedin
        if (params.has_key?(:id))
          user = User.find_by(authentication_token: params["id"])
          if user
            sources = Source.joins(:users).where(users: { id: user.id }).order("first_name, last_name")
            lumps = Lump.where(sources: user.sources).where(created_at: (Time.now - 24.hours)..Time.now).order("created_at DESC")
            if lumps.count == 0
              lumps = Lump.all.limit(100).order("created_at DESC")
              if lumps
                comments = Comment.where(lumps: lumps)
              end
            else
              comments = Comment.where(sources: user.sources).where(created_at: (Time.now - 24.hours)..Time.now).order("created_at DESC")
            end
            #sourcesReturn = SourceSerializer.new(sources).serializable_hash
            render json: {
                     status: "Successful",
                     isLoggedin: true,
                     comments: comments,
                     user: user,
                     sources: sources,
                     lumps: lumps,
                     logintime: Time.now,
                   }
          else
            lumps = Lump.all.limit(100).order("created_at DESC")
            comments = Comment.where(lumps: lumps)
            render json: { status: "Failed",
                           isLoggin: false,
                           comments: comments,
                           lumps: lumps }
          end
        else
          render json: { status: "Failed",
                         isLoggin: false,
                         lumps: [] }
        end
      end

      def logout
        if (params.has_key?(:id))
          user = User.find_by(authentication_token: params[:id])

          if user
            user.authentication_token = ""
            if user.save
              lumps = Lump.all.limit(50).order("created_at DESC")
              comments = Comment.where(lumps: lumps)

              render json: {
                       status: "Successful Logout",
                       isLoggedin: false,
                       comments: comments,
                       lumps: lumps = Lump.all.limit(100).order("created_at DESC"),
                     }
            end
          else
            render json: { status: "Failed",
                           isLoggin: false,
                           lumps: [] }
          end
        else
          render json: { status: "Failed",
                         isLoggin: false,
                         lumps: [] }
        end
      end

      private

      def options
        @options ||= { include: %i[reviews] }
      end

      def session_params
        params.require(:session).permit(:title, :body, :preview)
      end

      def set_user
        @user = User.find_by(authentication_token: params["id"])
      end
    end
  end
end
