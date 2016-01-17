defmodule SendWelcomeEmailWorker do
  def perform(email) do
    Whisper.Mailer.send_welcome_email(to: email)
  end
end
