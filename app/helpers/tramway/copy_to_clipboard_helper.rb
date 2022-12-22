# frozen_string_literal: true

module Tramway
  module CopyToClipboardHelper
    def copy_to_clipboard(id)
      button_tag class: 'btn btn-info clipboard-btn',
                 data: { clipboard_action: 'copy', clipboard_target: "##{id}" },
                 style: 'margin-left: 15px' do
        fa_icon 'copy'
      end
    end
  end
end
