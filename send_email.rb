require 'gmail'
require_relative 'auth'
require "google_drive"

def init #Methode pour se connecter au drive et à gmail
session = GoogleDrive::Session.from_config("config.json")
@ws = session.spreadsheet_by_key("19UG8grMCORTC3i4znK_yIhXuKe99fpp84qqGASUXP2Y").worksheets[0]
@gmail = Gmail.connect(USERNAME, PASSWORD)
end


def send_the_email(nline) #envoie des emails a "n_line" personnes
	adress = @ws[nline,3].to_s

	email = @gmail.compose do
  		to adress
  		subject "Avez-vous planté des choux?"
  		body " a la mode a la mode"	
	 
	end
	email.deliver!
	puts "email envoyé a #{@ws[nline,3]}"
end


def go_through_all_the_lines
	for i in 1..3 do
		send_the_email(i)
			end
end


#def get_the_email_html
#end

init
go_through_all_the_lines
puts @ws[3,3]

@gmail.logout


#  to "email@example.com"
#  subject "Having fun in Puerto Rico!"
#  text_part do
#    body "Text of plaintext message."
#  end
#  html_part do
#    content_type 'text/html; charset=UTF-8'
#    body "<p>Text of <em>html</em> message.</p>"
#  end
#  add_file "/path/to/some_image.jpg"
#end