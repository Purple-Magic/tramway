# frozen_string_literal: true

require 'erb'

module Tramway
  # Displays text with size-based utility classes.
  class NativeTextComponent < Tramway::BaseComponent
    URL_REGEX = %r{https?://[^\s<]+}.freeze
    MAX_URL_LENGTH = 40

    option :text
    option :size, optional: true, default: -> { :middle }
    option :klass, optional: true, default: -> { '' }

    def lines
      @lines ||= text&.split("\n")
    end

    def text_class
      case size
      when :small
        'text-sm'
      when :large
        'text-lg'
      when :middle
        'text-base'
      else
        'md:text-sm lg:text-base'
      end + " #{klass}"
    end

    def rendered_line(line)
      helpers.safe_join(linkified_fragments(line))
    end

    private

    def linkified_fragments(line)
      fragments = []
      current_index = 0

      line.to_enum(:scan, URL_REGEX).map do
        match = Regexp.last_match
        matched_url = match[0]
        url, trailing = strip_trailing_punctuation(matched_url)

        fragments << ERB::Util.html_escape(line[current_index...match.begin(0)])
        fragments << helpers.link_to(
          shorten(url),
          url,
          target: '_blank',
          rel: 'noopener noreferrer',
          class: 'text-blue-400 underline'
        )
        fragments << ERB::Util.html_escape(trailing) if trailing.present?
        current_index = match.end(0)
      end

      fragments << ERB::Util.html_escape(line[current_index..]) if current_index < line.length
      fragments
    end

    def strip_trailing_punctuation(url)
      stripped_url = url.sub(/[.,!?;:]+\z/, '')
      trailing = url.delete_prefix(stripped_url)
      [stripped_url, trailing]
    end

    def shorten(url)
      return url if url.length <= MAX_URL_LENGTH

      "#{url[0...MAX_URL_LENGTH]}..."
    end
  end
end
