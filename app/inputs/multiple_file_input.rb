class MultipleFileInput < SimpleForm::Inputs::FileInput
  def input(wrapper_options)
    super(wrapper_options.merge! multiple: true)
  end
end
