class ResourceUploader < CarrierWave::Uploader::Base
  # storage :file
  # def store_dir
  #   "resources/#{model.resource_type.to_s.underscore}s"
  # end
  include Cloudinary::CarrierWave
    
  version :standard do 
    process resize_to_fill: [160,240, :north]
  end
  
  version :thumb do
    process resize_to_fit: [60,90]
  end
  
  def filename
    "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  def normal_name
    "#{original_filename}" if original_filename.present?
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end
