module Api
    module V1
        class ImagefilesController < ApplicationController
          skip_before_action :verify_authenticity_token
          protect_from_forgery with: :null_session
           def index
            imagefiles = Imagefile.all
            render json: ImagefileSerializer.new(imagefiles).serializable_hash.to_json
           end

           def show
            imagefile = Image.find_by(slug: params[:slug])
            render json: ImagefileSerializer.new(Image,options).serializable_hash.to_json
           end

           def create
            imagefile = Imagefile.new()
            imagefile.profilePic = true
            imagefile.image = params["image"]

            if imagefile.save


                render json: { status: "Successful Upload",
                  successful: true,
                  imagefileid: imagefile.id,
                  imageurl: imagefile.image.service_url,
                  filename: imagefile.image.filename,
                  metadata: imagefile.image.metadata,
                  url: imagefile.image.url
                  
                }
            else
                render json: { error: Image.errors.messages }, status: 422
            end
           
           end

           def update
            imagefile = Imagefile.find_by(slug: params[:slug])

            name = params[:name]

            if imagefile.update(name: name)
                render json: ImagefileSerializer.new(imagefile,options).serializable_hash.to_json
            else
                render json: { error: Image.errors.messages }, status: 422
            end
           
           end

           def destroy
             imagefile = Imagefile.find_by(slug: params[:slug])

             if imagefile.destroy
               head :no_content
             else
               render json: { error: Image.errors.messages }, status: 422
             end           
           end

           


           private
      


           def options
            @options ||= { include: %i[reviews] }
          end

           def imagefile_params
             params.require(:Imagefile).permit(:key, :profilePic, :imagefileOriginal, :imagefile30Pixels, :imagefile50Pixels, :description, :lumpImage, :lump_id, :user_id )

   
           end

        end
    end
  end
