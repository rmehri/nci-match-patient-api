# describe Convert do
#
#   def patient_db_model(assignemnt_report = nil)
#     model = NciMatchPatientModels::Patient.new
#
#     model.patient_id           = 'PAT123'
#     model.registration_date    = '2016-05-09T22:06:33+00:00'
#     model.study_id             = 'APEC1621'
#     model.gender               = 'MALE'
#     model.ethnicity            = 'WHITE'
#     model.races                = ["WHITE", "HAWAIIAN"]
#     model.current_step_number  = "1.0"
#     model.current_assignment   = assignemnt_report
#     model.current_status       = "REGISTRATION"
#     model.diseases              = [{
#         "name"              => "Invasive Breast Carcinoma",
#         "ctep_category"     => "Breast Neoplasm",
#         "ctep_sub_category" => "Breast Cancer - Invasive",
#         "ctep_term"         => "Invasive Breast Carcinoma",
#         "med_dra_code"      => "1000961"
#     }]
#
#     model.prior_drugs          = ["Aspirin", "Motrin", "Vitamin C"]
#
#     model.documents            = {"list" => [
#         {
#             "name" => "Document 1",
#             "uploadedDate" => "2016-05-09T22:06:33+00:00",
#             "user" => "James Bond"
#         },
#         {
#             "name" => "Document 2",
#             "uploadedDate" => "2016-05-09T22:06:33+00:00",
#             "user" => "James Bond"
#         },
#         {
#             "name" => "X-File A23FSD34",
#             "uploadedDate" => "2016-05-09T22:06:33+00:00",
#             "user" => "Fox Mulder"
#         }
#     ]}
#
#     model.message = "Some message"
#
#     model
#   end
#
#   let(:events_db_model_list) do
#     [1,2].map { |i|
#       NciMatchPatientModels::Event.new(
#           :entity_id     => 'PAT123',
#           :event_date     => '2016-05-09T22:06:33+00:00',
#           :event_name     => 'Event Name ' + i.to_s,
#           :event_type     => 'TYPE' + i.to_s,
#           :event_message  => 'Message ' + i.to_s,
#           :event_data     => { "status" => "Pending", "biopsy_sequence_number" => "B-987456" }
#       )
#     }
#   end
#
#   let(:variant_report_db_model_list) do
#     [1,2].map { |i|
#       NciMatchPatientModels::VariantReport.new(
#           :surgical_event_id                  => 'SUREVT098' + i.to_s,
#           :variant_report_received_date   => '2016-05-09T22:06:33+00:00',
#           :variant_report_type => 'TISSUE',
#           :patient_id             => 'PAT123' + i.to_s,
#           :molecular_id           => 'MOL123' + i.to_s,
#           :analysis_id            => 'SAM123' + i.to_s,
#           :status                 => 'PENDING',
#           :status_date       => '2016-05-09T22:06:33+00:00',
#           :dna_bam_name => "http:\\\\blah.com\\dna_bam.data",
#           :dna_bai_name => "http:\\\\blah.com\\dna_bai.data",
#           :cdna_bam_name => "http:\\\\blah.com\\rna_bam.data",
#           :cdna_bai_name => "http:\\\\blah.com\\rna_bai.data",
#           :vcf_file_name          => "http:\\\\blah.com\\vcf.data",
#           :total_variants         => "8",
#           :cellularity            => "7",
#           :total_mois             => "4",
#           :total_amois            => "2",
#           :total_confirmed_mois   => "3",
#           :total_confirmed_amois  => "1"
#       )
#     }
#   end
#
#   let(:variant_db_model_list) do
#     [1,2].map { |i|
#       NciMatchPatientModels::Variant.new(
#         :uuid => "MSNANL123AN123",
#         :variant_type => "single_nucleitide_variants",
#         :patient_id => "PAT123",
#         :surgical_event_id => "SUREVT098" + i.to_s,
#         :molecular_id => "MOL098" + i.to_s,
#         :analysis_id => "ANZ9876" + i.to_s,
#         :identifier => "VAR9876" + i.to_s,
#         :confirmed => true,
#         :status_date => "2016-06-09T22:06:33+00:00",
#         :comment => "Don't need this",
#         :func_gene => "gene",
#         :chromosome => "chr3",
#         :position => "12345",
#         :oncomine_variant_class => "Hotspot",
#         :exon => "10",
#         :function => "missense",
#         :reference => "A",
#         :alternative => "C",
#         :filter => "flt",
#         :protein => "p.Glu6565Ala",
#         :transcript => "NM_0456345",
#         :hgvs => "c.234534>C",
#         :read_depth => "648",
#         :rare => "?",
#         :allele_frequency => "0.0344",
#         :flow_alternative_allele_observation_count => "alt obs",
#         :flow_reference_allele_observations => "alt allele",
#         :reference_allele_observations => "ref allele"
#       )
#     }
#   end
#
#   let(:assignment_report) do
#     {
#         "generated_date" => "2016-05-09T22:06:33+00 =>00",
#         "confirmed_date" => "2016-05-09T22:06:33+00 =>00",
#         "sent_to_cog_date" => "-",
#         "received_from_cog_date" => "-",
#         "biopsy_sequence_number" => "T-15-000078",
#         "molecular_sequence_number" => "MSN34534",
#         "analysis_id" => "MSN34534_v2_kjdf3-kejrt-3425-mnb34ert34f",
#
#         "variant_report_amois" => [
#             { "title" => "[COSM12344]", "url" => "" },
#             { "title" => "p.S310Y", "url" => "" },
#             { "title" => "CISM23423", "url" => "" }
#         ],
#
#         "assays" => [
#             { "gene" => "MSH2", "result" => "Not Applicable", "comment" => "Biopsy received prior to bimarker launch date" },
#             { "gene" => "PTENs", "result" => "POSITIVE", "comment" => "-" },
#             { "gene" => "MLH1", "result" => "Not Applicable", "comment" => "Biopsy received prior to bimarker launch date" },
#             { "gene" => "RB", "result" => "Not Applicable", "comment" => "Biopsy received prior to bimarker launch date" }
#         ],
#
#         "treatment_arms" => {
#             "no_match" => [
#                 { "treatment_arm" => "EAY131-U", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-F", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-F", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-F", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-G", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-H", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-R", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-E", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-A", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." },
#                 { "treatment_arm" => "EAY131-V", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient contains no matching variant." }
#             ],
#             "record_based_exclusion" => [
#                 { "treatment_arm" => "EAY131-Q", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient excluded from this arm because of invasive breast carcinoma." }
#             ],
#             "selected" => [
#                 { "treatment_arm" => "EAY131-B", "treatment_arm_version" => "2015-08-06", "treatment_arm_title" => "EAY131-U (2015-08-06)", "reason" => "The patient and treatment match on variant identifier [ABSF, DEDF]." }
#             ]
#         }
#     }
#   end
#
#   let(:specimen_db_model_list) do
#     [1,2].map { |i|
#        NciMatchPatientModels::Specimen.new(
#         :patient_id  => "PAT123",
#         :collected_date  => "2016-06-09T22:06:33+00:00",
#         :surgical_event_id => "SUREVT098" + i.to_s,
#         :failed_date => "2016-06-09T22:06:33+00:00",
#         :study_id => "APEC1621",
#         :type => "TUMOR",
#         :pathology_status => "Agreed on pathology",
#         :pathology_status_date => "2016-06-09T22:06:33+00:00",
#         :variant_report_confirmed_date => "2016-06-09T22:06:33+00:00",
#         :assays => [
#             { :gene => 'PTEN',  :ordered_date => '2016-06-09T22:06:33+00:00', :result_date => '2016-07-09T22:06:33+00:00T', :result => 'POSITIVE' },
#             { :gene => 'MLH1',  :ordered_date => '2016-06-09T22:06:33+00:00', :result_date => '2016-07-09T22:06:33+00:00T', :result => 'POSITIVE' },
#             { :gene => 'MSCH2', :ordered_date => '2016-06-09T22:06:33+00:00', :result_date => '2016-07-09T22:06:33+00:00T', :result => 'POSITIVE' },
#             { :gene => 'RB',    :ordered_date => '2016-06-09T22:06:33+00:00', :result_date => '2016-07-09T22:06:33+00:00T', :result => 'NEGATIVE' }
#
#         ]
#       )
#     }
#   end
#
#   it "works with patient DB models" do
#     dbm = patient_db_model
#
#     uim = Convert::PatientDbModel.to_ui_model dbm, nil, nil, nil, nil
#
#     expect(uim.patient_id).to eq "PAT123"
#     expect(uim.gender).to eq "MALE"
#     expect(uim.current_status).to eq "REGISTRATION"
#
#     expect(uim.disease).to be_kind_of Array
#     expect(uim.disease[0]["name"]).to eq "Invasive Breast Carcinoma"
#
#     expect(uim.races).to be_kind_of Array
#     expect(uim.races.size).to eq 2
#
#     expect(uim.prior_drugs).to be_kind_of Array
#     expect(uim.prior_drugs[0]).to eq "Aspirin"
#
#     expect(uim.documents).to be_kind_of Hash
#     expect(uim.documents["list"]).to be_kind_of Array
#     expect(uim.documents["list"][0]["name"]).to eq "Document 1"
#
#   end
#
#   it "works with variant report DB model" do
#     patient_dbm = patient_db_model
#     variant_reports_dbm = variant_report_db_model_list
#     variants_dbm = variant_db_model_list
#
#     uim = Convert::PatientDbModel.to_ui_model patient_dbm, variant_reports_dbm, variants_dbm, nil, nil
#
#     expect(uim).to_not eq nil
#
#     expect(uim.variant_reports).to_not eq nil
#
#     expect(uim.variant_reports[1]["surgical_event_id"]).to eq "SUREVT0982"
#     expect(uim.variant_reports[1]["patient_id"]).to eq "PAT1232"
#     expect(uim.variant_reports[1]["molecular_id"]).to eq "MOL1232"
#     expect(uim.variant_reports[1]["analysis_id"]).to eq "SAM1232"
#
#     expect(uim.variant_reports[1]["variants"]).to_not eq nil
#
#     expect(uim.variant_reports[1]["variants"]["snvs_and_indels"]).to_not eq nil
#     expect(uim.variant_reports[1]["variants"]["copy_number_variants"]).to_not eq nil
#     expect(uim.variant_reports[1]["variants"]["gene_fusions"]).to_not eq nil
#
#     expect(uim.variant_reports[1]["variants"]["snvs_and_indels"]).to be_kind_of Array
#
#   end
#
#   it "works with assignment report" do
#     dbm = patient_db_model(assignment_report)
#
#     uim = Convert::PatientDbModel.to_ui_model dbm, nil, nil, nil, nil
#
#     expect(uim).to_not eq nil
#
#     expect(uim.assignment_report).to_not eq nil
#     expect(uim.assignment_report["generated_date"]).to eq "2016-05-09T22:06:33+00 =>00"
#     expect(uim.assignment_report["variant_report_amois"].size).to eq 3
#     expect(uim.assignment_report["assays"].size).to eq 4
#     expect(uim.assignment_report["assays"][0]["gene"]).to eq "MSH2"
#     expect(uim.assignment_report["treatment_arms"]).to_not eq nil
#     expect(uim.assignment_report["treatment_arms"]["no_match"].size).to be > 0
#     expect(uim.assignment_report["treatment_arms"]["no_match"][0]["treatment_arm"]).to eq "EAY131-U"
#
#
#   end
#
#   it "works with specimen DB model" do
#     patient_dbm = patient_db_model
#     specimens_dbm = specimen_db_model_list
#
#     uim = Convert::PatientDbModel.to_ui_model patient_dbm, nil, nil, specimens_dbm, []
#
#     expect(uim).to_not eq nil
#
#     expect(uim.specimens).to_not eq nil
#     expect(uim.specimens.size).to eq specimens_dbm.size
#
#   end
#
#   it "works with entire DB model" do
#     patient_dbm = patient_db_model(assignment_report)
#     # events_dbm = events_db_model_list
#     variant_reports_dbm = variant_report_db_model_list
#     variants_dbm = variant_db_model_list
#     specimens_dbm = specimen_db_model_list
#
#     uim = Convert::PatientDbModel.to_ui_model patient_dbm, variant_reports_dbm, variants_dbm, specimens_dbm, []
#
#     expect(uim).to_not eq nil
#     expect(uim.assignment_report).to_not eq nil
#     expect(uim.variant_reports).to_not eq nil
#     expect(uim.specimens).to_not eq nil
#
#   end
#
# end
