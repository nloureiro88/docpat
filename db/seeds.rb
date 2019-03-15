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

puts 'Cleaning up Cloudinary via API'
Cloudinary::Api.delete_all_resources

# Type lists:

puts "Creating hardcoded domain lists..."

BLOOD_TYPES = %w(A+ A- B+ B- AB+ AB- 0+ 0-)
SCHEDULE_TYPES = ['Medicine', 'Treatment', 'Physical therapy', 'Radiation therapy', 'Respiratory therapy', 'Other']
DOC_TYPES = ['Exam', 'Consultation report', 'Procedure report', 'Discharge report', 'Medical notes', 'Prescription', 'Invoice', 'Insurance', 'Misc']
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

families = ['Footinvest', 'Clubhouse', 'Ask Mom', 'Caretaker Helper', 'DocPat', 'Habit Tracker', 'Dunphy']

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

# Creating family members

dunphy = Family.find_by(name: 'Dunphy')
pharma = pharmas.sample
pharma_mail = "#{pharma.downcase.tr(" ", ".")}@lewagon.org"

phil = User.new(email: 'phil.dunphy@lewagon.org',
                password: '654321',
                first_name: 'Phil',
                last_name: 'Dunphy',
                gender: 'male',
                address: 'Lisbon',
                date_birth: Faker::Date.birthday(45, 52),
                identity_card: Faker::Number.number(10),
                user_type: 'patient',
                pat_blood: BLOOD_TYPES.sample,
                pat_pharma: pharma,
                pat_pharma_email: pharma_mail,
                status: 'active')
phil.remote_photo_url = 'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fpbs.twimg.com%2Fprofile_images%2F655606044593270784%2FQ2zXWsr__400x400.jpg&f=1'
phil.save!
FamilyPatient.create(family: dunphy, patient: phil, status: 'active')

claire = User.new(email: 'claire.dunphy@lewagon.org',
                password: '654321',
                first_name: 'Claire',
                last_name: 'Dunphy',
                gender: 'female',
                address: 'Lisbon',
                date_birth: Faker::Date.birthday(40, 50),
                identity_card: Faker::Number.number(10),
                user_type: 'patient',
                pat_blood: BLOOD_TYPES.sample,
                pat_pharma: pharma,
                pat_pharma_email: pharma_mail,
                status: 'active')
claire.remote_photo_url = 'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.citytv.com%2Fwp-content%2Fuploads%2F2012%2F12%2FMF_124865_08_Julie_Bowen_BD_0416_R2-e1389999199579-300x300.jpg&f=1'
claire.save!
FamilyPatient.create(family: dunphy, patient: claire, status: 'active')

jay = User.new(email: 'jay.prichett@lewagon.org',
                password: '654321',
                first_name: 'Jay',
                last_name: 'Prichett',
                gender: 'male',
                address: 'Lisbon',
                date_birth: Faker::Date.birthday(68, 75),
                identity_card: Faker::Number.number(10),
                user_type: 'patient',
                pat_blood: BLOOD_TYPES.sample,
                pat_pharma: pharma,
                pat_pharma_email: pharma_mail,
                status: 'active')
jay.remote_photo_url = 'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fvignette4.wikia.nocookie.net%2Fmodernfamily%2Fimages%2F2%2F22%2FJay-port.jpg%2Frevision%2Flatest%3Fcb%3D20150310161348&f=1'
jay.save!
FamilyPatient.create(family: dunphy, patient: jay, status: 'active')

haley = User.new(email: 'haley.dunphy@lewagon.org',
                password: '654321',
                first_name: 'Haley',
                last_name: 'Dunphy',
                gender: 'female',
                address: 'Lisbon',
                date_birth: Faker::Date.birthday(18, 21),
                identity_card: Faker::Number.number(10),
                user_type: 'patient',
                pat_blood: BLOOD_TYPES.sample,
                pat_pharma: pharma,
                pat_pharma_email: pharma_mail,
                status: 'active')
haley.remote_photo_url = 'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fvignette3.wikia.nocookie.net%2Fmodernfamily%2Fimages%2Fd%2Fd8%2FHaley-port.jpg%2Frevision%2Flatest%3Fcb%3D20150310161919&f=1'
haley.save!
FamilyPatient.create(family: dunphy, patient: haley, status: 'active')

