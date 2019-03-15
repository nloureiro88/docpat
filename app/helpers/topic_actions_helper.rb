module TopicActionsHelper
  def topicActions(topic)
    topicInfo = {}
    topicInfo[:updates] = topic.updates
    documents = topic.documents.where(status: 'active')
    topicInfo[:documents] = documents.where.not(doc_type: "Exam")
    topicInfo[:exams] = documents.where(doc_type: "Exam")
    topicInfo[:schedules] = topic.schedules.where(status: 'active')
    topicInfo
  end

  def topicNew(topic)
    topicInfo = topicActions(topic)
    topicInfo[:updates] = topicInfo[:updates].where(read_by: nil).count.positive?
    topicInfo[:documents] = topicInfo[:documents].where(read_by: nil).count.positive?
    topicInfo[:exams] = topicInfo[:exams].where(read_by: nil).count.positive?
    topicInfo[:schedules] = topicInfo[:schedules].where(read_by: nil).count.positive?
    topicInfo
  end
end
