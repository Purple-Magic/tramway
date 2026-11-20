# frozen_string_literal: true

module Tramway
  module Nav
    # Base class for all Nav::ItemComponent classes
    #
    class ItemComponent < TailwindComponent
      def style
        @style ||= 'tramway-navbar-item tramway-nav-item'
      end

      def icon?
        @icon.present?
      end

      def icon_classes
        [@icon, 'tramway-navbar-item-icon tramway-nav-item__icon'].join(' ')
      end
    end
  end
end