alex = User.new(email: 'alex.dunphy@lewagon.org',
                password: '654321',
                first_name: 'Alex',
                last_name: 'Dunphy',
                gender: 'female',
                address: 'Lisbon',
                date_birth: Faker::Date.birthday(15, 18),
                identity_card: Faker::Number.number(10),
                user_type: 'patient',
                pat_blood: BLOOD_TYPES.sample,
                pat_pharma: pharma,
                pat_pharma_email: pharma_mail,
                status: 'active')
alex.remote_photo_url = 'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fvignette1.wikia.nocookie.net%2Fmodernfamily%2Fimages%2Fd%2Fd9%2FAlex-port.jpg%2Frevision%2Flatest%3Fcb%3D20150310161934&f=1'
alex.save!
FamilyPatient.create(family: dunphy, patient: alex, status: 'active')

luke = User.new(email: 'luke.dunphy@lewagon.org',
                password: '654321',
                first_name: 'Luke',
                last_name: 'Dunphy',
                gender: 'male',
                address: 'Lisbon',
                date_birth: Faker::Date.birthday(12, 14),
                identity_card: Faker::Number.number(10),
                user_type: 'patient',
                pat_blood: BLOOD_TYPES.sample,
                pat_pharma: pharma,
                pat_pharma_email: pharma_mail,
                status: 'active')
luke.remote_photo_url = 'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fimages4.wikia.nocookie.net%2F__cb20130227073761%2Fdoblaje%2Fes%2Fimages%2F6%2F63%2FLukemodern.png&f=1'
luke.save!
FamilyPatient.create(family: dunphy, patient: luke, status: 'active')


# Creating doctors:

puts "Creating male doctors..."

locations_pt = ["Lisbon", "Lisbon", "Lisbon", "Lisbon", "Porto", "Beja", "Évora", "Coimbra", "Faro", "Braga", "Guimarães", "Setúbal", "Bragança"]

MALE_DOCTOR_PHOTOS = ['http://s.plurielles.fr/mmdia/i/97/7/kevin-mckidd-3673977hzwod.jpg?v=3',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2F736x%2F81%2Ff9%2F53%2F81f953425bf1ac8fc44976ee538f112b.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fi.dailymail.co.uk%2Fi%2Fpix%2F2015%2F09%2F25%2F06%2F2C70E10900000578-3248534-image-a-64_1443159937079.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fp0.storage.canalblog.com%2F00%2F22%2F1152592%2F89974091_o.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2F1.bp.blogspot.com%2F-sghc_pVJHjA%2FUNt8agMWMBI%2FAAAAAAAAAIU%2F93EtfDCQRs0%2Fs1600%2FRICHARD1.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fcc-media-foxit.fichub.com%2Fimage%2Ffox-it-mondofox%2Faaaba043-eb98-4a4c-ae77-040bee4af9f9%2Falex-karev-630x630.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2F736x%2Fee%2F65%2Fe3%2Fee65e32c26c2ec3d8c171d0c796c803a.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fdiariosur.es%2Focio%2Fnoticias%2FMedia%2F200906%2F11%2Flaurie2.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F0%2F06%2FRobert_Sean_LeonardCrop.JPG%2F245px-Robert_Sean_LeonardCrop.JPG&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.uratex.com.ph%2Findustrial-institutional%2Fwp-content%2Fuploads%2F2015%2F02%2FJD-Dorian.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fstatic.tvtropes.org%2Fpmwiki%2Fpub%2Fimages%2Fscrubs_kelso_2493.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fimg3.wikia.nocookie.net%2F__cb20110924074716%2Fscrubs%2Fimages%2F9%2F92%2FSquare_Turk.png&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.XWqupa8vZ9Kh9dpy2S86aAHaGt%26pid%3D15.1&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fvignette.wikia.nocookie.net%2Fscrubs%2Fimages%2Fd%2Fd5%2FS6-HQ-Cox.jpg%2Frevision%2Flatest%2Ftop-crop%2Fwidth%2F320%2Fheight%2F320%3Fcb%3D20141103192935&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.comphealth.com%2Fresources%2Fwp-content%2Fuploads%2F2014%2F05%2Fdoctor-computer.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fblog.bulletproof.com%2Fwp-content%2Fuploads%2F2018%2F04%2FHeadshot2.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fbonnier.imgix.net%2Fdrphil_10_seamless1_237_print-_sJ5Z4huBx1gswFZWUlDuA.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2F736x%2F75%2F87%2Fa0%2F7587a0e610095e85ebac4addba58f4fd--doctor-male-celebrities.jpg&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2F3.bp.blogspot.com%2F-Hf6nlC7wN24%2FTqkfads2nrI%2FAAAAAAAAEKc%2FFKfvMQEN1us%2Fs1600%2FGreysAnatomy3.JPG&f=1',
                      'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fm3.wyanokecdn.com%2F98d0838159596b00db27e5fd4bd6f86c.jpg&f=1']

