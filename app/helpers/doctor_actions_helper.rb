module DoctorActionsHelper
  def doctorActions(doc, pat)
    doctorInfo = {}
    doctorInfo[:updates] = Update.where(user: doc).select { |item| item.topic.status == "active" && item.topic.patient == pat}
    documents = Document.where(user: doc).select { |item| item.status == "active" && item.topic.status == "active" && item.topic.patient == pat}
    doctorInfo[:documents] = documents.select { |doc| doc.doc_type != "Exam" }
    doctorInfo[:exams] = documents.select { |doc| doc.doc_type == "Exam" }
    doctorInfo[:schedules] = Schedule.where(user: doc).select { |item| item.status == "active" && item.topic.status == "active" && item.topic.patient == pat}
    doctorInfo
  end

  def doctorNew(doc, pat)
    doctorInfo = doctorActions(doc, pat)
    doctorInfo[:updates] = doctorInfo[:updates].select { |item| item.read_by.nil? }.count.positive?
    doctorInfo[:documents] = doctorInfo[:documents].select { |item| item.read_by.nil? }.count.positive?
    doctorInfo[:exams] = doctorInfo[:exams].select { |item| item.read_by.nil? }.count.positive?
    doctorInfo[:schedules] = doctorInfo[:schedules].select { |item| item.read_by.nil? }.count.positive?
    doctorInfo
  end
end
