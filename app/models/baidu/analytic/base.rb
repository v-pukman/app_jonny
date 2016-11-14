class Baidu::Analytic::Base
  def self.execute query
    result = ActiveRecord::Base.connection.execute query.to_sql
    result.as_json
  end
end
