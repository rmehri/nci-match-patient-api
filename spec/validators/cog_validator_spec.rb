require 'rails_helper'
require 'spec_helper'

RSpec.describe CogMessage do

  context 'not a message type' do
    it {expect(MessageFactory.get_message_type({:status => "REGISTRATION"})).to be_truthy}
  end

  context 'for REGISTRATION ' do
    let(:good_registration_message) { {
        "header": {
            "msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
            "msg_dttm": "2016-05-09T22:06:33+00:00"
        },
        "study_id": "APEC1621SC",
        "patient_id": "3366",
        "step_number": "1.0",
        "status_date": "2016-05-09T22:06:33+00:00",
        "status": "REGISTRATION",
        "internal_use_only": {
            "request_id": "4-654321",
            "environment": "4",
            "request": "REGISTRATION for patient_id 2222"
        }
      }
    }

    let(:bad_registration_message) { {
        "header": {
            "msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
            "msg_dttm": "2016-05-09T22:06:33+00:00"
        },
        "study_id": "APEC1621SC",
        "step_number": "1.0",
        "status_date": "2016-05-09T22:06:33+00:00",
        "status": "REGISTRATION",
        "internal_use_only": {
            "request_id": "4-654321",
            "environment": "4",
            "request": "REGISTRATION for patient_id 2222"
        }
      }
    }

    let(:reg_good_test_suit) { MessageFactory.get_message_type(good_registration_message) }
    it{expect(reg_good_test_suit.class).to eq(CogMessage)}
    it{expect(reg_good_test_suit.valid?).to be_truthy}

    let(:reg_bad_test_suit) { MessageFactory.get_message_type(bad_registration_message) }
    it 'has valid values' do
      expect(reg_bad_test_suit.valid?).to be_falsey
      expect(reg_bad_test_suit.errors.messages).not_to be_empty
      expect(reg_bad_test_suit.errors.messages.to_s).to include("can't be blank")
    end
  end



  context 'for ON_TREATMENT_ARM ' do
    let(:good_message) {
      {:header => [
        {
            'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
            'msg_dttm' => '2016-05-09T22:06:33+00:00'
        }],
       :treatment_arm_id => '12345',
       :stratum_id  => '123456',
       :study_id => 'APEC1621SC',
       :patient_id => '2222',
       :step_number => '1.0',
       :status_date => '2016-05-09T22:06:33+00:00',
       :status => 'ON_TREATMENT_ARM',
       :internal_use_only => [
           {
               "request_id"=> "4-654321",
               "environment"=> "4",
               "request"=> "ON_TREATMENT_ARM for patient_id 2222"
           }
       ]
      }
    }
    let(:bad_message) {
      {:header => [
          {
              'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
              'msg_dttm' => '2016-05-09T22:06:33+00:00'
          }],
       :treatment_arm_id => '12345',
       :study_id => 'APEC1621SC',
       :step_number => '1.0',
       :status_date => '2016-05-09T22:06:33+00:00',
       :status => 'ON_TREATMENT_ARM',
       :internal_use_only => [
           {
               "request_id"=> "4-654321",
               "environment"=> "4",
               "request"=> "ON_TREATMENT_ARM for patient_id 2222"
           }
       ]
      }
    }
    let(:good_test_suit) { MessageFactory.get_message_type(good_message) }
    it{expect(good_test_suit.class).to eq(CogMessage)}
    it{expect(good_test_suit.valid?).to be_truthy}

    let(:bad_test_suit) { MessageFactory.get_message_type(bad_message) }
    it 'has valid fail messages ' do
      expect(bad_test_suit.valid?).to be_falsey
      expect(bad_test_suit.errors.messages).not_to be_empty
      expect(bad_test_suit.errors.messages.to_s).to include("can't be blank")
    end

  end


  context 'for OFF_STUDY ' do
    let(:good_message) { {
        :header => [
            {
                'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                'msg_dttm' => '2016-05-09T22:06:33+00:00'
            }
        ],
        :study_id => 'APEC1621SC',
        :patient_id => '2222',
        :step_number => '1.0',
        :status_date => '2016-05-09T22:06:33+00:00',
        :status => 'OFF_STUDY',
        :internal_use_only => [{
                                "request_id"=> "4-654321",
                                "environment"=> "4",
                                "request"=> "OFF_STUDY for patient_id 2222"
                               }]
      }
    }
    let(:bad_message) { {
        :header => [
            {
                'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                'msg_dttm' => '2016-05-09T22:06:33+00:00'
            }
        ],
        :study_id => 'APEC1621SC',
        :step_number => '1.0',
        :status_date => '2016-05-09T22:06:33+00:00',
        :status => 'OFF_STUDY',
        :internal_use_only => [{
                                   "request_id"=> "4-654321",
                                   "environment"=> "4",
                                   "request"=> "OFF_STUDY for patient_id 2222"
                               }]
      }
    }

    let(:good_test_suit) { MessageFactory.get_message_type(good_message) }
    it{expect(good_test_suit.class).to eq(CogMessage)}
    it{expect(good_test_suit.valid?).to be_truthy}

    let(:bad_test_suit) { MessageFactory.get_message_type(bad_message) }
    it 'has valid fail messages ' do
      expect(bad_test_suit.valid?).to be_falsey
      expect(bad_test_suit.errors.messages).not_to be_empty
      expect(bad_test_suit.errors.messages.to_s).to include("can't be blank")
    end
  end

  context 'for REQUEST_ASSIGNMENT' do
    let(:good_message) { {
        :header => [
            {
                'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                'msg_dttm' => '2016-05-09T22:06:33+00:00'
            }
        ],
        :study_id => 'APEC1621SC',
        :patient_id => '2222',
        :step_number => '1.0',
        :status_date => '2016-05-09T22:06:33+00:00',
        :status => 'REQUEST_ASSIGNMENT',
        :internal_use_only => [
            {
                "request_id"=> "4-654321",
                "environment"=> "4",
                "request"=> "REQUEST_ASSIGNMENT for patient_id 2222"
            }
        ],
        :rebiopsy => 'Y'
      }
    }

    let(:bad_message) { {
        :header => [
            {
                'msg_guid' => '0f8fad5b-d9cb-469f-al65-80067728950e',
                'msg_dttm' => '2016-05-09T22:06:33+00:00'
            }
        ],
        :study_id => 'APEC1621SC',
        :step_number => '1.0',
        :status_date => '2016-05-09T22:06:33+00:00',
        :status => 'REQUEST_ASSIGNMENT',
        :internal_use_only => [
            {
                "request_id"=> "4-654321",
                "environment"=> "4",
                "request"=> "REQUEST_ASSIGNMENT for patient_id 2222"
            }
        ],
        :rebiopsy => 'Y'
    }
    }

    let(:good_test_suit) { MessageFactory.get_message_type(good_message) }
    it{expect(good_test_suit.class).to eq(CogMessage)}
    it{expect(good_test_suit.valid?).to be_truthy}

    let(:bad_test_suit) { MessageFactory.get_message_type(bad_message) }
    it 'has valid fail messages ' do
      expect(bad_test_suit.valid?).to be_falsey
      expect(bad_test_suit.errors.messages).not_to be_empty
      expect(bad_test_suit.errors.messages.to_s).to include("can't be blank")
    end
  end

end