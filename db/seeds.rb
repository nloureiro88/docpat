# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# Delete all current data

puts "Destroying data from all models..."

Category.destroy_all
DoctorPatient.destroy_all
Document.destroy_all
Family.destroy_all
FamilyPatient.destroy_all
Schedule.destroy_all
Update.destroy_all
Topic.destroy_all
User.destroy_all

puts 'Cleaning up Cloudinary via API...'
Cloudinary::Api.delete_all_resources

# Type lists:

puts "Creating hardcoded domain lists..."

BLOOD_TYPES = %w(A+ A- B+ B- AB+ AB- 0+ 0-)
SCHEDULE_TYPES = ['Medicine', 'Treatment', 'Physical therapy', 'Radiation therapy', 'Respiratory therapy', 'Other']
DOC_TYPES = ['Exam', 'Consultation report', 'Procedure report', 'Discharge report', 'Medical notes', 'Prescription', 'Invoice', 'Insurance', 'Other']
EXAM_TYPES = ['Sensitivity test', 'Microbiological / immunological test', 'Blood test', 'Urine test', 'Faeces test', 'Histological / exfoliative cytology',
              'Other laboratory test NEC', 'Physical function test', 'Diagnostic endoscopy', 'Diagnostic radiology / imaging', 'Electrical tracing', 'Other diagnostic procedure']

# CSV file paths:

puts "Defining file paths..."

filepath_users = './db/csv/users.csv'
filepath_categories = './db/csv/categories.csv'
filepath_topics = './db/csv/topics.csv'
filepath_specialties = './db/csv/specialties.csv'
filepath_docs = './db/csv/docs.csv'
filepath_hospitals = './db/csv/hospitals.csv'
filepath_pharmas = './db/csv/pharmas.csv'

# Creating docs Array:


puts "Creating docs array..."

file_types = []

csv_options = { col_sep: ';' }
CSV.foreach(filepath_docs, csv_options) do |row|
  file_types << row[0]
end

# Creating hospitals Array:

puts "Creating hospitals array..."

hospitals = []

csv_options = { col_sep: ';' }
CSV.foreach(filepath_hospitals, csv_options) do |row|
  hospitals << row[0]
end

# Creating pharmas Array:

puts "Creating pharmas array..."

pharmas = []

csv_options = { col_sep: ';' }
CSV.foreach(filepath_pharmas, csv_options) do |row|
  pharmas << row[0]
end

# Creating categories in DB:

puts "Creating categories in DB..."

csv_options = { col_sep: ';' }
CSV.foreach(filepath_categories, csv_options) do |row|
  Category.create(code: row[0], subject: row[1], icon_url: row[2])
end

# Creating specialties hash:

puts "Creating specialties hash..."

specialties = {}

csv_options = { col_sep: ';' }
CSV.foreach(filepath_specialties, csv_options) do |row|
  specialties[row[0]] = row[1]
end

# Creating topics hash:

puts "Creating topics hash..."

topics = {}

csv_options = { col_sep: ';' }
CSV.foreach(filepath_topics, csv_options) do |row|
  topics[row[0]] = row[1]
end

# Creating families:

puts "Creating families..."

families = ['Footinvest', 'Clubhouse', 'Ask Mom', 'Caretaker Helper', 'DocPat', 'Habit Tracker']

families.each do |fam|
  Family.create(name: fam, status: 'active') # To test with different status
end

# Creating users:

puts "Creating patients and associating families..."

csv_options = { col_sep: ';' }
CSV.foreach(filepath_users, csv_options) do |row|
  user_email = "#{row[0].downcase}.#{row[1].downcase}@lewagon.org"
  pharma = pharmas.sample
  pharma_mail = "#{pharma.downcase.tr(" ", ".")}@lewagon.org"

  new_user = User.new(email: user_email,
                      password: '654321',
                      first_name: row[0],
                      last_name: row[1],
                      gender: row[4],
                      address: row[2],
                      date_birth: Faker::Date.birthday(20, 50),
                      identity_card: Faker::Number.number(10),
                      user_type: 'patient',
                      pat_blood: BLOOD_TYPES.sample,
                      pat_pharma: pharma,
                      pat_pharma_email: pharma_mail,
                      status: 'active')
  new_user.remote_photo_url = row[3]                     # To test with different status
  new_user.save!

  unless row[5].nil?
    find_family = Family.find_by(name: row[5])
    FamilyPatient.create(family: find_family, patient: new_user, status: 'active')
  end
end

# Creating doctors:

puts "Creating male doctors..."

locations_pt = ["Lisbon", "Porto", "Beja", "Évora", "Coimbra", "Faro", "Braga", "Guimarães", "Setúbal", "Bragança"]

