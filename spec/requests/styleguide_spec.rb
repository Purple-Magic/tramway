# frozen_string_literal: true

require 'rails_helper'

describe 'Styleguide', type: :request do
  it 'renders every component of the design system' do
    get '/styleguide'

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('tramway-button--primary', 'tramway-badge--success', 'tramway-form__input',
                                     'tramway-form__check-input', 'tramway-data-table', 'tramway-pagination',
                                     'tramway-chat__bubble', 'tramway-tooltip__panel')
  end
end
