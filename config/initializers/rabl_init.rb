require "yajl"

class PrettyRabl
  ParseError = ::Yajl::ParseError

  def self.load(string, options={}) #:nodoc:
    ::Yajl::Parser.new(:symbolize_keys => options[:symbolize_keys]).parse(string)
  end

  def self.dump(object, options={}) #:nodoc:
    object = Hash[object.sort] if object.is_a? Hash
    if object.is_a? Array
      object.collect! { |x| x = Hash[x.sort] if x.is_a? Hash}
    end
    options.merge! :pretty=>true
    ::Yajl::Encoder.encode(object, options)
  end
end

# config/initializers/rabl_init.rb
Rabl.configure do |config|
  # Commented as these are defaults
  # config.cache_all_output = false
  # config.cache_sources = Rails.env != 'development' # Defaults to false
  # config.cache_engine = Rabl::CacheEngine.new # Defaults to Rails cache
  # config.escape_all_output = false
  config.json_engine = PrettyRabl # Any multi\_json engines
  # config.msgpack_engine = nil # Defaults to ::MessagePack
  # config.bson_engine = nil # Defaults to ::BSON
  # config.plist_engine = nil # Defaults to ::Plist::Emit
  config.include_json_root = false
  # config.include_msgpack_root = true
  # config.include_bson_root = true
  # config.include_plist_root = true
  # config.include_xml_root  = false
  # config.include_child_root = true
  # config.enable_json_callbacks = false
  # config.xml_options = { :dasherize  => true, :skip_types => false }
  # config.view_paths = []
end
