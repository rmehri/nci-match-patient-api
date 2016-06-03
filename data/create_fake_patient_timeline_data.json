var params = {
    TableName: 'p_patient_event_development',
    Item: {
        "patient_id": "2222",
        "event_date": "2016-06-12T22:06:33+00:00",
        "event_name": "assignment",
        "event_type": "assignment",
        "event_data": { 
            "status": "Pending",
            "biopsySequenceNumber": "B-987456",
            "molecularSequenceNumber": "MSN-1245",
            "analysisId": "A-T-5678"
        },
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});


var params = {
    TableName: 'p_patient_event_development',
    Item: {
        "patient_id": "2222",
        "event_date": "2016-06-09T22:04:45+00:00",
        "event_name": "biopsy.pathology",
        "event_type": "biopsy.pathology",
        "event_data": { 
            "status": "Confirmed",
            "comment": "Agreement on pathology"
        },
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});


var params = {
    TableName: 'p_patient_event_development',
    Item: {
        "patient_id": "2222",
        "event_date": "2016-06-04T22:09:45+00:00",
        "event_name": "biopsy.variantReport",
        "event_type": "biopsy.variantReport",
        "event_data": { 
            "status": "Pending",
            "molecularSequenceNumber": "MSN-1245",
            "analysisId": "A-T-5678",
            "location": "MGH",
            "totalMoiCount": "1",
            "totalAmoiCount": "0"
        },
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});


var params = {
    TableName: 'p_patient_event_development',
    Item: {
        "patient_id": "2222",
        "event_date": "2016-06-02T22:01:45+00:00",
        "event_name": "biopsy.assay",
        "event_type": "biopsy.assay",
        "event_data": { 
            "gene": "MLH1",
            "status": "Ordered",
            "biopsySequenceNumber": "B-987456",
            "trackingNumber": "ZT2329875234985"
        },
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});


var params = {
    TableName: 'p_patient_event_development',
    Item: {
        "patient_id": "2222",
        "event_date": "2016-05-15T22:03:45+00:00",
        "event_name": "patient",
        "event_type": "patient",
        "event_data": { 
            "status": "Registration",
            "location": "MGH",
            "step": "2.0"
        },
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});

var params = {
    TableName: 'p_patient_event_development',
    Item: {
        "patient_id": "2222",
        "event_date": "2016-05-12T22:07:45+00:00",
        "event_name": "user",
        "event_type": "user",
        "event_data": { 
            "status": "upload.patientdocument",
            "user": "Rick",
            "details": "File \"Biopsy Result\" uploaded",
            "fileUrl": "http://blah.com/biopsy_result_1234.dat"
        },
    },
};
docClient.put(params, function (err, data) {
    if (err) ppJson(err); // an error occurred
    else ppJson(data); // successful response
});
