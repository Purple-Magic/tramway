# frozen_string_literal: true

describe Tailwinds::BackButtonComponent, type: :component do
  before do
    allow(I18n).to receive(:t).and_call_original
    allow(I18n).to receive(:t).with('actions.back').and_return('Back')
  end

  it 'renders link with back classes and translation' do
    render_inline(described_class.new)

    expect(page).to have_css "a[href='#']", text: 'Back'
    expect(page).to have_css(
      'a.btn.btn-delete.bg-orange-500.hover\:bg-orange-700.text-white.font-bold.py-2.px-4.rounded.ml-2'
    )
    expect(page).to have_css "a[onclick='window.history.back(); return false;']"
  end
end
