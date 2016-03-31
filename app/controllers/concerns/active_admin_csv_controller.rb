module ActiveAdminCsvController

  CSV_ENCODING = 'UTF-8'

  def download_csv(models)

    file = CSV.generate do |csv|
      generate_csv(csv, models)
    end

    send_data file, :type => "text/csv; charset=#{CSV_ENCODING}; header=present", :disposition => "attachment;filename=#{resource_class.to_s.pluralize}.csv"

  end


end