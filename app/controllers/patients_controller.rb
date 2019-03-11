class PatientsController < ApplicationController
  before_action :find_patient
  # before_action :set_doctor, only: %i(add_doctor rem_doctor)
  # before_action :set_family, only: %i(accept_family rem_family)

  def show

  end

  def doctors
    authorize User

    if params[:query].present?
      all_doctors = @patient.doctors.where(status: "active").order(:first_name, :last_name).doctor_search(params[:query])
    else
      all_doctors = @patient.doctors.where(status: "active").order(:first_name, :last_name)
    end
    @doctors = all_doctors.select { |doc| ["active", "created"].include?(DoctorPatient.where(doctor: doc, patient: @patient).last.status)}
  end

  def doc_search
    authorize User

    if params[:query].present?
      all_doctors = User.where(user_type: "doctor", status: "active").order(:first_name, :last_name).doctor_search(params[:query])
    else
      all_doctors = User.where(user_type: "doctor", status: "active").order(:first_name, :last_name)
    end
    @doctors = all_doctors.select { |doc| DoctorPatient.where(doctor: doc, patient: @patient).count.zero? }
  end

  def accept_family
  end

  def rem_family
  end

  def add_doctor
    authorize User
    doc = User.find(params[:doctor_id])
    DoctorPatient.create(doctor: doc, patient: @patient)

    redirect_to doctors_patient_path(@patient)
  end

  def rem_doctor
    authorize User

    doc = User.find(params[:doctor_id])
    rel = DoctorPatient.where(doctor: doc, patient: @patient).last
    rel.destroy

    redirect_to doctors_patient_path(@patient)
  end

  def praise_toggle
    authorize User
    doc = User.find(params[:doctor_id])
    rel = DoctorPatient.where(doctor: doc, patient: @patient).last
    rel.praise = !rel.praise
    rel.save

    redirect_to doctors_patient_path(@patient)
  end

  private

  def find_patient
    @patient = User.find(params[:id])
  end

end
