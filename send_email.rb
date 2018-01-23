require 'gmail'
require_relative 'auth'
require "google_drive"

#------------------------------
#Methode pour se connecter au drive et à gmail
def init 
session = GoogleDrive::Session.from_config("config.json")
@ws = session.spreadsheet_by_key("19UG8grMCORTC3i4znK_yIhXuKe99fpp84qqGASUXP2Y").worksheets[0]
@gmail = Gmail.connect(USERNAME, PASSWORD)
end

#------------------------------
#envoie des emails 

def send_the_email(nline) 
	adress = @ws[nline,2].to_s

		email = @gmail.compose do
	  		to adress
	  		subject "Connaissez-vous THP?"
	  		body $html_content
		end
	@gmail.deliver(email)
	puts "email envoyé a #{adress}"
end
##
#def send_the_email(nline)

#	adress = @ws[nline,3].to_s

#	@gmail.deliver do
  #		to adress
  #		subject "Connaissez-vous THP?"

  #		text_part do 
  #			body "The Hacking Project."
 # 		end

#	 html_part do
#	 	content_type 'text/html; charset=UTF-8'
#	 	body "<p>Text of <em>html</em> meassage de test.</p>"
#	 end
#	end
	
#	puts "email envoyé a #{adress}"
#end
#------------------------------
#envoie des mails entre 1 et 185 personnes de la liste
def go_through_all_the_lines
	for i in 1..185 do
		send_the_email(i)
		sleep(5) #pour eviter le ban
	end
end


#------------------------------
#Faire un body en HTML
def get_the_email_html(nline)
	recipient = @ws[nline, 1].to_s
	$mailsubject = "A l'attention de la mairie de #{recipient}"
	$html_content = "<p> <b> A l'attention de la mairie de #{recipient} </b> </p>
<p>Bonjour, </p>
<p>Je m'appelle Thomas, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle The Hacking Project (http://thehackingproject.org/). Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.
Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{recipient}, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{recipient} ! </p>
<p> Yann, Moussaillon de The Hacking Project</p>" 

end
#------------------------------
#demarage du programme
init
go_through_all_the_lines

puts @ws[3,3]

@gmail.logout