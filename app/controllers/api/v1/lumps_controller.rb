module Api
  module V1
    require "time"
    
    class LumpsController < ApplicationController
      skip_before_action :verify_authenticity_token
      protect_from_forgery with: :null_session
      include ActionController::HttpAuthentication::Token

      def index
        lumps = Lump.all
        render json: LumpSerializer.new(lumps).serializable_hash.to_json
      end

      def show
        lump = Lump.find(params[:id])
        render json: LumpSerializer.new(lump, options).serializable_hash.to_json
      end

      def banned
        lump = Lump.find(params[:id])
        if lump
          lump.source_id = 155
          lump.preview = "Banned"
          if lump.save
            render json: LumpSerializer.new(lump).serializable_hash.to_json
          else
            render json: { error: lump.errors.messages }, status: 422
          end
        end
      end

      def create
        lump = Lump.new(lump_params)

        if lump.save
          render json: LumpSerializer.new(lump).serializable_hash.to_json
        else
          render json: { error: lump.errors.messages }, status: 422
        end
      end

      def update
        lump = Lump.find_by(slug: params[:slug])

        name = params[:name]

        if lump.update(name: name)
          render json: LumpSerializer.new(lump, options).serializable_hash.to_json
        else
          render json: { error: lump.errors.messages }, status: 422
        end
      end

      def destroy
        lump = Lump.find_by(slug: params[:slug])

        if lump.destroy
          head :no_content
        else
          render json: { error: lump.errors.messages }, status: 422
        end
      end

      def getlumps
        user_id = params["id"]
        if user_id == "999999"
          lumps = Lump.all.limit(5).order("created_at DESC")
          if lumps
            render json: LumpSerializer.new(lumps).serializable_hash.to_json
          else
            render json: { error: lumps.errors.messages }, status: 422
          end
        else
          user = User.find_by(authentication_token: params["id"])
          if user
            lumps = Lump.where(source_id: user.sources).limit(5).order("created_at DESC")
            if lumps.count == 0
              lumps = Lump.all.limit(50).order("created_at DESC")
            end

            if lumps
              render json: LumpSerializer.new(lumps).serializable_hash.to_json
            else
              render json: { error: lumps.errors.messages }, status: 422
            end
          else
            lumps = Lump.all.limit(50).order("created_at DESC")
            if lumps
              render json: LumpSerializer.new(lumps).serializable_hash.to_json
            else
              render json: { error: lumps.errors.messages }, status: 422
            end
          end
        end
      end

      def getlumpsagain
        user = User.find_by(authentication_token: params["id"])
        if user
          lumps = Lump.where(source_id: user.sources).limit(50).order("created_at DESC")
          if lumps.count == 0
            lumps = Lump.all.limit(50).order("created_at DESC")
          end

          if lumps
            render json: LumpSerializer.new(lumps).serializable_hash.to_json
          else
            render json: { error: lumps.errors.messages }, status: 422
          end
        else
          lumps = Lump.all.limit(50).order("created_at DESC")
          if lumps
            render json: LumpSerializer.new(lumps).serializable_hash.to_json
          else
            render json: { error: lumps.errors.messages }, status: 422
          end
        end
      end

      def getlump
        begin
          lump = Lump.find(params[:id])
        rescue
          lump = nil
        end

        if lump
          begin
            source = Source.find(lump.source_id)
          rescue
            source = nil
          end

          if source
            rLump = LumpSerializer.new(lump).serializable_hash
            rSource = SourceSerializer.new(source).serializable_hash
            render json: {
                     message: "Successful",
                     status: true,
                     lump: rLump,
                     source: rSource,
                   }
          else
            rLump = LumpSerializer.new(lump).serializable_hash
            render json: {
                     message: "Failed to find Source",
                     status: false,
                     lump: rLump,
                     source: {},
                   }
          end
        else
          render json: {
                   message: "Failed to find lump",
                   status: false,
                   lump: {},
                   source: {},
                 }
        end
      end

      def getdata
        page = params["page"]
        id = params["id"]
        pages = params["pages"]
        team = params["team"]
        verb = params["verb"]
        lastupdated = params["lastupdated"]

        if !id.blank?
          user = User.find_by(authentication_token: params["id"])
          time = 24.hours.ago.strftime("%Y-%m-%d %M:%S")
          if user
            if verb == "initial"
              today = Lump.where(created_at: (Time.now - 24.hours)..Time.now).where(sources: user.sources)
              sources = Source.joins(:users).where(users: { id: user.id })
              statusmsg = "Successful"

              statusbool = true
            elsif verb == "update"
              date = Time.parse(lastupdated)
              today = Lump.where(created_at: date..Time.now).where(source_id: user.sources)
              comments = Comment.where(created_at: date..Time.now).where(source_id: user.sources)
              sources = Source.joins(:users).where(users: { id: user.id })
              statusmsg = "Successful"
              statusbool = true
              lumpcount = today.count
            elsif verb == "nextday"
              date = time.parse(lastupdated)
              date2 = date + 24.hours
              today = Lump.where(created_at: date..date).where(sources: user.sources)
              statusmsg = "Successful"

              statusbool = true
              lumpcount = today.count
            else
              statusmsg = "Failed no verb"
              today = nil
              sources = nil
              page = 0
              statusbool = false
              lumpcount = 0
            end #if end initial
          else
            statusmsg = "User not found"
            today = nil
            sources = nil
            page = 0
            statusbool = false
            successful = false
            comments = nil
            lumpcount = 0
          end #if user
          render json: {
            status: statusmsg,
            successful: statusbool,
            lumpcount: lumpcount,
            currentpage: page.to_i + 1,
            lastupdated: Time.now,
            comments: comments,
            sources: sources,
            lumps: today,
          }
        elsif !team.blank?
          source = Source.find_by(username: team)
          time = 24.hours.ago.strftime("%Y-%m-%d %M:%S")
          if verb == "initial"
            today = Lump.where(source_id: source.id).limit(100).order("created_at DESC")
            sources = nil
            statusmsg = "Successful"
            statusbool = true
          elsif verb == "update"
            date = Time.parse(lastupdated)
            today = Lump.where(created_at: date..Time.now).where(source_id: source.id)
            sources = nil
            statusmsg = "Successful"
            statusbool = true
          elsif verb == "nextday"
            date = Time.parse(lastupdated)

            today = Lump.where(source_id: source.id).limit(100).offset(100 * page).order("created_at DESC")
            statusmsg = "Successful"
            statusbool = true
          else
            statusmsg = "Failed no verb"
            today = nil
            sources = nil
            page = 0
            statusbool = false
          end #if end initial
          render json: {
            status: statusmsg,
            successful: statusbool,
            count: today.count,
            currentpage: page + 1,
            lastupdated: Time.now,
            sources: sources,
            lumps: today,
          }
        else # else both team and id are blank if ! id.blank?
          render json: {
            status: "Invalid request, no ID or Team specified",
            successful: false,
            count: 0,
            currentpage: 0,
            lastupdated: Time.now,
            sources: {},
            lumps: {},
          }
        end # end if ! id.blank?
      end #end getdata

      def pages
        page = params["page"]
        id = params["id"]
        pages = params["pages"]
        team = params["team"]
        lastupdated = params["lastupdated"]

        if !id.blank?
          user = User.find_by(authentication_token: params["id"])

          if user
            case pages
            when 1
              #lumps = Lump.where(source_id: user.sources).limit(5).offset(page * 5).order("created_at DESC")
              lumps = Lump.where(sources: user.sources).where(created_at: (Time.now - 24.hours)..Time.now).limit(200).order("created_at DESC")
              sources = Source.joins(:users).where(users: { id: user.id })
              statusmsg = "Successful"
              if lumps.count == 0
                lumps = Lump.all.limit(100).order("created_at DESC")
              end

              if lumps
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page + 1,
                  lumps: lumps,
                  lastupdated: Time.now,
                  verb: 1,
                  sources: sources,

                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            when 24
              page = page + 1
              time = Time.parse(lastupdated)
              time = time - (page * 24.hours)
              time2 = time + 24.hours

              lumps = Lump.where(sources: user.sources).where(created_at: time..time2).order("created_at DESC")
              sources = Source.joins(:users).where(users: { id: user.id })
              statusmsg = "Successful"
              if lumps.count == 0
                lumps = Lump.all.limit(100).offset(page * 100).order("created_at DESC")
              end

              if lumps
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page,
                  lumps: lumps,
                  lastupdated: Time.now,
                  verb: 1,
                  sources: sources,

                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            when 50
              lumps = Lump.where(source_id: user.sources).limit(50).offset(page * 5).order("created_at DESC")
              if lumps.count == 0
                lumps = Lump.all.limit(50).offset(page * 5).order("created_at DESC")
              end

              if lumps
                result = LumpSerializer.new(lumps).serializable_hash
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page + 10,
                  lumps: result,
                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            end #End case pages
          else
            case pages
            when 1
              lumps = Lump.all.limit(100).order("created_at DESC")

              if lumps
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page + 1,
                  lumps: lumps,
                  lastupdated: Time.now,
                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            when 24
              lumps = Lump.all.limit(100).offset(page * 100).order("created_at DESC")

              if lumps
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page + 1,
                  lumps: lumps,
                  lastupdated: Time.now,
                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            when 50
              lumps = Lump.where(source_id: user.sources).limit(50).offset(page * 5).order("created_at DESC")

              if lumps
                result = LumpSerializer.new(lumps).serializable_hash
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page + 10,
                  lumps: result,
                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            end #End case pages
          end #End if User
        elsif !team.blank?
          source = Source.find_by(username: team)
          if source
            case pages
            when 1
              lumps = Lump.where(source_id: source.id).where(created_at: (Time.now - 72.hours)..Time.now).order("created_at DESC")

              #lumps = Lump.where(source_id: source.id).limit(5).offset(page * 5).order("created_at DESC")
              if lumps.count == 0
                lumps = Lump.all.limit(100).order("created_at DESC")
              end

              if lumps
                games = Game.where(source_id: source.id)
                #result = LumpSerializer.new(lumps).serializable_hash
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page + 1,
                  lumps: lumps,
                  lastupdated: Time.now,
                  games: games,
                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            when 24
              page = page + 1
              time = Time.parse(lastupdated)
              time = time - (page * 72.hours)
              time2 = time + 72.hours
              lumps = Lump.where(source_id: source.id).where(created_at: time..time2).order("created_at DESC")

              if lumps.count == 0
                lumps = Lump.all.limit(100).offset(page * 100).order("created_at DESC")
              end

              if lumps
                games = Game.where(source_id: source.id)
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page,
                  lumps: lumps,
                  lastupdated: Time.now,
                  games: games,
                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            when 50
              lumps = Lump.where(source_id: source.id).limit(50).offset(page * 5).order("created_at DESC")
              if lumps.count == 0
                lumps = Lump.all.limit(50).offset(page * 5).order("created_at DESC")
              end

              if lumps
                games = Game.where(source_id: source.id)
                #result = LumpSerializer.new(lumps).serializable_hash
                render json: {
                  status: "Successful",
                  successful: true,
                  currentpage: page + 10,
                  lumps: lumps,
                  games: games,
                  lastupdated: Time.now,
                }
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            end #End case pages
          end
        else
          case pages
          when 1
            lumps = Lump.all.limit(100).order("created_at DESC")

            if lumps
              render json: {
                       status: "Successful",
                       successful: true,
                       currentpage: page + 1,
                       lumps: lumps,
                       lastupdated: Time.now,
                     }
            else
              render json: { error: lumps.errors.messages }, status: 422
            end
          when 24
            date = Date.today.all_day
            time = 24.hours.ago.strftime("%Y-%m-%d %M:%S")
            lumps = Lump.where(created_at: (Time.now - 24.hours)..Time.now).offset(page * 5).order("created_at DESC")

            if lumps
              result = LumpSerializer.new(lumps).serializable_hash
              pagecount = (lumps.count / 5)
              render json: {
                       status: "Successful",
                       successful: true,
                       currentpage: page + pagecount,
                       lumps: result,
                     }
            else
              render json: { error: lumps.errors.messages }, status: 422
            end
          when 50
            lumps = Lump.limit(50).offset(page * 5).order("created_at DESC")

            if lumps
              result = LumpSerializer.new(lumps).serializable_hash
              render json: {
                       status: "Successful",
                       successful: true,
                       currentpage: page + 10,
                       lumps: result,
                     }
            else
              render json: { error: lumps.errors.messages }, status: 422
            end
          end #End case pages
        end #End id.blank?

