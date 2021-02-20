require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'toikke'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/toikke'
    config.fog_public = true
    config.fog_credentials = {

      provider: 'AWS',
      region: 'ap-northeast-1',
      aws_access_key_id: 'AKIAJUVNSRSITZ3ZZHAA',
      aws_secret_access_key: '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'
    }
  else
    config.storage :file
  end

end

