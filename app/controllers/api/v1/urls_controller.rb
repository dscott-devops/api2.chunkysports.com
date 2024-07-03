module Api
  module V1
      class UrlsController < ApplicationController
        skip_before_action :verify_authenticity_token
        protect_from_forgery with: :null_session
         def index
          urls = Url.all
          render json: UrlSerializer.new(urls).serializable_hash.to_json
         end

         def show
          url = Url.find(params[:id])
          render json: UrlSerializer.new(url,options).serializable_hash.to_json
         end

         def create
          url = Url.new(url_params)

          if url.save
              render json: UrlSerializer.new(url).serializable_hash.to_json
          else
              render json: { error: url.errors.messages }, status: 422
          end
         
         end

         def bulkurls
          ids = Array.new
          links = params[:links]
          urltype = params[:urltype]
          source = params[:source]
          urldata = "/#{urltype}".downcase

          urls = links.split("\n")
          urls.each do |url|

            urlcheck = Url.find_by(url: url)

            if ! urlcheck
            
            newurl = Url.create(source_id: source, url: url, urldata: urldata, urltype: urltype, urltype2: source )
            if newurl
              ids.append(newurl.id)
            end

          end
            
          end

          newurls = Url.where(id: ids)
          
          render json: UrlSerializer.new(newurls).serializable_hash.to_json
         end

         def update
          url = Url.find_by(slug: params[:slug])

          name = params[:name]

          if url.update(name: name)
              render json: UrlSerializer.new(url,options).serializable_hash.to_json
          else
              render json: { error: url.errors.messages }, status: 422
          end
         
         end

         def destroy
           url = Url.find_by(slug: params[:slug])

           if url.destroy
             head :no_content
           else
             render json: { error: url.errors.messages }, status: 422
           end           
         end

         


         private
    


         def options
          @options ||= { include: %i[reviews] }
        end

         def url_params
           params.require(:url).permit(:title, :body, :preview)
         end

      end
  end
end

