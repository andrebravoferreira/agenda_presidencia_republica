require 'nokogiri'
require 'open-uri'
require 'csv'

year_range = (2006..2016) # choose a year range: 2006..2016 for Cavaco Silva or 2016..current year for Marcelo Rebelo Sousa
presidente = 'cavaco' # select the president: cavaco or marcelo

# Online schedules
agendas = {
  'cavaco' => "http://anibalcavacosilva.arquivo.presidencia.pt/?idc=11&fano=",
  'marcelo' => "http://www.presidencia.pt/?idc=11&fano="
  }

year_range.each do |year|

  page = Nokogiri::HTML(open(agendas[presidente] + year.to_s))

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
        evento = dd.css('div.texto').text.strip
        local = '' # Extract local. Might not work well for Cavaco's years
        if evento.include? 'Local:'
          evento.each_line do |line|
            if line.include? 'Local:'
              local = line.gsub('Local: ', '')
              evento.slice! line
            end
          end
        end

        # Output during processing
        puts "#{data} - #{hora}: #{evento}"

        # CSV write
        csv << [data, hora, evento, local]

        dd = dd.next_element # pass to next dd if it exists
      end while dd && dd.name=='dd' # stops if there aren't more dd

    end # end of iterating through the days
    puts "#{dias.size} eventos em #{year}"

  end # end of CSV operations

end # end year range
