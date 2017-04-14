class EventMessage < AbstractMessage
  include MessageValidator::EventValidator

  attr_accessor :patient_id, :molecular_id, :analysis_id, :surgical_event_id, :dna_bam_name, :cdna_bam_name, :zip_name


end