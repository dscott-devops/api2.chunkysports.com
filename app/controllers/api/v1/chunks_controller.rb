module Api
    module V1
        class ChunksController < ApplicationController
          skip_before_action :verify_authenticity_token
          protect_from_forgery with: :null_session
           def index
            chunks = Chunk.all
            render json: ChunkSerializer.new(chunks).serializable_hash.to_json
           end

           def show
            chunk = Chunk.find_by(slug: params[:slug])
            render json: ChunkSerializer.new(chunk,options).serializable_hash.to_json
           end

           def create
            chunk = Chunk.new(chunk_params)

            if chunk.save
                render json: ChunkSerializer.new(chunk).serializable_hash.to_json
            else
                render json: { error: chunk.errors.messages }, status: 422
            end
           
           end

           def update
            chunk = Chunk.find_by(slug: params[:slug])

            name = params[:name]

            if chunk.update(name: name)
                render json: ChunkSerializer.new(chunk,options).serializable_hash.to_json
            else
                render json: { error: chunk.errors.messages }, status: 422
            end
           
           end

           def destroy
             chunk = Chunk.find_by(slug: params[:slug])

             if chunk.destroy
               head :no_content
             else
               render json: { error: chunk.errors.messages }, status: 422
             end           
           end

           


           private
      


           def options
            @options ||= { include: %i[reviews] }
          end

           def chunk_params
             params.require(:chunk).permit(:title, :body, :preview)
           end

        end
    end
  end
