require 'nokogiri'
require 'open-uri'
require 'csv'

year_range = (2016..2017)
presidente = 'marcelo' #empty if for the current president

agenda_presidencia_marcelo = "http://www.presidencia.pt/?idc=11&fano="
agenda_presidencia_cavaco = "http://anibalcavacosilva.arquivo.presidencia.pt/?idc=11&fano="

agenda_presidencia = agenda_presidencia_marcelo

year_range.each do |year|

  page = Nokogiri::HTML(open(agenda_presidencia + year.to_s))

  dias = page.css('dl#ms_agend3 dt') # container

  # CSV operation
  CSV.open("#{presidente}_#{year}.csv", "w") do |csv|
    # CSV headers
    csv << ["data", "hora", "evento", "local"]

    # Iterate through each day
    dias.each do |dt|
      dd = dt.next_element
      begin
        data = dt.text.strip
        hora = dd.css('div.hora').text.strip
        dd.css('div.texto').css('br').each{ |br| br.replace "\n" }
        evento = dd.css('div.texto').text
        local = ''
        if evento.include? 'Local:'
          evento.each_line do |line|
            if line.include? 'Local:'
              local = line
              evento.slice! line
            end
          end
        end

        puts data
        puts hora
        puts evento.strip
        puts local

        # CSV write
        # Write in CSV
        csv << [data, hora, evento.strip, local.gsub('Local: ', '')]



        dd = dd.next_element # pass to next dd if it exists
      end while dd && dd.name=='dd' # stops if there aren't more dd

    end # end of iterating through the days

  end # end of CSV operations

  puts "#{dias.size} eventos em #{year}"

end # end year range
