class DocumentsController < ApplicationController
  before_action :find_patient
  before_action :set_document, only: %i(show read deactivate)

  def index
    if params[:query].present?
      source_documents = policy_scope(Document).where(status: 'active').order('created_at DESC').documents_search(params[:query])
    else
      source_documents = policy_scope(Document).where(status: 'active').order('created_at DESC')
    end
    @documents = source_documents.select { |doc| doc.doc_type != "Exam" && doc.topic.status == 'active' && doc.topic.patient == @patient }
  end

  def index_ex
    authorize Document

    if params[:query].present?
      source_documents = policy_scope(Document).where(status: 'active', doc_type: 'Exam').order('created_at DESC').documents_search(params[:query])
    else
      source_documents = policy_scope(Document).where(status: 'active', doc_type: 'Exam').order('created_at DESC')
    end
    @documents = source_documents.select { |doc| doc.topic.status == 'active' && doc.topic.patient == @patient }
  end

  def read
    authorize Document
    @document.read_at = DateTime.now
    @document.read_by = current_user.id
    @document.save

    if @document.doc_type == "Exam"
      redirect_to index_ex_patient_documents_path(@patient, query: params[:query])
    else
      redirect_to patient_documents_path(@patient, query: params[:query])
    end
  end

  def deactivate
    authorize Document
    @document.status = "inactive"
    @document.save

    if @document.doc_type == "Exam"
      redirect_to index_ex_patient_documents_path(@patient, query: params[:query])
    else
      redirect_to patient_documents_path(@patient, query: params[:query])
    end
  end

  def new
    @patient = User.find(params[:patient_id])
    @document = Document.new
    authorize Document
  end

  def create
    @document = Document.new(document_params)
    @document.user = current_user
    #@document.topic = Topic.where(patient: current_user)
    @patient = User.find(params[:patient_id])
    #@patient = @document.topic.patient
    authorize Topic

    if @document.doc_type == "Exam"
      my_path = index_ex_patient_documents_path(@patient, query: params[:query])
    else
      my_path = patient_documents_path(@patient, query: params[:query])
    end

    respond_to do |format|
       if @document.save
         format.html { redirect_to my_path, notice: 'Document was successfully created.' }
       else
        format.html { render :new }
       end
     end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def find_patient
    @patient = User.find(params[:patient_id])
  end

  def document_params
    params.require(:document).permit(:topic_id, :user_id, :doc_type, :exam_type, :doc_title, :tags, :status, :file, :read_by, :read_at)
  end
end