FEMALE_DOCTOR_PHOTOS = ['https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fhips.hearstapps.com%2Fhmg-prod.s3.amazonaws.com%2Fimages%2Fan-honest-mistake-dereks-confidence-is-shaken-like-never-news-photo-93750705-1538069801.jpg%3Fcrop%3D1.00xw%3A0.669xh%3B0%2C0.0613xh%26resize%3D480%3A*&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2F736x%2F29%2F09%2Fa1%2F2909a1f19fd5c282309db17d725cf7fa--greys-anatomy-online-grey-s-anatomy.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2Foriginals%2F51%2F10%2F83%2F51108303591973c9edce4c7b18945d60.jpg&f=1',
                        'https://d1i5hut471lhig.cloudfront.net/7c134f19ba9dcc4fbaea768a8c034efbc45fd424.jpg',
                        'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.pulseheadlines.com%2Fwp-content%2Fuploads%2F2016%2F12%2Fjejeje-1.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fd1i5hut471lhig.cloudfront.net%2F30f5abf518a71a41c8eefa3b7affd9dd4cd405eb.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Ffan-grey-s-anatomy.e-monsite.com%2Fmedias%2Fimages%2Fdr-miranda-bailey-1.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2Foriginals%2Fc0%2Fff%2Faf%2Fc0ffaf7916530e94350d043a4e73720c.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia1.popsugar-assets.com%2Ffiles%2Fthumbor%2FdKympnzvqnZOL1y92i65k6rftYE%2Ffit-in%2F550x550%2Ffilters%3Aformat_auto-!!-%3Astrip_icc-!!-%2F2011%2F05%2F20%2F2%2F192%2F1922283%2Ffff2604bb1f12af9_thumb%2Fi%2FLisa-Edelstein-Quitting-House.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.austinchronicle.com%2Fbinary%2F7a9a%2FThirteen.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fbrainsnorts.files.wordpress.com%2F2012%2F07%2Fjennifer-morrison-hq22.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.yasamsifreleri.com%2Fwp-content%2Fuploads%2F2015%2F04%2Fgamze-topuz-doktorlar.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fstatic.tvtropes.org%2Fpmwiki%2Fpub%2Fimages%2Fscrubs_elliot_4536.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.canarianweekly.com%2Fwp-content%2Fuploads%2F2014%2F10%2FHealth-1.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2F736x%2Fd1%2Fba%2F0d%2Fd1ba0ddaacaaef4357a86f363eaaf718--greys-anatomy-season--lexie-grey.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.craveyoutv.com%2Fwp-content%2Fuploads%2F2013%2F08%2F300.oh_.greysanatomy.092408.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.instyle.gr%2Fwp-content%2Fuploads%2F2018%2F01%2F01%2Fdr-pimple-popper.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=http%3A%2F%2Flajonesmedia.com%2Fwp-content%2Fuploads%2F2016%2F12%2Flady-doctor-1.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2F736x%2Fed%2Ff7%2F27%2Fedf7274c4fc5fc91967bcab18deaf1ef--role-models-dr-who.jpg&f=1',
                        'https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fen%2Fa%2Fa2%2FDr_chen.jpg&f=1']

doc_counter = 0

