require_relative '../../spec_helper'

describe Tevye::PageSerializer do
  let(:site) { create_site }

  let(:raw_template) { <<-EOF }
    {%block page_content %}{% assign h1 = '<h1>Hello World</h1>' %}{{h1}}{% endblock %}
  EOF

  let(:templatized_template) { <<-EOF }
    {% extends 'parent' %}{% block page_content %}<h1>{{ content_entry.title }}</h1>{% endblock %}
  EOF

  let(:page) do
    [content_type]
    page = site.pages.where(slug: 'index').first
    page.update_attributes({
      title: 'Test Page',
      raw_template: raw_template
    })
    page
  end

  let(:templatized) do
    FactoryGirl.build(:page,
      site: site,
      parent: page,
      slug: 'templatized',
      templatized: true,
      target_klass_slug: 'recipes',
      title: 'Templatized Page',
      raw_template: templatized_template
    ).tap(&:save!)
  end

  let(:content_type) do
    FactoryGirl.build(:content_type, name: 'recipes', slug: 'recipes', site: site) do |type|
      type.entries_custom_fields.build label: 'title', type: 'string'
    end.tap(&:save!)
  end

  let(:content_entry) do
    content_type.entries.create(slug: 'content-entry', title: 'Content Entry')
  end

  it 'should serialize a page to json' do
    serializer = Tevye::PageSerializer.new(page, {})
    hash = serializer.as_json
    hash.should == {
      page: {
        site_id: site.id,
        parent_id: nil,
        child_ids: [],
        depth: 0,
        id: page.id,
        slug: { "en" => 'index' },
        title: { "en" => 'Test Page' },
        raw_template: { "en" => raw_template }
      }
    }
  end

  it 'should serialize a templatized page' do
    content_entry
    serializer = Tevye::PageSerializer.new(templatized, {})
    hash = serializer.as_json
    hash.should == {
      page: {
        id: templatized.id,
        parent_id: page.id,
        site_id: site.id,
        depth: 1,
        content_type_id: content_type.id,
        child_ids: [],
        slug: { "en" => 'content_type_template' },
        title: { "en" => 'Templatized Page' },
        raw_template: { "en" => templatized_template }
      }
    }
  end
end
