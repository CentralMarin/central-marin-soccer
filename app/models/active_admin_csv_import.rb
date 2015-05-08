module ActiveAdminCsvImport

  def import_csv_file(csv_data)
    transaction do
      # remove all the existing records
      destroy_all

      # read the csv
      csv_file = csv_data.read
      CSV.parse(csv_file, {:headers => true}) do |row|
        yield new(), row
      end

    end
  end

end