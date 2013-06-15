class Tevye::ThemeAssetSerializer < ActiveModel::Serializer
  attributes :id, :site_id, :folder, :source_filename, :url, :original_source

  def include_original_source?
    %w(stylesheets javascripts).include? @object.folder
  end

  def original_source
    @object.source.file.read
  end

  def url
    @object.source.url
  end

  def source_filename
    @object.source.filename
  end
end
