require_relative "ollamachat/version"
require "ollama-ai"
require "glimmer-dsl-libui"

module Ollamachat
  class Client
    attr_accessor :chat_text

    def initialize
      @chat_text = String.new("")
      @ollama_client = Ollama.new(
        credentials: { address: "http://localhost:11434" },
        ptions: { server_sent_events: true }
      )
      @chat_history = []
    end

    def communicate_with_ollama(input_text)
      add_to_chat_history({ role: "user", content: input_text })

      self.chat_text += "\n🎙️  #{input_text}\n\n🦙  "

      retrieve_ollama_response

      self.chat_text += "\n\n"
    end

    private

    def retrieve_ollama_response
      response_text = ""
      result = @ollama_client.chat(
        { model: "llama2", messages: @chat_history },
        server_sent_events: true
      ) do |event, _raw|
        response_text << (message_content = event.dig("message", "content").to_s)
        self.chat_text += message_content
      end

      add_to_chat_history({ role: "assistant", content: response_text })
    end

    def add_to_chat_history(message)
      @chat_history << message
    end
  end

  class App
    include Glimmer::LibUI::Application

    before_body do
      @ollama_chat_client = Client.new
    end

    body do
      window("Ollama Chat", 500, 300) do
        margined true

        on_closing do
          puts "Closing Application"
        end

        vertical_box do
          layout_chat_ui_elements
        end
      end
    end

    private

    def layout_chat_ui_elements
      vertical_box do
        stretchy true
        multiline_entry do
          stretchy true
          read_only true
          text <= [@ollama_chat_client, :chat_text]
        end
        horizontal_box do
          stretchy false
          user_input = entry
          button("Send") do
            stretchy false
            on_clicked do
              @ollama_chat_client.communicate_with_ollama(user_input.text)
              user_input.text = ""
            end
          end
        end
      end
    end
  end
end
