require 'spec_helper'

describe MoodleRb::Message do
  let(:url) { ENV['MOODLE_URL'] || 'localhost' }
  let(:token) { ENV['MOODLE_TOKEN'] || '' }
  let(:message_moodle_rb) { MoodleRb.new(token, url).message }

describe '#send_templated', :vcr => {
    :match_requests_on => [:body], :record => :once
  } do
    let(:result) { message_moodle_rb.index }

    specify do
      expect(result).to be_a Array
      expect(result.first).to have_key 'id'
    end

      specify do
        expect{ result }.to raise_error(
          MoodleRb::MoodleError,
          'Message could not be sent.'
        )
      end

end
