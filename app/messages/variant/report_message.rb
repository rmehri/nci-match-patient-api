# module Variant
#   class ReportMessage < AbstractMessage
#     include MessageValidator::VariantReportValidator
#
#     @message_format =/:analysis_id/
#
#     attr_accessor :ion_reporter_id,
#                   :patient_id,
#                   :molecular_id,
#                   :analysis_id,
#                   :tsv_file_name
#   end
# end