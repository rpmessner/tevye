require_relative '../../spec_helper'

describe Tevye::SnippetSerializer do
  let(:site) { create_site }
  let(:snippet) { FactoryGirl.create(:snippet, site: site, template: template) }
  let(:template) { <<-EOF }
  {% assign foo = true}
  {% if foo %}Success{% else %}Failure{% endif %}
EOF
  it 'should serialize a snippet to json' do
    serializer = Tevye::SnippetSerializer.new(snippet, {})
    hash = serializer.as_json
    hash.should == {
      snippet: {
        id:       snippet.id,
        site_id:  site.id,
        slug:     'header',
        name:     'My website title',
        template: { "en" => template }
      }
    }
  end
end