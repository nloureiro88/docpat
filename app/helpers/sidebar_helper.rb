module SidebarHelper
  def dynamic_patient_link(current_patient, patient)
    active_class = current_patient == patient ? "pat-active" : "pat-inactive"

    path = request.path.sub(/patients\/\d+/, "patients/#{patient.id}")

    link_to path, class: active_class do
      yield
    end
  end

  def home_patient_link(current_patient, patient)
    active_class = current_patient == patient ? "pat-active" : "pat-inactive"

    path = "/patients/#{patient.id}"

    link_to path, class: active_class do
      yield
    end
  end
end
