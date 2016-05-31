var params = {
    TableName: 'p_patient_development',
    Item: {

      "study_id": "APEC1621",
    	"patient_id": "2222",
    	"registration_date": "2016-05-09T22:06:33+00:00",
    	"current_status": "REGISTRATION",
      "gender": "MALE",
      "ethnicity": "WHITE",
      "races": ["WHITE", "HAWAIIAN"],
      "current_step_number": "1.0",
      "current_assignment": {"assignment_id":"1234", "assignment_status": "some_status"},
      "disease": {"name":"Carcinoma","description":"Cancer disease description"},
      "prior_drugs": ["Aspirin", "Motrin", "Vitamin C"]
    },
};
docClient.put(params, function(err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});


var params = {
    TableName: 'p_patient_development',
    Item: {

      "study_id": "APEC1621",
    	"patient_id": "3333",
    	"registration_date": "2016-06-09T22:06:33+00:00",
    	"current_status": "REGISTRATION",
      "gender": "FEMALE",
      "ethnicity": "ASIAN",
      "races": ["HAWAIIAN"],
      "current_step_number": "1.0",
      "current_assignment": {"assignment_id":"1234", "assignment_status": "some_status"},
      "disease": {"name":"Carcinoma","description":"Cancer disease description"},
      "prior_drugs": ["Aspirin", "Motrin", "Vitamin C"]
    },
};
docClient.put(params, function(err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});


var params = {
    TableName: 'p_patient_development',
    Item: {

      "study_id": "APEC1621",
    	"patient_id": "4444",
    	"registration_date": "2016-05-09T22:06:33+00:00",
    	"current_status": "ON_TREATMENT_ARM",
      "gender": "MALE",
      "ethnicity": "AFRICAN-AMERICAN",
      "races": ["HAWAIIAN", "JAPANESE"],
      "current_step_number": "1.1",
      "current_assignment": {"assignment_id":"1234", "assignment_status": "some_status"},
      "disease": {"name":"Carcinoma","description":"Cancer disease description"},
      "prior_drugs": ["Aspirin", "Motrin", "Vitamin C"]
    },
};
docClient.put(params, function(err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});
