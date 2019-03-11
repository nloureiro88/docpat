module TopicActionsHelper
  def topicActions(topic)
    topicInfo = {}
    topicInfo[:updates] = topic.updates
    documents = topic.documents.select { |item| item.status == "active" }
    topicInfo[:documents] = documents.select { |doc| doc.doc_type != "Exam" }
    topicInfo[:exams] = documents.select { |doc| doc.doc_type == "Exam" }
    topicInfo[:schedules] = topic.schedules.select { |item| item.status == "active" }
    topicInfo
  end

  def topicNew(topic)
    topicInfo = topicActions(topic)
    topicInfo[:updates] = topicInfo[:updates].select { |item| item.read_by.nil? }.count.positive?
    topicInfo[:documents] = topicInfo[:documents].select { |item| item.read_by.nil? }.count.positive?
    topicInfo[:exams] = topicInfo[:exams].select { |item| item.read_by.nil? }.count.positive?
    topicInfo[:schedules] = topicInfo[:schedules].select { |item| item.read_by.nil? }.count.positive?
    topicInfo
  end
end
