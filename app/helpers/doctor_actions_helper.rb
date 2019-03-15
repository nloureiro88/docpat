module DoctorActionsHelper
  def doctorActions(doc, pat)
    doctorInfo = {}
    doctorInfo[:updates] = Update.joins(:topic).where(user: doc).where("topics.status = 'active' AND topics.patient_id = ?", pat.id)
    documents = Document.joins(:topic).where(user: doc, status: 'active').where("topics.status = 'active' AND topics.patient_id = ?", pat.id)
    doctorInfo[:documents] = documents.where.not(doc_type: "Exam")
    doctorInfo[:exams] = documents.where(doc_type: "Exam")
    doctorInfo[:schedules] = Schedule.joins(:topic).where(user: doc, status: 'active').where("topics.status = 'active' AND topics.patient_id = ?", pat.id)
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
