require_relative '../../../spec_helper'

describe Tevye::Finder::ContentEntries do
  let(:site) { create_site }
  let(:site_type) { FactoryGirl.build(:content_type, site: site) do |type|
    type.entries_custom_fields.build label: 'Stringy', name: 'title', type: 'string'
  end.tap(&:save!) }
  let(:site_type_entry) { site_type.entries.create(slug: 'entry-slug', title: 'Entry Title') }

  let(:site_type2) { FactoryGirl.build(:content_type, slug: 'type-2', site: site) do |type|
    type.entries_custom_fields.build label: 'Stringy', name: 'title', type: 'string'
  end.tap(&:save!) }
  let(:site_type2_entry) { site_type2.entries.create(slug: 'entry-slug', title: 'Entry Title') }

  let(:site2) { FactoryGirl.create('another site') }
  let(:site2_type2) { FactoryGirl.build(:content_type, slug: 'type-2', site: site2) do |type|
    type.entries_custom_fields.build label: 'Stringy', name: 'title', type: 'string'
  end.tap(&:save!) }
  let(:site2_type2_entry) { site2_type2.entries.create(slug: 'entry-slug', title: 'Entry Title') }

  context 'given a site name, content type slug' do
    let(:finder) { Tevye::Finder::ContentEntries.new(site.id, site_type.id) }

    before(:each) do
      [site_type_entry, site_type2_entry, site2_type2_entry]
    end

    it 'should return a list of all entries' do
      finder.all.should include(site_type_entry)
    end

    it 'should not return entries for other types or themes' do
      finder.all.should_not include(site_type2_entry)
      finder.all.should_not include(site2_type2_entry)
    end

    it 'should find content entry given a slug' do
      entry = finder.find(site_type_entry.id)
      entry.id.should == site_type_entry.id
    end

    it 'should return nil if entry not defined' do
      expect {
       finder.find(site_type2_entry.id)
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end
end
