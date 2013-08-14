class Tevye::SiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :page_ids, :theme_asset_ids,
             :content_type_ids, :site_id, :locales, :default_locale
  def site_id
    @object.id
  end
end
