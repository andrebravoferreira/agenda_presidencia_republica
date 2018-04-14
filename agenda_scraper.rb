require 'nokogiri'
require 'open-uri'
require 'csv'

@sleep_interval = 5

# TODO
# - for Cavaco, extract indays event

# Portuguese Presidents with an online schedule
presidents = [
  {
    'name' => 'cavaco',
    'years_in_office' => 2006..2016,
    'schedule' => 'http://anibalcavacosilva.arquivo.presidencia.pt/?idc=11&fano='
  },
  {
    'name' => 'marcelo',
    'years_in_office' => 2016..Time.now.year,
    'schedule' => 'http://www.presidencia.pt/?idc=11&fano='
  }
]


# Iterate through each president
presidents.each do |president|

  # Iterate through years in office
  president['years_in_office'].each do |year|

    # Get the schedule webpage
    page = Nokogiri::HTML(open(president['schedule'] + year.to_s))

    dias = page.css('dl#ms_agend3 dt') # Schedule container

    # CSV operation
    CSV.open("#{president['name']}_#{year}.csv", "w") do |csv|
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
          # Removes carriage return (not needed)
          evento.gsub!(/\r/, " ")#.gsub(/\n/, "")

          # Output during processing
          puts "#{data} - #{hora}: #{evento}"

          # CSV output
          csv << [data, hora, evento, local]

          dd = dd.next_element # pass to next dd if it exists
        end while dd && dd.name=='dd' # stops if there aren't more dd

      end # end of iterating through the days
      puts "#{dias.size} eventos em #{year}"

    end # end of CSV operations

    # Sleep as to not overload the server
    puts "Sleeping #{@sleep_interval} seconds..."
    sleep @sleep_interval

  end # end year range

end # end of presidents iterating
