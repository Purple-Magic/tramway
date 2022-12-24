class Admin::RentForm < Tramway::ApplicationForm
  properties :begin_date, :end_date

  association :reader
  association :book

  def initialize(object)
    super(object).tap do
      form_properties begin_date: :date_picker,
        end_date: :date_picker,
        book: :association,
        reader: :association
    end
  end
end
