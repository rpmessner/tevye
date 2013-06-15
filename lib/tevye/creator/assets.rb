class Tevye::Creator::Assets < Tevye::Creator
  def create(attributes)
    unless attributes[:source].present?
      raise ArgumentError.new('need a file or filename') unless attributes[:name].present?
      name = File.join(Dir::tmpdir, attributes[:name])
      file = File.new(name, "w")
      if attributes[:file_source].present?
        file.write attributes[:file_source]
        attributes.delete(:file_source)
      end
      attributes.delete(:name)
      attributes[:source] = file
    end
    super(attributes)
  end
end