module ActiveAdminCsvController

    def download_csv(models)
      file = CSV.generate do |csv|
        generate_csv(csv, models)
      end

      send_data file, :type => 'text/csv; charset=UTF-8; header=present', :disposition => "attachment;filename=#{resource_class.to_s.pluralize}.csv"

    end


end