20.times do
  fname = Faker::Name.male_first_name
  lname = Faker::Name.last_name
  doc_email = "#{fname.downcase}.#{lname.downcase}@medical.org"

  new_doctor = User.new(email: doc_email,
                        password: '654321',
                        first_name: fname,
                        last_name: lname,
                        gender: "male",
                        address: locations_pt.sample,
                        date_birth: Faker::Date.birthday(35, 55),
                        identity_card: Faker::Number.number(10),
                        user_type: 'doctor',
                        doc_number: Faker::Number.number(8),
                        doc_institutions: hospitals.sample(rand(1..2)),
                        doc_specialties: specialties.keys.sample(rand(1..3)),
                        status: 'active')
  new_doctor.remote_photo_url = MALE_DOCTOR_PHOTOS[doc_counter]
  new_doctor.save!
  doc_counter += 1
end

puts "Creating female doctors..."

doc_counter = 0

20.times do
  fname = Faker::Name.female_first_name
  lname = Faker::Name.last_name
  doc_email = "#{fname.downcase}.#{lname.downcase}@medical.org"

  new_doctor = User.new(email: doc_email,
                        password: '654321',
                        first_name: fname,
                        last_name: lname,
                        gender: "female",
                        address: locations_pt.sample,
                        date_birth: Faker::Date.birthday(35, 55),
                        identity_card: Faker::Number.number(10),
                        user_type: 'doctor',
                        doc_number: Faker::Number.number(8),
                        doc_institutions: hospitals.sample(rand(1..2)),
                        doc_specialties: specialties.keys.sample(rand(1..3)),
                        status: 'active')
  new_doctor.remote_photo_url = FEMALE_DOCTOR_PHOTOS[doc_counter]
  new_doctor.save!
  doc_counter += 1
end

emily = User.new(email: 'emily.burns@medical.org',
                 password: '654321',
                 first_name: 'Emily',
                 last_name: 'Burns',
                 gender: "female",
                 address: 'Lisbon',
                 date_birth: Faker::Date.birthday(34, 35),
                 identity_card: Faker::Number.number(10),
                 user_type: 'doctor',
                 doc_number: Faker::Number.number(8),
                 doc_institutions: ["Clinic LeWagon", "Hospital da Luz"],
                 doc_specialties: ["Psychiatric", "Pediatric"],
                 status: 'active')
emily.remote_photo_url = "https://avatars3.githubusercontent.com/u/37870441?v=4"
emily.save!

# Mapping patients and doctors:

puts "Mapping patients and doctors..."

User.where(user_type: 'patient').each do |patient|

  x = rand(4..8)
  x.times do
    # pr_skill = rand(0..1).zero?
    # pr_time = rand(0..1).zero?
    # pr_help = rand(0..1).zero?
    # pr_kind = rand(0..1).zero?
    doctor = User.where(user_type: 'doctor').reject{ |doc| doc.last_name == 'Burns' }.sample

    DoctorPatient.create(patient: patient,
                         doctor: doctor,
                         praise: rand(0..1).zero?,
                         status: 'active') # To test with different status
  end

  DoctorPatient.create(patient: patient,
                       doctor: emily,
                       praise: true,
                       status: 'active')
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
    random_dates = [rand(90..120).days.ago, rand(60..90).days.ago, rand(30..60).days.ago, rand(7..30).days.ago, rand(1..6).days.ago]
    tp_status = ['diagnosed', 'under treatment', 'under treatment', 'under treatment', 'cured']
    date_counter = 0

    y.times do
      rand_doctor = User.where(user_type: 'doctor').sample
      rand_doctor_name = "#{rand_doctor.first_name} #{rand_doctor.last_name}"
      update = Update.new(topic: topic,
                          user: user_array.sample,
                          diagnosis: Faker::Quote.matz,
                          next_steps: ["Take medicine XYZ", "Start treatment ABC", "New appointment on #{Faker::Date.forward(90)}", "Contact Dr. #{rand_doctor_name}"].sample(rand(1..3)),
                          topic_status: tp_status[date_counter],
                          read_at: Date.new,
                          read_by: topic.patient.id)
      update.created_at = random_dates[date_counter]
      update.save!
      date_counter += 1
    end
  end
end

# Populating Phil Dunphy

user_array = []
phil.doctors.each do |doc|
  user_array << doc unless doc.last_name == "Burns"
