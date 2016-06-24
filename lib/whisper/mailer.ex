defmodule Whisper.Mailer do
  use Mailgun.Client,
    domain: Application.get_env(:whisper, :mailgun_domain),
    key:    Application.get_env(:whisper, :mailgun_key)

  def send_welcome_email(to: to) do
    send_email [
      to:      to,
      from:    "Whisper <admin@whisper.com>",
      subject: "Welcome aboard!",
      text:    "Welcome to Whisper!",
      html:    Phoenix.View.render_to_string(Whisper.EmailView, "welcome.html", %{})
    ]
  end
end
