Github Presidência (Marcelo e Cavaco)  
[https://github.com/centraldedados/agenda_presidencia_republica](https://github.com/centraldedados/agenda_presidencia_republica)

Dados processados  
(a estrutura dos CSVs está diferente, tem que ser normalizada)  
- com localidade: [CSV](http://box.wolan.net/data_marcelo_com_localidade.csv)  
- com localidade + lat/lng: [CSV](http://box.wolan.net/data_marcelo_com_localidade_e_latlng.csv)  

Processamento  
1. download dos dados do website da presidência para CSV (já no Github)  
2. extrair a localidade manualmente. No evento de Abril editamos colaborativamente um folha de cálculo (agenda não está normalizada)  
3. utilizar um geocoder para converter localidade/país para acrescentar lat/lng (foi utilizado o do Google Maps)

Protótipo de visualização  
    [https://joaoantunes.carto.com/builder/d4b581e8-16f2-11e7-9b78-0e05a8b3e3d7/embed](https://joaoantunes.carto.com/builder/d4b581e8-16f2-11e7-9b78-0e05a8b3e3d7/embed)

Notas  
- ainda é necessário limpar os dados  
- houve uma limpeza prévia à mão, para incluir localidade  
- estrutura original: data, hora, evento, local (vazio na maior parte das vezes)  
- estrutura final:    data, hora, evento, localidade, país, lat, lng