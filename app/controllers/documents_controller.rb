class DocumentsController < ApplicationController
  # before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @patient = User.find(params[:patient_id])
    if params[:query].present?
      source_documents = policy_scope(Document).order('created_at DESC').documents_search(params[:query])
    else
      source_documents = policy_scope(Document).order('created_at DESC')
    end
    @documents = source_documents.select { |doc| doc.topic.status == "active" && doc.topic.patient == @patient }
  end

def index_ex
    @patient = User.find(params[:patient_id])
    if params[:query].present?
      source_documents = policy_scope(Document).order('created_at DESC').documents_search(params[:query])
    else
      source_documents = policy_scope(Document).order('created_at DESC')
    end
    @documents = source_documents.select { |doc| doc.topic.status == "active" && doc.topic.patient == @patient }
    #@documents = source_documents.select { |doc| doc.topic.status == "active" && doc.topic.patient == @patient && doc.doc_type == "Exam" }
  end

  def show
    set_document
    @patient = policy_scope(Document).find(params[:patient_id])
  end

  def deactivate
    authorize Document
    @document = policy_scope(Document).find(params[:id])
    @patient = @document.patient
    #@patient = policy_scope(Document).find(params[:patient_id])
    #@document[:status] = "mudou"
    @document.status = !@document.status
    #@document.save
    redirect_to patient_topics_path(@patient)
end

  def download
    set_document
    @document.image_url
    #require 'open-uri'
    File.write '@document.image_data.metadata.filename', open(@document.image_url).read
  end

  def new

    @document = Document.new


  end

  def create
    @document = Document.new(document_params)
    @document.user = current_user
    @document.topic = @topic
    authorize Topic
    authorize Update
    if @document.save
       redirect_to back root #patient_documents_path(@patient)
     else
       render :new
     end

    # respond_to do |format|
    #    if @document.save
    #      format.html { redirect_to @document, notice: 'Document was successfully created.' }
    #      format.json { render :show, status: :created, location: @document }
    #    else
    #      format.html { render :new }
    #      format.json { render json: @document.errors, status: :unprocessable_entity }
    #    end
    #  end

  end

  def edit
    # authorize Document
    @document = policy_scope(Document).find(params[:id])
    @patient = @document.patient
    authorize Document

    respond_to do |format|
       if @document.update(document_params)
         format.html { redirect_to @document, notice: 'Document was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @document }
       else
         format.html { render :edit }
         format.json { render json: @document.errors, status: :unprocessable_entity }
       end
     end
  end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


private

      def set_document
        #authorize Document
        #@document = policy_scope(Document).find(params[:id])
        @document = Document.find(params[:id])
      end

      def find_patient
        @patient = User.find(params[:patient_id])
      end

      def document_params
        params.require(:document).permit(:topic_id, :user_id, :doc_type, :exam_type, :doc_title, :tags, :url, :file_type, :status, :image)


      end
end
