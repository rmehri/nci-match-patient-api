module V1
  class VariantReportDownloadsController < BaseController
    def download_excel
      @variant_report = get_variant_report
      Axlsx::Package.new do |p|
        p.workbook do |wb|
          styles = wb.styles
          header = styles.add_style :bg_color => '0000FF', :fg_color => '00F', :sz => 12, :b => true, :alignment => { :horizontal => :center }
          bold = styles.add_style b: true, border: Axlsx::STYLE_THIN_BORDER, alignment: { vertical: :distributed}
          tbl_header = styles.add_style :b => true, :alignment => { :horizontal => :center }
          ind_header = styles.add_style :bg_color => 'FFDFDEDF', :b => true, :alignment => { horizontal: :center}
          col_header = styles.add_style :bg_color => 'FFDFDEDF', :b => true, :alignment => { :horizontal => :center }
          label = styles.add_style :alignment => { :indent => 1 }
          money = styles.add_style :num_fmt => 5
          t_label = styles.add_style :b => true, :bg_color => 'FFDFDEDF'
          t_money = styles.add_style :b => true, :num_fmt => 5, :bg_color => 'FFDFDEDF'
          heading = styles.add_style :bg_color => 'D8D8D8', :b => true, :border => { :style => :thick, :color => '00' }, :alignment => { :horizontal => :center, :vertical => :center, :wrap_text => false }
          sub_heading = styles.add_style :b => true, :alignment => { :horizontal => :center, :vertical => :center, :wrap_text => false}

          wb.add_worksheet do |sheet|
            sheet.add_row
            sheet.add_row [nil, 'Variant Report'], style: [nil, heading]
            sheet.add_row
            sheet.add_row [nil, 'Patient ID', @variant_report[:patient][:patient_id] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Registration Date', @variant_report[:patient][:registration_date] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Study ID', @variant_report[:patient][:study_id] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Current Step Number', @variant_report[:patient][:current_step_number] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Current Status', @variant_report[:patient][:current_status] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Status Date', @variant_report[:patient][:status_date] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Variant Report Received Date', @variant_report[:variant_report][:variant_report_received_date] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Surgical Event ID', @variant_report[:variant_report][:surgical_event_id] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Variant Report Type', @variant_report[:variant_report][:variant_report_type] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Molecular ID', @variant_report[:variant_report][:molecular_id] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Analysis ID', @variant_report[:variant_report][:analysis_id] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Status', @variant_report[:variant_report][:status] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Cellularity', @variant_report[:variant_report][:cellularity] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'MAPD', @variant_report[:variant_report][:mapd] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Torrent Variant Caller Version', @variant_report[:variant_report][:torrent_variant_caller_version] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Total Variants', @variant_report[:variant_report][:total_variants] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Total MOIS', @variant_report[:variant_report][:total_mois] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Total AMOIS', @variant_report[:variant_report][:total_amois] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Total Confirmed MOIS', @variant_report[:variant_report][:total_confirmed_mois] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Total Confirmer AMOIS', @variant_report[:variant_report][:total_confirmed_amois] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Specimen Received Date', @variant_report[:variant_report][:specimen_received_date] || '-'], style: [nil, bold]
            sheet.add_row [nil, 'Ion Reporter ID', @variant_report[:variant_report][:ion_reporter_id] || '-'], style: [nil, bold]
            sheet.add_row
            sheet.add_row [nil, 'SNV Indel(S)'], style: [nil, sub_heading]
            sheet.add_row
            unless @variant_report[:variant_report][:snv_indels].nil?
              sheet.add_row [nil, 'Variant Type', 'Identifier', 'Func Gene', 'Chrom', 'Position', 'Reference', 'Alternative', 'Protein', 'Transcript', 'Hgvs', 'Read Depth',
                                  'Allele Freq', 'variant_class', 'LOE', 'Ref CN', 'Raw CN', 'CN', 'CI 95%', 'CI 5%', 'Oncomine Variant Class', 'Exon', 'Function'], style: [nil, bold]
              @variant_report[:variant_report][:snv_indels].each do |snv_indel|
                sheet.add_row [nil, snv_indel[:variant_type] || '-', snv_indel[:identifier] || '-', snv_indel[:func_gene] || '-', snv_indel[:chromosome] || '-', snv_indel[:position] || '-',
                                    snv_indel[:reference] || '-', snv_indel[:alternative] || '-', snv_indel[:protein] || '-', snv_indel[:transcript] || '-', snv_indel[:hgvs] || '-', snv_indel[:read_depth] || '-',
                                    snv_indel[:allele_frequency] || '-', snv_indel[:variant_class] || '-', snv_indel[:level_of_evidence] || '-', snv_indel[:ref_copy_number] || '-', snv_indel[:raw_copy_number] || '-',
                                    snv_indel[:copy_number] || '-', snv_indel[:confidence_interval_95_percent] || '-', snv_indel[:confidence_interval_5_percent] || '-',
                                    snv_indel[:oncomine_variant_class] || '-', snv_indel[:exon] || '-', snv_indel[:function] || '-'], style: [nil, bold]
              end
            end
            sheet.add_row
            sheet.add_row
            sheet.add_row [nil, 'Copy Number Variant(S)'], style: [nil, sub_heading]
            sheet.add_row
            unless @variant_report[:variant_report][:copy_number_variants].nil?
              sheet.add_row [nil, 'Variant Type', 'Identifier', 'Func Gene', 'Chrom', 'Position', 'Reference', 'Alternative', 'Protein', 'Transcript', 'Hgvs', 'Read Depth',
                                  'Allele Freq', 'variant_class', 'LOE', 'Ref CN', 'Raw CN', 'CN', 'CI 95%', 'CI 5%', 'Oncomine Variant Class', 'Exon', 'Function'], style: [nil, bold]
              @variant_report[:variant_report][:copy_number_variants].each do |cnv|
                sheet.add_row [nil, cnv[:variant_type] || '-', cnv[:identifier] || '-', cnv[:func_gene] || '-', cnv[:chromosome] || '-', cnv[:position] || '-',
                                    cnv[:reference] || '-', cnv[:alternative] || '-', cnv[:protein] || '-', cnv[:transcript] || '-', cnv[:hgvs] || '-', cnv[:read_depth] || '-',
                                    cnv[:allele_frequency] || '-', cnv[:variant_class] || '-', cnv[:level_of_evidence] || '-', cnv[:ref_copy_number] || '-', cnv[:raw_copy_number] || '-',
                                    cnv[:copy_number] || '-', cnv[:confidence_interval_95_percent] || '-', cnv[:confidence_interval_5_percent] || '-',
                                    cnv[:oncomine_variant_class] || '-', cnv[:exon] || '-', cnv[:function] || '-'], style: [nil, bold]
              end
            end
            sheet.add_row
            sheet.add_row
            sheet.add_row [nil, 'Gene Fusion(S)'], style: [nil, sub_heading]
            sheet.add_row
            unless @variant_report[:variant_report][:gene_fusions].nil?
              sheet.add_row [nil, 'Variant Type', 'Identifier', 'Func Gene', 'Chrom', 'Position', 'Reference', 'Alternative', 'Protein', 'Transcript', 'Hgvs', 'Read Depth',
                                  'Allele Freq', 'variant_class', 'LOE', 'Ref CN', 'Raw CN', 'CN', 'CI 95%', 'CI 5%', 'Oncomine Variant Class', 'Exon', 'Function'], style: [nil, bold]
              @variant_report[:variant_report][:gene_fusions].each do |gf|
                sheet.add_row [nil, gf[:variant_type] || '-', gf[:identifier] || '-', gf[:func_gene] || '-', gf[:chromosome] || '-', gf[:position] || '-',
                                    gf[:reference] || '-', gf[:alternative] || '-', gf[:protein] || '-', gf[:transcript] || '-', gf[:hgvs] || '-', gf[:read_depth] || '-',
                                    gf[:allele_frequency] || '-', gf[:variant_class] || '-', gf[:level_of_evidence] || '-', gf[:ref_copy_number] || '-', gf[:raw_copy_number] || '-',
                                    gf[:copy_number] || '-', gf[:confidence_interval_95_percent] || '-', gf[:confidence_interval_5_percent] || '-',
                                    gf[:oncomine_variant_class] || '-', gf[:exon] || '-', gf[:function] || '-'], style: [nil, bold]
              end
            end
          end
        end
        p.use_shared_strings = true
        p.serialize 'variant_report.xlsx'
        send_data p.to_stream.read, type: 'application/xlsx', filename: 'variant_report.xlsx'
      end
    end

    private

    def get_variant_report(_resource = {})
      patient = NciMatchPatientModels::Patient.query_patient_by_id(params[:patient_id])
      return standard_error_message("Patient [#{params[:patient_id]}] not found", 404) if patient.blank?

      variant_report_hash = NciMatchPatientModelExtensions::VariantReportExtension.compose_variant_report(params[:patient_id], params[:analysis_id])
      raise Errors::ResourceNotFound if variant_report_hash.blank?

      variant_report_hash[:editable] = is_variant_report_reviewer(variant_report_hash[:clia_lab]) && variant_report_hash[:status] != 'CONFIRMED'

      VariantReportHelper.add_download_links(variant_report_hash)
      assignments = NciMatchPatientModels::Assignment.query_by_patient_id(params[:patient_id], false).collect { |data| data.to_h.compact }
      assignments = assignments.sort_by{| assignment | assignment[:assignment_date]}.reverse

      assignments_with_assays = []
      assignments.each do | assignment |
        assignment[:editable] = is_assignment_reviewer && assignment[:status] != 'CONFIRMED'
        assays = find_assays(assignment[:surgical_event_id])
        assignments_with_assays.push(Convert::AssignmentDbModel.to_ui(assignment, assays)) unless assignment.blank?
      end

      analysis_report = Convert::AnalysisReportDbModel.to_ui_model(patient.to_h.compact, variant_report_hash, assignments_with_assays)
      instance_variable_set("@#{resource_name}", analysis_report)
    end

    def find_assays(surgical_event_id)
      assays = []
      specimens = NciMatchPatientModels::Specimen.find_by({ surgical_event_id: surgical_event_id }).collect { |data| data.to_h.compact }
      assays = specimens[0][:assays] if specimens.length > 0
      assays
    end

    def get_variants(analysis_id)
      NciMatchPatientModels::Variant.scan(build_query({ analysis_id: analysis_id })).collect { |data| data.to_h.compact }
    end
  end
end
