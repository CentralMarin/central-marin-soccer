require 'pdf_forms'
require 'google/api_client'
require 'google_drive'
require 'yaml'
require 'fileutils'

TRYOUT_YEAR = 2016
ENVIRONMENT = 'production'
PDFTK_PATH = '/usr/local/bin/pdftk'

def generate_club_form(player_info)

  # Determine the folder to store generated PDF
  output_path = File.join(player_info[:Gender], player_info[:BirthYear])
  output_file = File.join(output_path, "#{player_info[:PlayerName]} #{player_info[:PlayerBirthday].gsub('/', '-')}.pdf")

  # make sure the path exists
  FileUtils.mkdir_p output_path

  # Fill in PDF Form
  pdftk = PdfForms.new(PDFTK_PATH)
  pdftk.fill_form 'us_club_form.pdf', output_file, player_info
end

def get_cell(worksheet, row, col)
  worksheet[row, col]
end

def get_phonenumber(worksheet, row, index)
  cell_value = get_cell(worksheet, row, index)
  if  cell_value.empty?
    ""
  else
    number = cell_value.to_f.to_i.to_s

    "(#{number[0..2]}) #{number[3..5]} - #{number[6..9]}"
  end
end


def process_player(worksheet, row)

  birthday = Date.strptime(get_cell(worksheet, row, 11), '%m/%d/%Y')
  gender = get_cell(worksheet, row, 10)

  player_info = {
      ClubName: 'Central Marin Soccer Club',
      ClubCity: 'San Rafael',
      ClubState: 'CA',
      LeagueName: 'TODO: League Name',
      PlayerName: "#{get_cell(worksheet, row, 3).strip} #{get_cell(worksheet, row, 4).strip}",
      PlayerBirthday: birthday.strftime('%m/%d/%Y'),
      BirthYear: birthday.strftime('%Y'),
      Gender: gender,
      PlayerFemale: (gender == 'Girls' ? 'Yes' : 'No'),
      PlayerMale: (gender == 'Boys' ? 'Yes' : 'No'),
      PlayerStreetAddress: get_cell(worksheet, row, 6),
      PlayerCity: get_cell(worksheet, row, 7),
      PlayerZip: get_cell(worksheet, row, 9),
      PlayerEmail: get_cell(worksheet, row, 5),
      Parent1Name: "#{get_cell(worksheet, row, 15)} #{get_cell(worksheet, row, 16)}",
      Parent1HomePhone: get_phonenumber(worksheet, row, 18),
      Parent1BusinessPhone: get_phonenumber(worksheet, row, 19),
      Parent1Email: get_cell(worksheet, row, 17),
      Parent1CellPhone: get_phonenumber(worksheet, row, 20),
      Parent2Name: "#{get_cell(worksheet, row, 21)} #{get_cell(worksheet, row, 22)}",
      Parent2HomePhone: get_phonenumber(worksheet, row, 24),
      Parent2BusinessPhone: get_phonenumber(worksheet, row, 25),
      Parent2Email: get_cell(worksheet, row, 23),
      Parent2CellPhone: get_phonenumber(worksheet, row, 26),
      EmergencyContact1Name: get_cell(worksheet, row, 27),
      EmergencyContact1Phone1: get_phonenumber(worksheet, row, 28),
      EmergencyContact1Phone2: get_phonenumber(worksheet, row, 29),
      EmergencyContact2Name: get_cell(worksheet, row, 30),
      EmergencyContact2Phone1: get_phonenumber(worksheet, row, 31),
      EmergencyContact2Phone2: get_phonenumber(worksheet, row, 32),
      PlayerAllergies: get_cell(worksheet, row, 40),
      PlayerMedicalConditions: get_cell(worksheet, row, 41),
      Physician: get_cell(worksheet, row, 33),
      PhysicianPhone1: get_phonenumber(worksheet, row, 34),
      PhysicianPhone2: get_phonenumber(worksheet, row, 35),
      InsuranceCompany: get_cell(worksheet, row, 36),
      InsuranceCompanyPhone: get_phonenumber(worksheet, row, 37),
      PolicyHolder: get_cell(worksheet, row, 38),
      PolicyNumber: get_cell(worksheet, row, 39),
  }
end




secrets = YAML::load(File.open('../config/secrets.yml'))

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
session = GoogleDrive.saved_session("config.json")

title = "#{TRYOUT_YEAR} #{secrets[ENVIRONMENT]['google_drive_tryouts_doc']}"

ss = session.spreadsheet_by_title title
if ss.nil?
  puts "Unable to locate speadsheet: #{title}"
  exit(-1)
end

ss.worksheets.each do |worksheet|
  puts "Processing #{worksheet.title}"

  # Skip the header
  (2..worksheet.num_rows).each do |row|

    player_info = process_player worksheet, row

    puts "Processing player #{player_info[:PlayerName]}"
    generate_club_form(player_info)

  end

end

puts "Done"