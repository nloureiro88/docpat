module TopicStatusHelper
  def statusCount(patient)
    count_hash = { cured: 0, diagnosed: 0, treatment: 0 }

    patient.topics.where(status: 'active').each do |tp|
      last_status = tp.updates.last.topic_status.split.last.to_sym
      count_hash[last_status] += 1
    end

    count_hash
  end
end
