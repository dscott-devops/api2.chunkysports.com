module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      protect_from_forgery with: :null_session
      before_action :set_user, only: [:update, :destroy]

      def create
        email = params["user"]["email"]

        user = User.find_by(email: email)

        if !user
          image = params["user"]["image"]
          if !image.blank?
            imageurl = image.sub("chunkyprofiles.s3.amazonaws.com", "d1pxdtfxumkgca.cloudfront.net")
          end

          user = User.create!(
            email: params["user"]["email"],
            password: params["user"]["password"],
            password_confirmation: params["user"]["password_confirmation"],
            username: params["user"]["username"],
            mobile: params["user"]["mobile"],
            firstname: params["user"]["firstname"],
            lastname: params["user"]["lastname"],
            bio: params["user"]["bio"],
            displayname: params["user"]["displayname"],
            slogan: params["user"]["slogan"],
            image: imageurl,
            favorite: params["user"]["team"],
            admin: false,
          )
          if User
            team = params["user"]["team"]
            if !team.blank?
              source = Source.find_by(username: team)
              if source
                user.sources << source
              end
            end

            imagefile = Imagefile.find_by(id: params["user"]["imageid"])
            if imagefile
              imagefile.imageurl = imageurl
              imagefile.imageOriginal = imageurl
              imagefile.user_id = user.id
              imagefile.filename = params["user"]["filename"]
              imagefile.save
            end

            lumps = Lump.where(sources: user.sources).where(created_at: (Time.now - 24.hours)..Time.now).limit(200).order("created_at DESC")

            render json: {
                     status: "Successful",
                     successful: true,
                     isLoggedin: true,
                     user: user,
                     sources: user.sources,
                     lumps: lumps,
                   }
          else
            render json: { status: 500 }
          end #end if User
        else
          render json: {
                   status: "Email Already exists",
                   successful: false,
                   isLoggedin: false,
                   user: user,
                   sources: {},
                   lumps: {},
                 }
        end
      end

      def isEmail
        if (params.has_key?(:email))
          email = params[:email]

          email = email.gsub("%40", "@")
          email = email.gsub("%2E", ".")

          user = User.find_by(email: email)
          if user
            render json: {
              status: "Successful",
              isLoggedin: true,
              user: user,
            }
          else
            render json: {
              status: "Not Found",
              isLoggedin: false,
              user: {},
              email: email,
            }
          end
        else
          render json: {
            status: "No Email Sent",
            isLoggedin: false,
            user: {},
          }
        end
      end

      def destroy
      end

      def update
        if @user.update(mobile: params["user"]["mobile"],
                        firstname: params["user"]["firstname"],
                        lastname: params["user"]["lastname"],
                        bio: params["user"]["bio"],
                        displayname: params["user"]["displayname"],
                        slogan: params["user"]["slogan"],
                        image: params["user"]["image"])
          render json: {
            status: "Updated",
            user: @user,
          }
        else
          render json: { status: 422 }
        end
      end

      def isUsername
        if (params.has_key?(:username))
          user = User.find_by(username: params[:username])
          if user
            render json: { status: "Username Exists",
                           successful: false }
          else
            render json: { status: "Username Available",
                      successful: true }
          end
        else
          render json: { status: "Unknown Usernam param missing",
                    successful: false }
        end
      end

      def isEmailExists
        if (params.has_key?(:email))
          user = User.find_by(email: params[:email])
          if user
            render json: { status: "Emails Exists",
                           successful: false,
                           user: user }
          else
            render json: { status: "Email Available",
                      successful: true }
          end
        else
          render json: { status: "Unknown Emails param missing",
                    successful: false }
        end
      end

      private

      def set_user
        @user = User.find_by(authentication_token: params["user"]["token"])
      end
    end
  end
end
