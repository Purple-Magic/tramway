# frozen_string_literal: true

describe Tramway::Helpers::FormHelper, type: :helper do
  let(:dummy_class) do
    Class.new do
      include Tramway::Helpers::FormHelper
    end
  end

  let(:dummy_instance) { dummy_class.new }

  describe '#tramway_form' do
    it 'returns a form object' do
      object = instance_double(User)
      form_class = class_double(UserForm)
      form_object = instance_double(UserForm)

      expect(Tramway::Forms::ClassHelper).to receive(:form_class).with(object, nil, nil).and_return(form_class)

      expect(form_class).to receive(:new).with(object).and_return(form_object)

      expect(dummy_instance.tramway_form(object)).to eq(form_object)
    end

    it 'passes form and namespace options to ClassHelper' do
      object = instance_double(User)
      form = class_double(AdminForm)
      namespace = class_double(Admin)
      form_class = class_double(UserForm)
      form_object = instance_double(UserForm)

      expect(Tramway::Forms::ClassHelper).to receive(:form_class).with(object, form, namespace).and_return(form_class)
      expect(form_class).to receive(:new).with(object).and_return(form_object)

      expect(dummy_instance.tramway_form(object, form:, namespace:)).to eq(form_object)
    end
  end
end
