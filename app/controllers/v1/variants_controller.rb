module V1
  class VariantsController < BaseController


    private
    def variants_params
      build_query({:analysis_id => params.require(:id)})
    end

    def query_params
      
      parameters = params.permit(:uuid, :variant_type, :type, :patient_id, :surgical_event_id, :molecular_id, :analysis_id, :confirmed,:status_date,
                                 :comment, :comment_user, :is_amoi, :amois, :identifier, :func_gene, :chromosome, :position, :reference, :alternative, :filter,
                                 :description, :protein, :transcript, :hgvs, :location, :read_depth, :rare, :allele_frequency,
                                 :flow_alternative_allele_observation_count, :flow_reference_allele_observations,
                                 :reference_allele_observations, :alternative_allele_observation_count,
                                 :variant_class, :public_med_ids, :level_of_evidence, :ref_copy_number, :raw_copy_number, :copy_number,
                                 :confidence_interval_95_percent, :confidence_interval_5_percent, :oncomine_variant_class, :exon, :function,
                                 :driver_read_count, :partner_read_count, :driver_gene, :partner_gene, :annotation, :cds_reference, :cds_alternative,
                                 :ocp_reference ,:ocp_alternative, :strand,
                                 :attributes, :projections, :projection => [], :attribute => [])
      build_query(parameters)
    end

  end
end