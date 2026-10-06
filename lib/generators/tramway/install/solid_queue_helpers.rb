# frozen_string_literal: true

module Tramway
  module Generators
    # nodoc
    module InstallGeneratorSolidQueueHelpers
      TRAMWAY_SOLID_QUEUE_BULK_ACTIONS_QUEUE = 'tramway_solid_queue_bulk_actions'
      TRAMWAY_SOLID_QUEUE_BULK_ACTIONS_CONCURRENCY = 20

      private

      def queue_yml_path
        @queue_yml_path ||= File.join(destination_root, 'config/queue.yml')
      end

      def insert_tramway_solid_queue_worker(content)
        insertion_index, item_indent = workers_list_insertion_point(content)
        return content unless insertion_index

        content.dup.insert(insertion_index, tramway_solid_queue_worker_entry(item_indent))
      end

      # Finds where the `workers:` YAML list ends, so a new worker entry can be appended
      # right after the existing ones, matching their indentation. This is line-based
      # (rather than a full YAML parse) so ERB tags, comments, and anchors/aliases already
      # present in the host app's queue.yml are left untouched.
      def workers_list_insertion_point(content)
        lines = content.each_line.to_a
        workers_line_index = lines.find_index { |line| line.match?(/^[ \t]*workers:[ \t]*\n?\z/) }
        return [nil, nil] unless workers_line_index

        item_indent = lines[workers_line_index + 1]&.[](/^[ \t]*(?=- )/)
        return [nil, nil] unless item_indent

        search_range = (workers_line_index + 1)...lines.length
        end_index = search_range.find { |index| !lines[index].start_with?(item_indent) }
        end_index ||= lines.length

        [lines[0...end_index].join.length, item_indent]
      end

      def tramway_solid_queue_worker_entry(indentation)
        sub_indentation = "#{indentation}  "

        <<~YAML
          #{indentation}- queues: #{TRAMWAY_SOLID_QUEUE_BULK_ACTIONS_QUEUE}
          #{sub_indentation}threads: #{TRAMWAY_SOLID_QUEUE_BULK_ACTIONS_CONCURRENCY}
          #{sub_indentation}processes: 1
          #{sub_indentation}polling_interval: 1
        YAML
      end
    end
  end
end
