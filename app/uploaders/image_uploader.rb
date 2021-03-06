class ImageUploader < CarrierWave::Uploader::Base
  if Rails.env.development?
    storage :file
  elsif Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # リサイズしたり画像形式を変更するのに必要
  include CarrierWave::MiniMagick
  

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  #   # CarrierWave.configure do |config|
  #   #   config.remove_previously_stored_files_after_update = false
  #   # end

  # サムネイルの為に画像をリサイズ
  process resize_to_fill: [200, 200, 'center']

  version :thumb100 do
    process resize_to_fill: [100, 100, 'center']
  end

  # #   def remove!
  # #     unless model.keep_file
  # #       super
  # #     end
  # #  end

  def default_url(*_args)
    #     # # For Rails 3.1+ asset pipeline compatibility:
    #     # # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    'default.jpg'
    #     # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end
end
