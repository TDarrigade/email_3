require "google_drive"
require 'open-uri'
require 'nokogiri'
require 'rubygems'

#setup_spreadsheet

session = GoogleDrive::Session.from_config("config.json")
ws = session.spreadsheet_by_key("19UG8grMCORTC3i4znK_yIhXuKe99fpp84qqGASUXP2Y").worksheets[0]


#Methode pour attrapper toute les villes et tout les emails

def get_all_the_urls_of_val_doise_townhalls()
   page = Nokogiri::HTML(open("http://www.annuaire-des-mairies.com/val-d-oise.html"))
   @cityTab = []

   page.xpath('//a[@class="lientxt"]').each do |name|
        @cityTab << name.text
   end
       #puts cityTab.length
       get_the_email_of_a_townhal_from_its_webpage(@cityTab)
end

def get_the_email_of_a_townhal_from_its_webpage(cities)
	@all_emails = []
    cities.each do |city|
    	url_cities = city.downcase.gsub(' ', '-')
        page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/95/#{url_cities}.html"))
        @all_emails << page.css('p:contains("@")').text.gsub(' ','')
    end 

end 


#on appelle la méthode pour remplir les Tableaux
	get_all_the_urls_of_val_doise_townhalls



#On injecte les tableaux dans le spreadsheet
	#pour les villes
	i = 0
	@cityTab.each do |x|
		 i += 1
		ws[i,1] = x
		end	
	

	#pour les emails
	
	n = 0
	@all_emails.each do |x|	
		n += 1
		ws[n,2] = x
		end
	ws.save

	h = Hash[@cityTab.zip @all_emails]

	File.open("Email_cities.json","w") do |f| # créer ou remplacer le .json ("w" pour "write")  
  f.write(JSON.pretty_generate(h)) # ".pretty_generate" va générer une ligne clé => Valeur dans le json… je pense
end 

	puts "tout les emails ont ete sauvegardé dans le tableau "
	puts "https://docs.google.com/spreadsheets/d/19UG8grMCORTC3i4znK_yIhXuKe99fpp84qqGASUXP2Y/edit#gid=0"
	