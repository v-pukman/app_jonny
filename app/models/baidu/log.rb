class Baidu::Log
  def self.error class_name, method_name, error, context={}
    ::Log.error ::Log::BAIDU_AREA, class_name, method_name, error, context
  end
end
