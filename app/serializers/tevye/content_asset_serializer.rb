class Tevye::ContentAssetSerializer < ActiveModel::Serializer
  attributes :id, :width, :height, :site_id, :content_type, :source_filename, :url

  def url
    @object.source.url
  end

  def source_filename
    @object.source.filename
  end
end
