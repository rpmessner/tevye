class Tevye::ThemeAssetSerializer < ActiveModel::Serializer
  attributes :id, :site_id, :folder, :source_filename,
             :url, :source_ext, :original_source, :mode

  MODE_MAP = {
    'javascripts' => 'javascript',
    'stylesheets' => 'css',
    'images'      => 'image' }

  def mode
    MODE_MAP[self.folder] || 'other'
  end

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
    @object.source.file.filename
  end

  def source_ext
    @object.source.file.extension
  end
end