=begin
        user = User.find_by(authentication_token: params['id'])
            if user
              
              lumps = Lump.where(source_id: user.sources).limit(5).offset(page * 5).order("created_at DESC")
              if lumps.count == 0
                lumps = Lump.all.limit(5).offset(page * 5).order("created_at DESC")
              end

              
              if lumps
                render json: LumpSerializer.new(lumps).serializable_hash.to_json
              else
                render json: { error: lumps.errors.messages }, status: 422
              end
            else
              lumps = Lump.all.limit(5).offset(page * 5).order("created_at DESC")
              if lumps
                render json: LumpSerializer.new(lumps).serializable_hash.to_json
              else
                render json: { error: lumps.errors.messages }, status: 422
              end

            end
=end
      end #End Pages

      def getMore

        page = params["page"]
        id = params["id"]
        pages = params["pages"]
        team = params["team"]
        verb = params["verb"]
        lastupdated = params["lastupdated"]

        time = Time.parse(lastupdated)
        time2 = time - 24.hours
        
        if !id.blank?
          user = User.find_by(authentication_token: params["id"])
          if user
            if !team.blank?
              source = Source.find_by(username: team)
              if source
                lumps = Lump.where(source_id: source.id).where(created_at: time2..time).order("id DESC")
                render json: {
                  status: "Successful",
                  lumpcount: lumps.count,
                  successful: true,
                  lumps: lumps,
                  lastupdated: Time.now
                }
             
              else
                render json: {
                  status: "Failed Team not found",
                  successful: false,
                  currentpage: page + 10,
                  lumps: {},
                  lastupdated: Time.now
                }

              end #if source


            else
              lumps = Lump.where(sources: user.sources).where(created_at: time2..time).order("id DESC")
              render json: {
                status: "Successful",
                successful: true,
                lumpcount: lumps.count,
                lumps: lumps,
                lastupdated: Time.now
              }

             

            end
            
          else
            render json: {
              status: "User not found",
              successful: false,
              lumps: {},
              lastupdated: Time.now
            }


          end #end if user
        
        elsif !team.blank?
          source = Source.find_by(username: team)
          if source
            lumps = Lump.where(source_id: source.id).where(created_at: time2..time).order("id DESC")
            render json: {
              status: "Successful",
              lumpcount: lumps.count,
              successful: true,
              lumps: lumps,
              lastupdated: Time.now
            }
          else
            render json: {
              status: "No team or id found",
              lumpcount: 0,
              successful: failed,
              lumps: {},
              lastupdated: Time.now
            }



          end #if source


        else
          render json: {
            status: "Error",
            successful: false,
           lumps: {},
            lastupdated: Time.now
          }

        end
        



      end #end getMore

      def getteam
        page = params["page"]
        pages = params["pages"]
        team = params["team"]
        lastupdated = params["lastupdated"]
        verb = params["verb"]
        offset = params["offset"]

        case verb
        when "update"
          
        when "populate"

        when "nextpage"

        else
          source = Source.find_by(username: team)
          if ! source
            source = Source.find_by(id: team)
          end
          if ! source
            render json: {
              status: "Team not found",
              successful: false,
              currentpage: page,
              lumps: [],
            }
          else
            lumps = Lump.where(source_id: source.id).limit(100).order("created_at DESC")
            render json: {
              status: "Successful",
              successful: true,
              lumpcount: lumps.count,
              currentpage: page,
              lumps: [],
            }

          end

        end #end case verb




      end #end getteam

      def lumpdaily
        user = User.find_by(authentication_token: params["id"])
        date = Date.today.all_day
        time = 24.hours.ago.strftime("%Y-%m-%d %M:%S")
        if user
          #today = Lump.where(created_at: date).where(sources: user.sources).order("created_at DESC")
          #today = Lump.where("created_at > ?",time).where(sources: user.sources).order("created_at DESC")

          today = Lump.where(created_at: (Time.now - 24.hours)..Time.now).where(sources: user.sources)
          sources = Source.joins(:users).where(users: { id: user.id })
          #rLumps = LumpSerializer.new(today).serializable_hash
          #rSources = SourceSerializer.new(sources).serializable_hash
          render json: {
                   message: "Successful",
                   status: true,
                   lumps: today,
                   sources: sources,
                   user: user,
                   logintime: Time.now,
                 }
        else
          today = Lump.where(created_at: date).limit(100).order("created_at DESC")
          #rLumps = LumpSerializer.new(today).serializable_hash
          render json: {
                   message: "Failed",
                   status: false,
                   lump: today,
                   source: {},
                 }
        end
      end

      def lumpdailyleague
        user = User.find_by(authentication_token: params["id"])
        category = params[:category]
        category = category.upcase
        date = Date.today.all_day

        if user
          today = Lump.where(created_at: date).where(sources: user.sources).where(category: category).order("created_at DESC")
          render json: LumpSerializer.new(today).serializable_hash.to_json
        else
          today = Lump.where(created_at: date).limit(100).order("created_at DESC")
          render json: LumpSerializer.new(today).serializable_hash.to_json
        end
      end

      def click
        user = 9999
        if params.has_key?(:id)
          user = params[:id]
        end
        begin
          lump = Lump.find(params[:lump])
        rescue
          lump = nil
        end

        if lump
          views = lump.views
          views = views + 1
          lump.views = views
          lump.save
          click = Click.create(lump_id: params[:lump], user_id: user)
          if click.save
            render json: {
                     status: "Successful",
                     state: true,
                     lump: lump,

                   }
          else
            render json: {
                     status: "Failed",
                     state: false,

                   }
          end
        else
          render json: {
                   status: "Failed",
                   state: false,

                 }
        end
      end

      def postclick
        userid = params["userid"]
        lump = params["lump"]

        begin
          lump = Lump.find(params[:lump])
        rescue
          lump = nil
        end

        if lump
          views = lump.views
          views = views + 1
          lump.views = views
          lump.save

          click = Click.create(lump_id: params[:lump], user_id: userid)
          if click.save
            render json: {
                     status: "Successful",
                     state: true,
                     lump: lump,

                   }
          else
            render json: {
                     status: "Click Save Failed",
                     state: false,

                   }
          end
        else
          render json: {
                   status: "Lump not found Failed",
                   state: false,

                 }
        end
      end

      def showlumps
        sourcearray = [5, 14, 10, 11, 85, 83]
        lumps = Lump.where(source_id: sourcearray).where(created_at: (Time.now - 10.minute)..Time.now)
        render json: {
          status: "Found",
          lumps: lumps,

        }
      end

      private

      def authenticate_user
        #Authorization: Bearer <token>
        token,_options = token_and_options(request)
      end

      def options
        @options ||= { include: %i[reviews] }
      end

      def lump_params
        params.require(:lump).permit(:title, :body, :preview)
      end
    end
  end
end
