class Baidu::Service::Track::Developer < Baidu::Service::Base
  def self.save_track developer
    attrs = build_attrs developer
    track = developer.tracks.where(day: attrs[:day]).first
    if track.nil?
      return developer.tracks.last if no_changes? developer
      track = developer.tracks.build attrs
      track.save!
      track
    else
      track.update_attributes attrs
      track
    end
  rescue ActiveRecord::RecordNotUnique
    track = developer.tracks.where(day: attrs[:day]).first
    track.update_attributes attrs
    track
  rescue StandardError => e
    Baidu::Log.error self.class, :save_track, e, { developer_id: developer.try(:id), attrs: attrs }
  end

  def self.build_attrs developer
    {
      day: Date.today,
      score: developer.score,
      level: developer.level
    }
  end

  def self.no_changes? developer
    last = developer.tracks.last
    last && last.score == developer.score && last.level == developer.level
  end
end
