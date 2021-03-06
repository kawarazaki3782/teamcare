class Api::Micropost::FavoritesController < ActionController::API
  
  def show
    args = { user_id: params[:user_id], micropost_id: params[:micropost_id] }

    if Favorite.exists?(args)
      render json: { id: Favorite.find_by!(args).id}
    else
      render json: { id: nil }
    end
  end

  def create
    if Micropost.exists?(params[:micropost_id])
      favorite = Favorite.create!(favorite_params)
      render status: 201, json: { id: favorite.id }
    else
      head :not_found
    end
  end

  def destroy
    Favorite.find(params[:id]).destroy!
    head :ok 
  end

  private 

  def favorite_params
    params.require(:favorite).permit(:user_id, :micropost_id)
  end
end