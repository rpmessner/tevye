require 'integration_helper'

describe "Pages" do
  let(:password) { 'easyone' }
  let(:user) { FactoryGirl.create('admin user') }
  let(:site) { Tevye::Creator::Sites.new.create(name: 'test-site', subdomain: 'test') }
  let(:membership) { site.memberships.build(account: user) }

  before(:each) do
    membership.save
    login
  end

  it 'should allow you to create a new page nested under the current selected page', firebug: true, js: true do
    visit "/tevye/#/sites/#{site.id}/pages/#{site.pages.first.id}"

    create_page 'Child Page'
    create_page 'Child Page 2'

    plus_icon_css = "i.glyphicon.glyphicon-plus"
    binding.pry
    find("#{plus_icon_css}:first").click()

    page.should have_content('Child Page')
    page.should have_content('Child Page 2')

    index  = Locomotive::Page.find_by_slug('index')
    child  = Locomotive::Page.find_by_slug('child-page')
    child2 = Locomotive::Page.find_by_slug('child-page-2')

    find("a[href='#/sites/#{site.id}/pages/#{child.id}']").click()

    create_page 'Grandchild Page'

    find("#{plus_icon_css}:first").click()

    page.should have_content('Grandchild Page')

    grandchild = Locomotive::Page.find_by_slug('grandchild-page')

    child.parent.slug.should == 'index'

    grandchild.parent.slug.should == 'child-page'

  end

  def create_page(title)
    find('.new.page.btn').click()

    fill_in 'new-page-name', with: title
    find('input[name="new-page-name"]').native.send_keys(:return)
  end

  def login
    visit "/locomotive/sign_in"
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => password
    click_link_or_button('Log in')
  end

end
