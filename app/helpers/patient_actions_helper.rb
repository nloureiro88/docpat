module PatientActionsHelper
  def patientActions(pat)
    patientInfo = {}
    patientInfo[:updates] = Update.all.order('created_at DESC').select { |item| item.topic.status == "active" && item.topic.patient == pat }
    documents = Document.where(status: 'active').order('created_at DESC').select { |item| item.topic.status == "active" && item.topic.patient == pat }
    patientInfo[:documents] = documents.select { |doc| doc.doc_type != "Exam" }
    patientInfo[:exams] = documents.select { |doc| doc.doc_type == "Exam" }
    patientInfo[:schedules] = Schedule.where(status: 'active').order('created_at DESC').select { |item| item.topic.status == "active" && item.topic.patient == pat }
    patientInfo
  end

  def patientNewCount(pat)
    patientInfo = patientActions(pat)
    patientInfo[:updates] = patientInfo[:updates].select { |item| item.read_by.nil? }.count
    patientInfo[:documents] = patientInfo[:documents].select { |item| item.read_by.nil? }.count
    patientInfo[:exams] = patientInfo[:exams].select { |item| item.read_by.nil? }.count
    patientInfo[:schedules] = patientInfo[:schedules].select { |item| item.read_by.nil? }.count
    patientInfo[:total] = patientInfo[:updates] + patientInfo[:documents] + patientInfo[:exams] + patientInfo[:schedules]
    patientInfo
  end
end
