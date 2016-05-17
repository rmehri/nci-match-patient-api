json.array!(@patients) do |patient|
  json.extract! patient, :id, :psn, :race, :gender, :step
  json.url patient_url(patient, format: :json)
end
