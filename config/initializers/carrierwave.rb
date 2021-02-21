require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'toikke'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/toikke'
    config.fog_public = false
    config.fog_credentials = {

      provider: 'AWS',
      region: 'ap-northeast-1',
      aws_access_key_id: 'AKIAYJZR3NNC6JZ64FXG',
      aws_secret_access_key: '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'
    }
  else
    config.storage :file
  end

end

