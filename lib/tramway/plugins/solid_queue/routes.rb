# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # Draws the routes for the solid_queue dashboard plugin, mounted at the
      # plugin's configured `path` (defaults to `/jobs`).
      module Routes
        module_function

        def draw(mapper, _config)
          draw_queues(mapper)
          draw_recurring_tasks(mapper)
          draw_jobs(mapper)
        end

        def draw_queues(mapper)
          mapper.instance_exec do
            resources :queues, only: %i[index], param: :name, module: 'plugins/solid_queue' do
              post :pause, on: :member
              post :resume, on: :member
              post :clear, on: :member
            end
          end
        end

        def draw_recurring_tasks(mapper)
          mapper.instance_exec do
            resources :recurring_tasks, only: %i[index], param: :key, module: 'plugins/solid_queue' do
              post :enqueue, on: :member
            end
          end
        end

        def draw_jobs(mapper)
          mapper.instance_exec do
            resources :jobs, path: '', only: %i[index show destroy], module: 'plugins/solid_queue' do
              post :retry, on: :member
              post :discard, on: :member
              post :bulk_retry, on: :collection
              post :bulk_discard, on: :collection
              post :bulk_destroy, on: :collection
            end
          end
        end
      end
    end
  end
end
