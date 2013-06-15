require_relative '../../../spec_helper'

describe Tevye::Finder::ContentTypes do
  let(:site) { create_site }
  let(:site_type) { FactoryGirl.build(:content_type, name: 'site_type', site: site) do |type|
    type.entries_custom_fields.build label: 'Stringy', name: 'title', type: 'string'
  end.tap(&:save!)}

  let(:site2) { FactoryGirl.create(:site, name: 'theme_2') }
  let(:site2_type) { FactoryGirl.build(:content_type, name: 'site2_type', site: site2) do |type|
    type.entries_custom_fields.build label: 'Stringy', name: 'title', type: 'string'
  end.tap(&:save!) }

  context 'given a theme id' do
    let(:finder) { Tevye::Finder::ContentTypes.new(site.id) }

    before(:each) do
      [site_type, site2_type]
    end

    it 'should return a list of all types' do
      finder.all.should include(site_type)
    end

    it 'should not return types for other themes' do
      finder.all.should_not include(site2_type)
    end

    it 'should return correct object class' do
      type = finder.find(site_type.id)
      type.class.to_s.should == "Locomotive::ContentType"
    end

    it 'should find content type given an id' do
      type = finder.find(site_type.id)
      type.id.should == site_type.id
    end

    it 'should return nil if type not defined' do
      expect {
        finder.find(site2_type.id)
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end
end