50.times do
  fname = Faker::Name.male_first_name
  lname = Faker::Name.last_name
  doc_email = "#{fname.downcase}.#{lname.downcase}@medical.org"

  new_doctor = User.new(email: doc_email,
                        password: '654321',
                        first_name: fname,
                        last_name: lname,
                        gender: "male",
                        address: locations_pt.sample,
                        date_birth: Faker::Date.birthday(25, 70),
                        identity_card: Faker::Number.number(10),
                        user_type: 'doctor',
                        doc_number: Faker::Number.number(8),
                        doc_institutions: hospitals.sample(rand(1..3)),
                        doc_specialties: specialties.keys.sample(rand(1..3)),
                        status: 'active')
  new_doctor.remote_photo_url = ["https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fi.dailymail.co.uk%2Fi%2Fpix%2F2016%2F08%2F28%2F01%2F37A49C5300000578-3761834-image-a-10_1472342613804.jpg&f=1",
                                "https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fi1-news.softpedia-static.com%2Fimages%2Fnews2%2FDoctor-McSteamy-Returns-to-039-Grey-039-s-Anatomy-039-2.jpg&f=1",
                                "https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2F736x%2F81%2Ff9%2F53%2F81f953425bf1ac8fc44976ee538f112b.jpg&f=1",
                                "https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F87%2F4e%2Fed%2F874eedefa8b66101edc1c2eddc0e8477.jpg&f=1",
                                "https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2F3.bp.blogspot.com%2F-vO7eiZKx4FU%2FTl_X6xLLxqI%2FAAAAAAAABOA%2F90Ujq1eIMfo%2Fs1600%2Ftumblr_li6awrYU5H1qeig70o1_400.jpg&f=1"].sample # To test with different status
  new_doctor.save!
end

puts "Creating female doctors..."

50.times do
  fname = Faker::Name.female_first_name
  lname = Faker::Name.last_name
  doc_email = "#{fname.downcase}.#{lname.downcase}@medical.org"

  new_doctor = User.new(email: doc_email,
                        password: '654321',
                        first_name: fname,
                        last_name: lname,
                        gender: "female",
                        address: locations_pt.sample,
                        date_birth: Faker::Date.birthday(25, 70),
                        identity_card: Faker::Number.number(10),
                        user_type: 'doctor',
                        doc_number: Faker::Number.number(8),
                        doc_institutions: hospitals.sample(rand(1..3)),
                        doc_specialties: specialties.keys.sample(rand(1..3)),
                        status: 'active')
  new_doctor.remote_photo_url = ["https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fi.dailymail.co.uk%2Fi%2Fpix%2F2016%2F08%2F28%2F01%2F37A49C5300000578-3761834-image-a-10_1472342613804.jpg&f=1",
                                "https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fi1-news.softpedia-static.com%2Fimages%2Fnews2%2FDoctor-McSteamy-Returns-to-039-Grey-039-s-Anatomy-039-2.jpg&f=1",
                                "https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2F736x%2F81%2Ff9%2F53%2F81f953425bf1ac8fc44976ee538f112b.jpg&f=1",
                                "https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F87%2F4e%2Fed%2F874eedefa8b66101edc1c2eddc0e8477.jpg&f=1",
                                "https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2F3.bp.blogspot.com%2F-vO7eiZKx4FU%2FTl_X6xLLxqI%2FAAAAAAAABOA%2F90Ujq1eIMfo%2Fs1600%2Ftumblr_li6awrYU5H1qeig70o1_400.jpg&f=1"].sample # To test with different status
  new_doctor.save!
end

# Mapping patients and doctors:

puts "Mapping patients and doctors..."

User.where(user_type: 'patient').each do |patient|

  x = rand(4..8)
  x.times do
    # pr_skill = rand(0..1).zero?
    # pr_time = rand(0..1).zero?
    # pr_help = rand(0..1).zero?
    # pr_kind = rand(0..1).zero?
    doctor = User.where(user_type: 'doctor').sample

    DoctorPatient.create(patient: patient,
                         doctor: doctor,
                         praise: rand(0..1).zero?,
                         status: 'active') # To test with different status
  end
end

# Creating topics:

puts "Creating health topics and respective history..."

