require 'haml'

module MoodleRb
  class Message
    include HTTParty
    include Utility

    attr_reader :token

    def initialize(token, url)
      @token = token
      self.class.base_uri url
    end

    # :template (path string), and transmissions (array)
    def send_templated(template, transmissions)
      engine = Haml::Engine.new(File.read(template))
      post_packet = {
        :body => {
          :wstoken => @token,
          :wsfunction => 'core_message_send_instant_messages',
          :messages => {}
        }
      }
      transmissions.each_index do |i|
        post_packet[:body][:messages][i.to_s] = {
          :touserid => transmissions[i][:touserid], # make sure to set this in the params you pass in
          :text => engine.render(Object.new, :params => transmissions[i])
        }
      end

      response = self.class.post('/webservice/rest/server.php', post_packet)

      if error_response?(response)
        raise MoodleError.new(response.parsed_response)
      else
        response.parsed_response.first
      end
    end

  end #Message

end #Module MoodleRB

