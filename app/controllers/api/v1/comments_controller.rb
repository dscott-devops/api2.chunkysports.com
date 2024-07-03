module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_comment, only: %i[ show edit update destroy ]
      skip_before_action :verify_authenticity_token
      protect_from_forgery with: :null_session

      # GET /comments or /comments.json
      def index
        @comments = Comment.all
      end

      def getcomments
        begin
          lump = Lump.find(params[:id])
        rescue
          lump = nil
        end

        if lump
          comments = Comment.where(lump_id: lump.id)
          rComments = CommentSerializer.new(comments).serializable_hash
          render json: {
                   message: "Successful",
                   status: true,
                   comments: rComments,
                 }
        else
          render json: {
                   message: "Failed Lump Not found",
                   status: false,
                   comments: {},
                 }
        end
      end

      # GET /comments/1 or /comments/1.json
      def show
      end

      # GET /comments/new
      def new
        @comment = Comment.new
      end

      # GET /comments/1/edit
      def edit
      end

      # POST /comments or /comments.json
      def create
        @comment = Comment.new(comment_params)

        respond_to do |format|
          if @comment.save
            format.html { redirect_to comment_url(@comment), notice: "Comment was successfully created." }
            format.json { render :show, status: :created, location: @comment }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
          end
        end
      end

      # PATCH/PUT /comments/1 or /comments/1.json
      def update
        respond_to do |format|
          if @comment.update(comment_params)
            format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
            format.json { render :show, status: :ok, location: @comment }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /comments/1 or /comments/1.json
      def destroy
        @comment.destroy

        respond_to do |format|
          format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
          format.json { head :no_content }
        end
      end

      def createcomment
        if params.has_key?(:comment)
          body = params["comment"]["body"]
          lump_id = params["comment"]["lump_id"]
          parent_id = params["comment"]["parent_id"]
          user_id = params["comment"]["user_id"]
          likes_id = params["comment"]["likes_id"]
          image = params["comment"]["image"]
          displayname = params["comment"]["displayname"]
          token = params["comment"]["token"]

          lump = Lump.find_by(id: lump_id)

          if lump
            user = User.find_by(authentication_token: token)
            if user
              comment = Comment.create(body: body,
                                       lump_id: lump_id,
                                       parent_id: parent_id,
                                       user_id: user_id,
                                       likes_id: likes_id,
                                       image: image,
                                       displayname: displayname,
                                       source_id: lump.source_id)
              if comment.save
                render json: {
                         message: "Successful",
                         status: true,
                       }
              else
                render json: {
                         message: "Failed",
                         status: false,
                       }
              end
            else
              render json: {
                       message: "Unauthorized",
                       status: false,
                     }
            end
          else
            render json: {
                     message: "Unauthorized",
                     status: false,
                   }
          end
        else
          render json: {
                   message: "Lump Not found",
                   status: false,
                 }
        end
      end #def createcomment

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_comment
        @comment = Comment.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def comment_params
        params.require(:comment).permit(:body, :lump_id, :parent_id)
      end
    end
  end
end
