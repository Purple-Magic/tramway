# frozen_string_literal: true

require 'erb'

module Tramway
  # Displays text with size-based utility classes.
  class NativeTextComponent < Tramway::BaseComponent
    URL_REGEX = %r{https?://[^\s<]+}.freeze
    MAX_URL_LENGTH = 41
    HEADER_REGEX = /\A(#{Regexp.escape('#')}{1,6})\s+(.+)\z/
    LIST_ITEM_REGEX = /\A[-*]\s+(.+)\z/
    HEADER_CLASSES = {
      1 => 'text-4xl font-bold leading-tight mt-4 mb-2',
      2 => 'text-3xl font-bold leading-tight mt-4 mb-2',
      3 => 'text-2xl font-semibold leading-snug mt-3 mb-2',
      4 => 'text-xl font-semibold leading-snug mt-3 mb-2',
      5 => 'text-lg font-semibold leading-snug mt-2 mb-1',
      6 => 'text-base font-semibold leading-snug mt-2 mb-1'
    }.freeze

    option :text
    option :size, optional: true, default: -> { :middle }
    option :klass, optional: true, default: -> { '' }

    def rendered_html
      # Safe because this is an empty static string literal, not user-controlled content.
      return ''.html_safe if text.blank?

      helpers.safe_join(rendered_blocks)
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

    private

    def rendered_blocks
      blocks = []
      list_items = []

      text.split("\n").each do |line|
        stripped_line = line.strip

        if stripped_line.blank?
          flush_list_items(blocks, list_items)
          next
        end

        header_match = stripped_line.match(HEADER_REGEX)
        if header_match
          flush_list_items(blocks, list_items)
          blocks << helpers.content_tag(
            "h#{header_match[1].length}",
            render_inline_markdown(header_match[2]),
            class: header_class(header_match[1].length)
          )
          next
        end

        list_match = stripped_line.match(LIST_ITEM_REGEX)
        if list_match
          list_items << helpers.content_tag(:li, render_inline_markdown(list_match[1]), class: "#{text_class} marker:hidden")
          next
        end

        flush_list_items(blocks, list_items)
        blocks << helpers.content_tag(:p, render_inline_markdown(stripped_line), class: "#{text_class} my-1")
      end

      flush_list_items(blocks, list_items)
      blocks
    end

    def flush_list_items(blocks, list_items)
      return if list_items.empty?

      blocks << helpers.content_tag(:ul, helpers.safe_join(list_items), class: "list-none pl-5 my-2 #{klass}")
      list_items.clear
    end

    def header_class(level)
      "#{HEADER_CLASSES.fetch(level)} #{klass}".strip
    end

    def render_inline_markdown(content)
      escaped_content = ERB::Util.html_escape(content)
      with_bold = escaped_content.gsub(/\*\*(.+?)\*\*/, '<strong>\\1</strong>')
      with_italics = with_bold.gsub(/(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)/, '<em>\\1</em>')
      with_underscored_italics = with_italics.gsub(/(?<!_)_(?!_)(.+?)(?<!_)_(?!_)/, '<em>\\1</em>')
      # Safe because user input has already been escaped above and only controlled tags are introduced.
      linkified(with_underscored_italics).html_safe
    end

    def linkified(content)
      fragments = []
      current_index = 0

      content.to_enum(:scan, URL_REGEX).map do
        match = Regexp.last_match
        matched_url = match[0]
        url, trailing = strip_trailing_punctuation(matched_url)

        # Safe because this fragment is sliced from `content`, which was already HTML-escaped.
        fragments << content[current_index...match.begin(0)].html_safe
        fragments << helpers.link_to(
          shorten(url),
          url,
          target: '_blank',
          rel: 'noopener noreferrer',
          class: 'text-blue-400 hover:underline'
        )
        # Safe because `trailing` can only contain stripped URL punctuation (.,!?;:).
        fragments << trailing.html_safe if trailing.present?
        current_index = match.end(0)
      end

      # Safe because this tail fragment also comes from the already escaped `content` string.
      fragments << content[current_index..].html_safe if current_index < content.length
      helpers.safe_join(fragments)
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
