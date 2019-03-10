module DoctorActionsHelper
  def doctorActions(doc, pat)
    info = {}
    info[:updates] = Update.where(user: doc).select { |item| item.topic.status == "active" && item.topic.patient == pat}
    documents = Document.where(user: doc).select { |item| item.status == "active" && item.topic.status == "active" && item.topic.patient == pat}
    info[:documents] = documents.select { |doc| doc.doc_type != "Exam" }
    info[:exams] = documents.select { |doc| doc.doc_type == "Exam" }
    info[:schedules] = Schedule.where(user: doc).select { |item| item.status == "active" && item.topic.status == "active" && item.topic.patient == pat}
    info
  end
end
