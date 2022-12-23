# frozen_string_literal: true

module Tramway::RecordsHelper
  # FIXME: replace to module
  def current_model_record_path(*args, **options)
    record_path args, options.merge(model: params[:model])
  end

  def edit_current_model_record_path(*args, **options)
    edit_record_path args, options.merge(model: params[:model])
  end

  def new_current_model_record_path(*args, **options)
    new_record_path args, options.merge(model: params[:model])
  end

  def current_model_records_path(*args, **options)
    records_path args, options.merge(model: params[:model])
  end

  def public_path(record)
    record.public_path || try("#{record.class.name.underscore.gsub('/', '_')}_path", record)
  end

  def model_class
    params[:model].constantize
  end

  def decorator_class(model_name = nil)
    "#{model_name || model_class}Decorator".constantize
  end

  def get_collection
    decorator_class.collections
  end

  def to_path(constant)
    constant.name.underscore.gsub '/', '_'
  end

  def search_tab_title(count)
    "#{t('helpers.scope.found')} / #{count}"
  end

  def searchable_model?(model_class)
    model_class.methods.include? :full_text_search
  end

  def build_options_for_select(name, collection)
    selected_value = params[:list_filters].present? ? params[:list_filters][name] : nil
    options_for_select(collection, selected_value)
  end

  def index_path_of_model(model_class, tab, filter)
    if tab
      records_path model: model_class, filter: filter, scope: tab
    else
      records_path model: model_class, filter: filter
    end
  end

  def collection_human_name(model_name:, collection_name:)
    if t("default.collections.#{collection_name}").include?('<span')
      t("collections.#{model_name}.#{collection_name}").pluralize(:ru)
    else
      t("default.collections.#{collection_name}")
    end
  end

  def tab_title(model_class, tab, count, _state_method = :state)
    model = model_class.name.underscore
    name = collection_human_name model_name: model, collection_name: tab
    "#{name} / #{count}"
  end

  def active_tab(tab, index)
    return :active if params[:scope].nil? && index.zero?
    return :active if params[:search].nil? && params[:scope].to_s == tab.to_s
  end

  def new_associated_record_path(object:, association:, as:)
    unless association.options[:class_name].present?
      raise "You should set `class_name` for #{association.name} association"
    end

    new_record_path(**hash)
  end

  def new_record_path_options(object, association, as)
    hash = {
      model: association.class_name,
      redirect: current_model_record_path(object.model)
    }

    if association.options[:as].present? # polymorphic? conditiion
      hash.merge! association.options[:class_name].underscore => {
        association.options[:as] => object.id,
        association.type => object.class.model_name
      }
    else
      hash.merge! association.options[:class_name].underscore => {
        as || object.model.class.name.underscore.gsub('/', '_') => object.id
      }
    end

    hash
  end

  def there_any_filters?(model_class)
    decorator_class(model_class).list_filters&.any?
  end
end