end

gen_topics = ['Excessive intimate prowess', 'Insomnia', 'Severe back pain', 'Strabismus', 'Post-traumatic stress disorder']
gen_code = ['Y24', 'P06', 'L02', 'F98', 'P82']
code_counter = 0

gen_topics.each do |topic|
  code = gen_code[code_counter]
  topic = Topic.new(patient: phil,
                    title: topic,
                    category: Category.find_by(code: code[0]),
                    subcode: code,
                    status: 'active') # To test with different status
  topic.save!

  random_dates = [rand(90..120).days.ago, rand(60..90).days.ago, rand(30..60).days.ago, rand(7..30).days.ago, rand(1..6).days.ago]
  tp_status = ['diagnosed', 'under treatment', 'under treatment', 'under treatment', 'cured']
  date_counter = 0

  topic_updates = [5, 5, 3, 2, 1]
  topic_updates[code_counter].times do
    rand_doctor = User.where(user_type: 'doctor').sample
    rand_doctor_name = "#{rand_doctor.first_name} #{rand_doctor.last_name}"
    update = Update.new(topic: topic,
                        user: user_array.sample,
                        diagnosis: Faker::Quote.matz,
                        next_steps: ["Take medicine XYZ", "Start treatment ABC", "New appointment on #{Faker::Date.forward(90)}", "Contact Dr. #{rand_doctor_name}"].sample(rand(1..3)),
                        topic_status: tp_status[date_counter],
                        read_at: Date.new,
                        read_by: phil.id)
    update.created_at = random_dates[date_counter]
    update.save!
    date_counter += 1
  end
  code_counter += 1
end

# Populating Luke Dunphy

user_array = []
luke.doctors.each do |doc|
  user_array << doc unless doc.last_name == "Burns"
end

gen_topics = ['Broken radius bone', 'Asthma', 'Chikenpox', 'Conjuntivitis allergic', 'Vertigo']
gen_code = ['L14', 'R96', 'A72', 'F71', 'N17']
code_counter = 0

