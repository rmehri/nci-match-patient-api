var params = {
    TableName: 'p_patient_events',
    Item: {
        "patient_id": "2222",
        "event_date": "2016-05-09T22:06:33+00:00",
        "event_name": "REGISTRATION",
        "event_type": "MALE",
        "ethnicity": "WHITE",
        "event_data": { "name": "Carcinoma", "description": "Cancer disease description" },
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});


var params = {
    TableName: 'p_patient_events',
    Item: {

        "study_id": "APEC1621",
        "patient_id": "3333",
        "event_date": "2016-06-09T22:06:33+00:00",
        "event_name": "REGISTRATION",
        "event_type": "FEMALE",
        "ethnicity": "ASIAN",
        "races": ["HAWAIIAN"],
        "current_step_number": "1.0",
        "current_assignment": { "assignment_id": "1234", "assignment_status": "some_status" },
        "disease": { "name": "Carcinoma", "description": "Cancer disease description" },
        "prior_drugs": ["Aspirin", "Motrin", "Vitamin C"]
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});


var params = {
    TableName: 'p_patient_events',
    Item: {

        "study_id": "APEC1621",
        "patient_id": "4444",
        "event_date": "2016-05-09T22:06:33+00:00",
        "event_name": "ON_TREATMENT_ARM",
        "event_type": "MALE",
        "ethnicity": "AFRICAN-AMERICAN",
        "races": ["HAWAIIAN", "JAPANESE"],
        "current_step_number": "1.1",
        "current_assignment": { "assignment_id": "1234", "assignment_status": "some_status" },
        "disease": { "name": "Carcinoma", "description": "Cancer disease description" },
        "prior_drugs": ["Aspirin", "Motrin", "Vitamin C"]
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});
