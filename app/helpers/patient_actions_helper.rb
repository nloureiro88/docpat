module PatientActionsHelper
  def patientActions(pat)
    patientInfo = {}
    patientInfo[:updates] = Update.joins(:topic).where("topics.status = 'active' AND topics.patient_id = ?", pat.id)
    patientInfo[:documents] = Document.joins(:topic).where("documents.status = 'active' AND documents.doc_type != 'Exam' AND topics.status = 'active' AND topics.patient_id = ?", pat.id)
    patientInfo[:exams] = Document.joins(:topic).where("documents.status = 'active' AND documents.doc_type = 'Exam' AND topics.status = 'active' AND topics.patient_id = ?", pat.id)
    patientInfo[:schedules] = Schedule.joins(:topic).where("schedules.status = 'active' AND topics.status = 'active' AND topics.patient_id = ?", pat.id)
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