gen_topics.each do |topic|
  code = gen_code[code_counter]
  topic = Topic.new(patient: luke,
                    title: topic,
                    category: Category.find_by(code: code[0]),
                    subcode: code,
                    status: 'active') # To test with different status
  topic.save!

  if topic.title == 'Broken radius bone'

    random_dates = [rand(31..32).days.ago, rand(15..30).days.ago, rand(7..15).days.ago, 1.days.ago]
    tp_status = ['diagnosed', 'under treatment', 'under treatment', 'under treatment']
    date_counter = 0

    3.times do
      rand_doctor = User.where(user_type: 'doctor').sample
      rand_doctor_name = "#{rand_doctor.first_name} #{rand_doctor.last_name}"
      update = Update.new(topic: topic,
                          user: user_array.sample,
                          diagnosis: Faker::Quote.matz,
                          next_steps: ["Take medicine XYZ", "Start treatment ABC", "New appointment on #{Faker::Date.forward(90)}", "Contact Dr. #{rand_doctor_name}"].sample(rand(1..3)),
                          topic_status: tp_status[date_counter],
                          read_at: Date.new,
                          read_by: luke.id)
      update.created_at = random_dates[date_counter]
      update.save!
      date_counter += 1
    end

    update = Update.new(topic: topic,
                        user: user_array.sample,
                        diagnosis: "The arm is still in risk of falling, it is necessary to keep the cast and reinforce preventive measures such as praying.",
                        next_steps: ["Take cast in one week", "Keep taking Ibuprofen", "Never play tennis ever again"],
                        topic_status: tp_status[3])
    update.created_at = random_dates[3]
    update.save!

  else

    random_dates = [rand(90..120).days.ago, rand(60..90).days.ago, rand(30..60).days.ago, rand(15..30).days.ago, rand(7..15).days.ago]
    tp_status = ['diagnosed', 'under treatment', 'under treatment', 'under treatment', 'cured']
    date_counter = 0

    topic_updates = [3, 5, 5, 2]
    topic_updates[code_counter].times do
      rand_doctor = User.where(user_type: 'doctor').sample
      rand_doctor_name = "#{rand_doctor.first_name} #{rand_doctor.last_name}"
      update = Update.new(topic: topic,
                          user: user_array.sample,
                          diagnosis: Faker::Quote.matz,
                          next_steps: ["Take medicine XYZ", "Start treatment ABC", "New appointment on #{Faker::Date.forward(90)}", "Contact Dr. #{rand_doctor_name}"].sample(rand(1..3)),
                          topic_status: tp_status[date_counter],
                          read_at: Date.new,
                          read_by: luke.id)
      update.created_at = random_dates[date_counter]
      update.save!
      date_counter += 1
    end
    code_counter += 1

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

  # image_json = "{\"id\":\"6b2ac5bb949db46f470cb463791c6985.png\",\"storage\":\"cache\",\"metadata\":{\"filename\":\"Captura de ecra 2019-02-25, as 15.50.17.png\",\"size\":130178,\"mime_type\":\"image/png\",\"width\":1366,\"height\":768}}"

  x = rand(1..3)
  random_dates = [rand(90..120).days.ago, rand(60..90).days.ago, rand(30..60).days.ago, rand(7..30).days.ago, rand(1..6).days.ago]
  date_counter = 0

  x.times do
    doc_calc = [DOC_TYPES.sample, 'Exam']
    doc_type = doc_calc[rand(0..1)]
    document = Document.new(topic: topic,
                            user: user_array.sample,
                            doc_title: "#{doc_type.capitalize} for #{topic.title} in #{hospitals.sample}",
                            doc_type: doc_type,
                            exam_type: doc_type == "Exam" ? EXAM_TYPES.sample : "",
                            tags: ["Important", "Follow-up", "Contact Doctor", "Tomorrow", "To Delete"].sample(rand(1..3)).join(" "),
                            file_type: file_types.sample,
                            status: ['active', 'inactive'].sample,
                            file: "https://photos.state.gov/libraries/portugal/231771/PDFs/C2S-LeWagon-Workshop-Program.pdf",
                            read_at: Date.new,
                            read_by: topic.patient.id)
    document.created_at = random_dates[date_counter]
    document.save!
    date_counter += 1
  end

  y = rand(1..3)
  random_dates = [rand(90..120).days.ago, rand(60..90).days.ago, rand(30..60).days.ago, rand(7..30).days.ago, rand(1..6).days.ago]
  date_counter = 0

  y.times do
    sch_type = SCHEDULE_TYPES.sample
    rand_date_start = Faker::Date.between(2.year.ago, 2.year.from_now)
    schedule = Schedule.new(topic: topic,
                            user: user_array.sample,
                            sc_title: "#{sch_type.capitalize} for #{topic.title}",
                            sc_type: sch_type,
                            schedule: ["#{rand(1..5)} times a day", "Every #{rand(2..5)} days", "Everyday", "Every week", "Every #{rand(6..12)} hours"].sample,
                            dosage: "#{rand(20..120).round(-1)} ml",
                            notes: Faker::Quote.famous_last_words,
                            date_start: rand_date_start,
                            date_end: [rand_date_start + rand(30..360), Date.new(9999, 12, 31)].sample,
                            status: ['active', 'inactive'].sample,
                            read_at: Date.new,
                            read_by: topic.patient.id)
    schedule.created_at = random_dates[date_counter]
    schedule.save!
    date_counter += 1
  end
end

# Creating "real-life" seeds

# puts "Creating real-life seeds..."

# # Famiy

# anderson = Family.create(name: "Anderson", status: 'active')

# # Mary

# pharma = pharmas.sample
# pharma_mail = "#{pharma.downcase.tr(" ", ".")}@lewagon.org"

# mary = User.new(email: "mary.smith@lewagon.org",
#                     password: '654321',
#                     first_name: "Mary",
#                     last_name: "Anderson",
#                     gender: "female",
#                     address: "lisbon",
#                     date_birth: Date.new(1980,4,24),
#                     identity_card: Faker::Number.number(10),
#                     user_type: 'patient',
#                     pat_blood: BLOOD_TYPES.sample,
#                     pat_pharma: pharma,
#                     pat_pharma_email: pharma_mail,
#                     status: 'active')

# mary.photo = "seed_pics/mary.jpeg"
# mary.save!

