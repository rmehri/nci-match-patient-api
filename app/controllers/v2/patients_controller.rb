module V2
  class PatientsController < V2::BaseController

    private
    def patient_params
      params.require(:patient_id).permit(:registration_date)
    end

    def query_params
      parameters = params.permit(:patient_id, :registration_date, :study_id, :gender, :ethnicity, :current_step_number, :current_status, :treating_site_id, :message)
      {table_name: @resource_name, :scan_filter => build_scan_filter(parameters)}
    end

    def build_scan_filter(params)
      query = {}
      params.each do |key , value|
        query.merge!(key => {:comparison_operator => "EQ", :attribute_value_list => [value]})
      end
      if(params.length >= 2)
        query.merge!(:conditional_operator => "AND")
      end
      query
    end
  end
end