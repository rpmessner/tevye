require_relative '../../../spec_helper'

describe Tevye::Finder::Pages do
  let(:site) { create_site }
  let(:site_page) { site.pages.first }

  let(:site2) { FactoryGirl.create('another site') }
  let(:site2_page) { site2.pages.first }

  context 'given a theme id' do
    let(:finder) { Tevye::Finder::Pages.new(site.id) }

    context 'base finders' do
      it 'should return a list of all pages' do
        finder.all.should include(site_page)
      end

      it 'should not return pages for other themes' do
        finder.all.should_not include(site2_page)
      end

      it 'should find page given an id' do
        page = finder.find(site_page.id)
        page.id.should == site_page.id
      end

      it 'should throw exception if page not defined' do
        expect {
          finder.find(site2_page.id)
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