# FamilyPatient.create(family: anderson, patient: mary, status: 'active')

# # Erica

# pharma = pharmas.sample
# pharma_mail = "#{pharma.downcase.tr(" ", ".")}@lewagon.org"

# erica = User.new(email: "erica.anderson@lewagon.org",
#                     password: '654321',
#                     first_name: "Erica",
#                     last_name: "Anderson",
#                     gender: "female",
#                     address: "lisbon",
#                     date_birth: Date.new(1930,7,21),
#                     identity_card: Faker::Number.number(10),
#                     user_type: 'patient',
#                     pat_blood: BLOOD_TYPES.sample,
#                     pat_pharma: pharma,
#                     pat_pharma_email: pharma_mail,
#                     status: 'active')

# erica.photo = "seed_pics/erica.png"
# erica.save!

# FamilyPatient.create(family: anderson, patient: erica, status: 'active')

# # Ben

# pharma = pharmas.sample
# pharma_mail = "#{pharma.downcase.tr(" ", ".")}@lewagon.org"

# john = User.new(email: "john.anderson@lewagon.org",
#                 password: '654321',
#                 first_name: "John",
#                 last_name: "Anderson",
#                 gender: "male",
#                 address: "lisbon",
#                 date_birth: Date.new(1972,2,7),
#                 identity_card: Faker::Number.number(10),
#                 user_type: 'patient',
#                 pat_blood: BLOOD_TYPES.sample,
#                 pat_pharma: pharma,
#                 pat_pharma_email: pharma_mail,
#                 status: 'active')

# john.photo = "seed_pics/john.png"
# john.save!

# FamilyPatient.create(family: anderson, patient: ben, status: 'active')

# # kevin

# pharma = pharmas.sample
# pharma_mail = "#{pharma.downcase.tr(" ", ".")}@lewagon.org"

# christian = User.new(email: "christian.anderson@lewagon.org",
#                 password: '654321',
#                 first_name: "Christian",
#                 last_name: "Anderson",
#                 gender: "male",
#                 address: "lisbon",
#                 date_birth: Date.new(2012,1,9),
#                 identity_card: Faker::Number.number(10),
#                 user_type: 'patient',
#                 pat_blood: BLOOD_TYPES.sample,
#                 pat_pharma: pharma,
#                 pat_pharma_email: pharma_mail,
#                 status: 'active')

# christian.photo = "seed_pics/christian.png"
# christian.save!

# FamilyPatient.create(family: anderson, patient: kevin, status: 'active')

# # sarah

# pharma = pharmas.sample
# pharma_mail = "#{pharma.downcase.tr(" ", ".")}@lewagon.org"

# sarah = User.new(email: "sarah.anderson@lewagon.org",
#                 password: '654321',
#                 first_name: "Sarah",
#                 last_name: "Anderson",
#                 gender: "male",
#                 address: "lisbon",
#                 date_birth: Date.new(2015,8,21),
#                 identity_card: Faker::Number.number(10),
#                 user_type: 'patient',
#                 pat_blood: BLOOD_TYPES.sample,
#                 pat_pharma: pharma,
#                 pat_pharma_email: pharma_mail,
#                 status: 'active')

# sarah.photo = "seed_pics/sarah.png"
# sarah.save!

# FamilyPatient.create(family: anderson, patient: sarah, status: 'active')

# # chirstian

# pharma = pharmas.sample
# pharma_mail = "#{pharma.downcase.tr(" ", ".")}@lewagon.org"

# ben = User.new(email: "ben.anderson@lewagon.org",
#                 password: '654321',
#                 first_name: "Ben",
#                 last_name: "Anderson",
#                 gender: "male",
#                 address: "lisbon",
#                 date_birth: Date.new(2017,1,17),
#                 identity_card: Faker::Number.number(10),
#                 user_type: 'patient',
#                 pat_blood: BLOOD_TYPES.sample,
#                 pat_pharma: pharma,
#                 pat_pharma_email: pharma_mail,
#                 status: 'active')

# ben.photo = "seed_pics/ben.jpeg"
# ben.save!

# FamilyPatient.create(family: anderson, patient: ben, status: 'active')

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




