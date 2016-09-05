require "meta_model/version"
require "active_model_serializers"

module MetaModel
  extend ActiveSupport::Autoload
  autoload :MetaModel
  autoload :MetaModelSerializer
end
