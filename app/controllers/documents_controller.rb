class DocumentsController < ApplicationController
  # before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index

    find_patient
    @topics = Topic.where(patient_id: @patient)
    @documents = policy_scope(Document).where(@topics)

    # if params[:query].present?
    #   @documents = policy_scope(Document).where(patient: @patient, status: "active").order('created_at DESC').global_search(params[:query])
    # else
    #   @documents = policy_scope(Document).where(patient: @patient, status: "active").order('created_at DESC')
    # end

  # redirect_to patient_documents_path
  end

  def show
    authorize Document
    @document = policy_scope(Document).find(params[:id])

  end

  def new
    # authorize Document
    # @document = Document.new
    # @document.user = current_user
    # @document.topic = @topic

    # redirect_to new_patient_document_path
  end

  def edit
  end

  def create
    @document = Document.new(document_params)

    @document.user = current_user
    @document.topic = @topic

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
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

def deactivate
  authorize @document
  @document.status = !@document.status
  @document.save

  reditect_to patient_document_path
end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


private

      # Use callbacks to share common setup or constraints between actions.
      def set_document
        @document = Document.find(params[:id])
        #@patient = @topic.patient
      end

      def find_patient
        @patient = User.find(params[:patient_id])
      end      # Never trust parameters from the scary internet, only allow the white list through.

      def document_params
        params.require(:document).permit(:topic_id, :user_id, :doc_type, :exam_type, :doc_title, :tags, :url, :file_type, :status, :image)
      end
end
