# frozen_string_literal: true

shared_examples 'Helpers Navbar' do
  it 'renders navbar with left and right items' do
    fragment = view.tramway_navbar do |nav|
      nav.left do
        items.each do |(name, path)|
          nav.item name, path
        end
      end

      nav.right do
        items.each do |(name, path)|
          nav.item name, path
        end
      end
    end

    expect(fragment).to have_css left_items_css
    expect(fragment).to have_css right_items_css

    items.each do |(name, path)|
      expect(fragment).to have_css "#{left_items_css} a[href='#{path}']", text: name
      expect(fragment).to have_css "#{right_items_css} a[href='#{path}']", text: name
    end
  end
end
