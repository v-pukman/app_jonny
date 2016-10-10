class Baidu::Service::Rank < Baidu::Service::Base
  #TODO: tests!

  def download_soft_ranks
    page_number = 0
    next_page = true

    items_count = 0
    saved_count = 0

    while next_page
      result = api.get :soft_ranks, pn: page_number
      items = result['result']['data']
      items.each do |preview_info|
        items_count += 1
        app = app_service.save_item preview_info
        if app.try(:id)
          rank = save_rank app, build_rank_attrs(preview_info, Baidu::Rank::SOFT_COMMON_RANK)
          saved_count += 1 if rank.try(:id)
        end
      end

      next_page = items.any?
      page_number += 1
    end

    Baidu::Log.info self.class, :download_soft_ranks, 'download finished', { items_count: items_count, saved_count: saved_count }
  end

  def save_rank app, rank_attrs
    return nil if app.nil? || app.id.nil?

    rank = app.ranks.where(day: attrs[:day], rank_type: attrs[:rank_type]).first
    if rank.nil?
      rank = app.ranks.build(attrs)
      rank.save!
    else
      # dont update attrs for now
    end
    rank
  rescue ActiveRecord::RecordNotUnique
    app.ranks.where(day: attrs[:day], rank_type: attrs[:rank_type]).first
  rescue StandardError => e
    Baidu::Log.error self.class, :save_rank, e, rank_attrs
    nil
  end

  def build_rank_attrs preview_info, rank_type
    itemdata = app_service.fetch_itemdata_info preview_info
    {
      rank_type: rank_type,
      day: Date.today,
      rank_number: itemdata['rankingnum']
    }
  end

  def app_service
    @app_service ||= Baidu::Service::App.new
  end
end
