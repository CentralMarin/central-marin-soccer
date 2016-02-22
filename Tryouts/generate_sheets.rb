require "google/api_client"
require "google_drive"
require "yaml"
require 'axlsx'

BLANK_ROWS = 10
TRYOUT_YEAR = 2016
FONT_SIZE = 13

# TOTAL Page Width = 92
COLUMNS = [
    {index: 0, width: 4}, # Bib #
    {index: 2, width: 15}, # First Name
    {index: 3, width: 15}, # Last Name
    {index: 10, right_align: true, width: 9}, # Birthdate
    {index: 16, right_align: true, width: 25}, # Parent 1 Email
    {index: 17, phone: true, right_align: true, width: 12}, # Parent 1 Home Phone
    {index: 19, phone: true, right_align: true, width: 12}, # Parent 1 Cell Phone
]

ENVIRONMENT = 'production'
TRYOUT_FILE = "tryout.xlsx"

DEFAULT_STYLE = {
    border: Axlsx::STYLE_THIN_BORDER
}

def copy_worksheet(workbook, google_sheet)

  # Skip non player registration shees
  return unless google_sheet.title.downcase.start_with?('boys') || google_sheet.title.downcase.start_with?('girls')

  puts "Processing #{google_sheet.title}"

  # Set margins, header, and page
  margins = {left: 0.05, right: 0.05, bottom: 0.25, footer: 0.25, top: 0.5, header: 0.25}
  setup = {orientation: :landscape }
  header_footer = {different_first: false, odd_header: "&C&H &18 &B&A: Sheet &P of &N"}

  puts "  Adding and formattting worksheet for excel"
  workbook.add_worksheet(name: google_sheet.title, page_margins: margins, header_footer: header_footer, page_setup: setup) do |sheet|

    # Create new style for our header row
    header_row = sheet.styles.add_style DEFAULT_STYLE.merge({b: true, alignment: {horizontal: :center}})
    cell = sheet.styles.add_style DEFAULT_STYLE.merge({alignment: {horizontal: :left}})

    cell_right_align = sheet.styles.add_style DEFAULT_STYLE.merge({alignment: {horizontal: :right}})
    phone_right_align = sheet.styles.add_style DEFAULT_STYLE.merge({alignment: {horizontal: :right}, format_code: "(###) ###-####"})
    sheet.styles.fonts.first.sz = FONT_SIZE

    # Sort google spreadsheet
    rows = google_sheet.rows
    sorted_rows = rows[1..-1].sort! do |row1, row2|
      result = row1[COLUMNS[1][:index]].downcase <=> row2[COLUMNS[1][:index]].downcase
      result = row1[COLUMNS[2][:index]].downcase <=> row2[COLUMNS[2][:index]].downcase if result == 0

      puts "Possible duplicate #{row1[COLUMNS[1][:index]]} #{row1[COLUMNS[2][:index]]}" if result == 0

      result
    end
    rows = sorted_rows.insert(0, rows[0])

    # Copy google rows to local spreadsheet
    rows.each_with_index { |row, index| copy_row_to_worksheet(sheet, row, index == 0, index == 0 ? header_row : cell) }

    # Add 10 blank rows for walk ups
    (1..BLANK_ROWS).each { |index| sheet.add_row [" "] * COLUMNS.length, style: Axlsx::STYLE_THIN_BORDER }

    # Right align specified columns
    COLUMNS.each_with_index do |column, index|
      sheet.col_style index, cell_right_align, row_offset: 1 if column[:right_align]
      sheet.col_style index, phone_right_align, row_offset: 1 if column[:phone]
    end

    # Set column widths to fit the text
    widths = COLUMNS.collect {|meta_data| meta_data[:width]}
    sheet.column_widths *widths

  end
end

def copy_row_to_worksheet(sheet, row, header, style)

  sheet.add_row COLUMNS.collect { |meta_data| row[meta_data[:index]]}, :style => style, widths: [:ignore]

end

secrets = YAML::load(File.open('../config/secrets.yml'))
title = "#{TRYOUT_YEAR} #{secrets[ENVIRONMENT]['google_drive_tryouts_doc']}"

puts "Creating Excel Workbook"
# Create the new Excel Workbook
p = Axlsx::Package.new
p.use_autowidth = true
wb = p.workbook

puts "Establishing google drive session and finding spreadsheet"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
session = GoogleDrive.saved_session("config.json")
ws = session.spreadsheet_by_title(title)

puts "Iterating over worksheets"
# find the worksheet(s) we're interested in
ws.worksheets.each do |sheet|
  copy_worksheet(wb, sheet)
end

p.serialize TRYOUT_FILE
