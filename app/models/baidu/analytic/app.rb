class Baidu::Analytic::App < Baidu::Analytic::Base
  def self.not_tracked day
    apps = Baidu::App.arel_table
    tracks = Baidu::Track::App.arel_table

    subquery = tracks.
               where(tracks[:day].eq(day)).
               project('distinct app_id')

    query = apps.
            where(apps[:id].not_in(subquery)).
            project(apps[:id])

    execute query
  end

  def self.not_tracked_ids day
    not_tracked(day).map{|row| row['id'].to_i }
  end
end
