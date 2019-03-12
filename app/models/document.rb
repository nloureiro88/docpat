class Document < ApplicationRecord
  belongs_to :topic
  belongs_to :user

  delegate :patient, to: :topic, allow_nil: true

  mount_uploader :file, DocumentUploader

  DOC_TYPES = ['Exam', 'Consultation report', 'Procedure report', 'Discharge report', 'Medical notes', 'Prescription', 'Invoice', 'Insurance', 'Other']
  EXAM_TYPES = ['Sensitivity test', 'Microbiological / immunological test', 'Blood test', 'Urine test', 'Faeces test', 'Histological / exfoliative cytology',
                'Other laboratory test NEC', 'Physical function test', 'Diagnostic endoscopy', 'Diagnostic radiology / imaging', 'Electrical tracing', 'Other diagnostic procedure']
  STATUS = ['active', 'inactive']

  validates :topic_id, presence: true, allow_blank: false
  validates :user_id, presence: true, allow_blank: false
  #validates :doc_type, inclusion: { in: DOC_TYPES }
  #validates :doc_title, presence: true, allow_blank: false, uniqueness: { scope: :topic_id }
  #validates :url, presence: true, allow_blank: false
  #validates :status, inclusion: { in: STATUS }
  #validate :val_exam_type

  include PgSearch
    pg_search_scope :documents_search,
      against: [:status, :created_at],
      associated_against: {
         topic: [:subcode, :title],
         user: [:first_name, :last_name, :doc_specialties]
      },
      using: {
        tsearch: { prefix: true }
      }

  def val_exam_type
    return unless doc_type == "Exam"

    errors.add("Exam type not present in the list") unless EXAM_TYPES.include?(exam_type)
  end
end