User.where(user_type: 'patient').each do |patient|
  user_array = []
  # patient.families.each do |fam|
  #   fam.patients.each do |member|
  #     user_array << member
  #   end
  # end
  patient.doctors.each do |doc|
    user_array << doc
  end

  x = rand(3..5)
  gen_topics = topics.keys.sample(x)
  gen_topics.each do |code|
    topic = Topic.new(patient: patient,
                      title: topics[code],
                      category: Category.find_by(code: code[0]),
                      subcode: code,
                      status: 'active') # To test with different status
    topic.save!

    y = rand(3..5)
    y.times do
      rand_doctor = User.where(user_type: 'doctor').sample
      rand_doctor_name = "#{rand_doctor.first_name} #{rand_doctor.last_name}"
      update = Update.new(topic: topic,
                          user: user_array.sample,
                          diagnosis: Faker::Quote.matz,
                          next_steps: ["Take medicine XYZ", "Start treatment ABC", "New appointment on #{Faker::Date.forward(90)}", "Contact Dr. #{rand_doctor_name}"].sample(rand(1..3)),
                          topic_status: ["diagnosed", "under treatment", "cured"].sample)
      update.save!
    end
  end
end

# Creating documents and schedules for topic:

puts "Creating random documents and schedules..."

Topic.all.each do |topic|

  user_array = [topic.patient]
  topic.patient.families.each do |fam|
    fam.patients.each do |member|
      user_array << member
    end
  end
  topic.patient.doctors.each do |doc|
    user_array << doc
  end

  image_json = "{\"id\":\"6b2ac5bb949db46f470cb463791c6985.png\",\"storage\":\"cache\",\"metadata\":{\"filename\":\"Captura de ecra 2019-02-25, as 15.50.17.png\",\"size\":130178,\"mime_type\":\"image/png\",\"width\":1366,\"height\":768}}"

  x = rand(1..5)
  x.times do
    doc_type = DOC_TYPES.sample
    Document.create(topic: topic,
                    user: user_array.sample,
                    doc_title: "#{doc_type.capitalize} for #{topic.title} in #{hospitals.sample}",
                    doc_type: doc_type,
                    exam_type: doc_type == "Exam" ? EXAM_TYPES.sample : "",
                    tags: ["Important", "Follow-up", "Contact Doctor", "Tommorrow", "To Delete"].sample(rand(1..5)),
                    url: "https://www.lewagon.com",
                    file_type: file_types.sample,
                    status: ['active', 'inactive'].sample,
                    file: "https://www.lewagon.com")
  end

  y = rand(1..5)
  y.times do
    sch_type = SCHEDULE_TYPES.sample
    rand_date_start = Faker::Date.between(2.year.ago, 2.year.from_now)
    Schedule.create(topic: topic,
                    user: user_array.sample,
                    sc_title: "#{sch_type.capitalize} for #{topic.title}",
                    sc_type: sch_type,
                    schedule: ["#{rand(1..5)} times a day", "Every #{rand(2..5)} days", "Everyday", "Every week", "Every #{rand(6..12)} hours"].sample,
                    dosage: "#{rand(20..120).round(-1)} ml",
                    notes: Faker::Quote.famous_last_words,
                    date_start: rand_date_start,
                    date_end: [rand_date_start + rand(30..360), Date.new(9999, 12, 31)].sample,
                    status: ['active', 'inactive'].sample)
  end
end


# Show seeding results

puts ""
puts "------------------DATA--------------------"
puts ""
puts "BLOOD Types: #{BLOOD_TYPES.length}"
puts "SCHEDULE Types: #{SCHEDULE_TYPES.length}"
puts "DOC Types: #{DOC_TYPES.length}"
puts "EXAM Types: #{EXAM_TYPES.length}"
puts "File Types: #{file_types.length}"
puts "Hospitals: #{hospitals.length}"
puts "Pharmas: #{pharmas.length}"
puts "Categories: #{Category.count}"
puts "Specialties: #{specialties.length}"
puts "Topic List: #{topics.length}"
puts "Families: #{Family.count}"
puts "Patients: #{User.where(user_type: "patient").count}"
puts "Family-Patients: #{FamilyPatient.count}"
puts "Doctors: #{User.where(user_type: "doctor").count}"
puts "Doctors-Patients: #{DoctorPatient.count}"
puts "Topics: #{Topic.count}"
puts "Updates: #{Update.count}"
puts "Documents: #{Document.count}"
puts "Schedules: #{Schedule.count}"
puts ""

rand_pat = User.where(user_type: 'patient').sample

puts "------------------CASE--------------------"
puts ""
puts "Patient:"
p rand_pat
puts ""
puts "Families:"
p rand_pat.families.count.zero? ? "No family" : rand_pat.families
puts ""
puts "First Family Members:"
p rand_pat.families.count.zero? ? "No family" : rand_pat.families.first.patients
puts ""
puts "Doctors:"
p rand_pat.doctors
puts ""
puts "Topics:"
p rand_pat.topics
puts ""
puts "First Topic Updates:"
p rand_pat.topics.first.updates
puts ""
puts "Documents:"
p rand_pat.documents
puts ""
puts "Schedules:"
p rand_pat.schedules
puts ""
puts "------------------------------------------"




