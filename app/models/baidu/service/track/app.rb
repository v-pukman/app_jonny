class Baidu::Service::Track::App < Baidu::Service::Base
  def self.save_track app
    attrs = build_attrs app
    record = app.tracks.where(day: attrs[:day]).first
    if record.nil?
      record = app.tracks.build attrs
      record.save!
      record
    else
      record.update_attributes attrs
      record
    end
  rescue ActiveRecord::RecordNotUnique
    record = app.tracks.where(day: attrs[:day]).first
    record.update_attributes attrs
    record
  rescue StandardError => e
    Baidu::Log.error self.class, :save_track, e, { app_id: app.try(:id), attrs: attrs }
  end

  def self.build_attrs app
    day = Date.today
    attrs = app.attributes.keep_if {|a| Baidu::Track::App.column_names.include?(a.to_s)}
    attrs.symbolize_keys!
    attrs.delete :created_at
    attrs.delete :updated_at
    attrs.delete :id
    attrs[:day] = day
    attrs
  end
end