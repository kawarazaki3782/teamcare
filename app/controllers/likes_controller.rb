class LikesController < ApplicationController
    def create
      if params[:micropost_id].nil?
        @diary = Diary.find(params[:diary_id])
        if @diary.user_id != current_user.id
        @like = current_user.likes.create!(diary_id: @diary.id)
        redirect_back(fallback_location: root_path)
        
        elsif params[:diary_id].nil?
        @micropost = Micropost.find(params[:micropost_id])
        if @micropost.user_id != current_user.id
           redirect_back(fallback_location: root_path)
        if @like = current_user.likes.create!(micropost_id: @micropost.id)
        redirect_back(fallback_location: root_path)
        
         else
          redirect_to current_user
         end         
         end
         end
        end
      end
      def destroy
        if params[:micropost_id].nil?
          @like = Like.find_by(diary_id: params[:diary_id], user_id: current_user.id)
          @like.destroy
          redirect_back(fallback_location: root_path)
          
        elsif params[:diary_id].nil?
          @like = Like.find_by(micropost_id: params[:micropost_id], user_id: current_user.id)
          @like.destroy
          redirect_back(fallback_location: root_path)
      
        else
          redirect_to current_user
         end   
      end
end
