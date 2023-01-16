class Admin::BookForm < Tramway::ApplicationForm
  properties :title, :description

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        description: :text
    end
  end
end
