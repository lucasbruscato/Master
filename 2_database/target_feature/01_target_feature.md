
# Create Target Feature


```python
import PyPDF2
import unidecode
import pandas as pd
from collections import Counter
import csv
import os
import os.path
import random
import re
import datetime
```

### Create lists with all paths to all files


```python
folders = ["ciclo_3",
           "ciclo_4",
           "ciclo_5",
           "edicoes_anteriores/sorteio_34",
           "edicoes_anteriores/sorteio_35",
           "edicoes_anteriores/sorteio_36",
           "edicoes_anteriores/sorteio_37",
           "edicoes_anteriores/sorteio_38",
           "edicoes_anteriores/sorteio_39",
           "edicoes_anteriores/sorteio_40"]

seq_folders = []
file_names = []
file_names_and_paths = []

for folder in folders:
    directory = '../programa_de_fiscalizacao_em_entes_federativos/' + folder
    
    number_of_files = len([name for name in os.listdir(directory) if os.path.isfile(os.path.join(directory, name))])
    
    for i in range(0, number_of_files):
        file_name_and_path = directory + "/" + os.listdir(directory)[i]
        if (".pdf" in file_name_and_path):
            seq_folders.append(folder)
            file_names.append(os.listdir(directory)[i])
            file_names_and_paths.append(file_name_and_path)

print('Example: \n' + file_names_and_paths[0:1][0])
```

    Example: 
    ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8998-Santo Antônio de Jesus-BA.pdf


### Generate target feature for each report ('read' and summarised the polarity)


```python
sentilex_database = pd.read_csv("../sentilex/99_01_sentilex_database.csv",
                                sep = ";")

sentilex_database.adjective = sentilex_database.adjective.str.normalize('NFKD').\
                                str.encode('ascii', errors='ignore').str.decode('utf-8')
```


```python
cities = pd.DataFrame()

print("List of reports read and summarised")

for file_number in range(0, len(file_names_and_paths)):
    folder = seq_folders[file_number]
    file_name = file_names[file_number]
    file_name_and_path = file_names_and_paths[file_number]
    print(str(datetime.datetime.now()) + ' ' + file_name_and_path)
    
    # read report using external library pdf miner and save in 'temp_report.txt'
    command_to_cmd = 'pdf2txt.py "' + file_name_and_path + '" > temp_report.txt'
    os.system(command_to_cmd)
    
    # read temporary file
    temporary_file = open('temp_report.txt', 'r')
    
    whole_text = ''
    
    for line in temporary_file:
        whole_text += line
    
    words = re.findall(r"[\w']+", unidecode.unidecode(re.sub('\d', ' ', whole_text).lower()))

    # create the frequencies
    words_freq = pd.DataFrame.from_dict(Counter(words), orient = 'index').reset_index()
    words_freq.columns = ['word', 'freq']
    words_freq['pct'] = words_freq['freq']/sum(words_freq.freq)

    # aggregate polarity
    words_freq_polarity = words_freq.merge(sentilex_database,
                                           left_on = "word",
                                           right_on = "adjective",
                                           how = "left").iloc[:, [0, 1, 2, 4]]
    
    words_freq_polarity_fill = words_freq_polarity.fillna(0)
    
    # summarise
    number_of_words = words_freq_polarity_fill.freq.sum()
    pct_pol_neg = words_freq_polarity_fill[words_freq_polarity_fill.polarity == -1].pct.sum()
    pct_pol_pos = words_freq_polarity_fill[words_freq_polarity_fill.polarity == 1].pct.sum()
    pct_pol_neu = words_freq_polarity_fill[words_freq_polarity_fill.polarity == 0].pct.sum()
    
    current_city = pd.DataFrame({"folder": folder,
                                 "file_name": file_name,
                                 "number_of_words": number_of_words,
                                 "pct_pol_neg": pct_pol_neg,
                                 "pct_pol_pos": pct_pol_pos,
                                 "pct_pol_neu": pct_pol_neu},
                                index = [0])
    
    cities = cities.append(current_city)
```

    List of reports read and summarised
    2019-06-05 21:39:32.528643 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8998-Santo Antônio de Jesus-BA.pdf
    2019-06-05 21:39:56.029051 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9024-Ulianópolis-PA.pdf
    2019-06-05 21:40:36.182610 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9010-Aldeias Altas-MA.pdf
    2019-06-05 21:41:26.127173 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9034-Paraíba do Sul-RJ.pdf
    2019-06-05 21:41:41.033747 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9045-Governador Celso Ramos-SC.pdf
    2019-06-05 21:41:44.086117 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9016-Pirajuba-MG.pdf
    2019-06-05 21:41:51.088958 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9018-Naviraí-MS.pdf
    2019-06-05 21:42:14.171958 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9015-Nova Lima-MG.pdf
    2019-06-05 21:42:28.939082 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9014-Fronteira-MG.pdf
    2019-06-05 21:42:35.306303 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9019-Paranhos-MS.pdf
    2019-06-05 21:43:01.043311 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9033-São José dos Pinhais-PR.pdf
    2019-06-05 21:43:32.694445 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9025-Pedras de Fogo-PB.pdf
    2019-06-05 21:44:19.678341 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9013-Florestal-MG.pdf
    2019-06-05 21:44:31.753721 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9002-Paramoti-CE.pdf
    2019-06-05 21:44:40.756692 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9021-RESERVA DO CABAÇAL-MT.pdf
    2019-06-05 21:45:03.300009 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9006-Abadiânia-GO.pdf
    2019-06-05 21:45:28.652841 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9048-Barra dos Coqueiros-SE.pdf
    2019-06-05 21:45:35.026057 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8997-Nilo Peçanha-BA.pdf
    2019-06-05 21:45:48.653159 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9029-Ilha de Itamaracá-PE.pdf
    2019-06-05 21:46:15.922442 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9037-Poço Branco-RN.pdf
    2019-06-05 21:46:35.172974 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9044-Putinga-RS.pdf
    2019-06-05 21:46:42.001582 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9028-Belém de Maria-PE.pdf
    2019-06-05 21:47:23.676941 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9052-Guararema-SP.pdf
    2019-06-05 21:47:30.432231 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9047-Navegantes-SC.pdf
    2019-06-05 21:47:35.591242 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9023-Santa Luzia do Pará-PA.pdf
    2019-06-05 21:47:49.205370 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9009-Valparaíso de Goiás-GO.pdf
    2019-06-05 21:48:03.625639 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8996-Madre de Deus-BA.pdf
    2019-06-05 21:48:07.919394 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9046-Ibicaré-SC.pdf
    2019-06-05 21:48:10.198306 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9026-Sobrado-PB.pdf
    2019-06-05 21:49:26.475115 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9012-Humberto de Campos-MA.pdf
    2019-06-05 21:49:55.904073 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8994-Macapá-AP.pdf
    2019-06-05 21:50:20.560618 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9050-Porto da Folha-SE.pdf
    2019-06-05 21:50:42.904727 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9031-Adrianópolis-PR.pdf
    2019-06-05 21:51:05.282656 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9035-São Gonçalo-RJ.pdf
    2019-06-05 21:51:23.982508 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9008-Monte Alegre de Goiás-GO.pdf
    2019-06-05 21:51:46.660229 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9043-Pinhal da Serra-RS.pdf
    2019-06-05 21:51:55.453263 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9049-Maruim-SE.pdf
    2019-06-05 21:52:16.751775 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9040-Encantado-RS.pdf
    2019-06-05 21:52:40.338258 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9056-Santa Maria do Tocantins-TO.pdf
    2019-06-05 21:52:45.365768 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9039-Normandia-RR.pdf
    2019-06-05 21:53:10.723255 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9032-Rio Negro-PR.pdf
    2019-06-05 21:53:27.612291 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8991-Plácido de Castro-AC.pdf
    2019-06-05 21:53:37.927727 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9000-Canindé-CE.pdf
    2019-06-05 21:53:57.940856 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9041-Glorinha-RS.pdf
    2019-06-05 21:54:01.241921 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9055-São Paulo-SP.pdf
    2019-06-05 21:54:24.225753 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9007-Iaciara-GO.pdf
    2019-06-05 21:54:40.130916 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9038-Alto Paraíso-RO.pdf
    2019-06-05 21:54:55.050105 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9057-Campina Grande-PB.pdf
    2019-06-05 21:56:05.276347 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9027-Abreu e Lima-PE.pdf
    2019-06-05 21:56:24.383669 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9051-Barueri-SP.pdf
    2019-06-05 21:57:10.391643 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9001-Ibaretama-CE.pdf
    2019-06-05 21:57:18.323655 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9022-Marituba-PA.pdf
    2019-06-05 21:57:35.656996 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9020-Indiavaí-MT.pdf
    2019-06-05 21:57:56.328107 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9054-São Bernardo do Campo-SP.pdf
    2019-06-05 21:58:15.482219 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8993-Matriz de Camaragibe-AL.pdf
    2019-06-05 21:58:42.816189 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9005-Serra-ES.pdf
    2019-06-05 21:59:05.389325 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9011-Altamira do Maranhão-MA.pdf
    2019-06-05 21:59:57.168874 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8992-Maragogi-AL.pdf
    2019-06-05 22:00:29.044116 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8995-Ilhéus-BA.pdf
    2019-06-05 22:01:08.865884 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9004-Rio Bananal-ES.pdf
    2019-06-05 22:01:21.045559 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9017-Vespasiano-MG.pdf
    2019-06-05 22:01:41.094991 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9036-Jardim de Angicos-RN.pdf
    2019-06-05 22:02:45.043020 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9053-Praia Grande-SP.pdf
    2019-06-05 22:02:53.329299 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9030-Brasileira-PI.pdf
    2019-06-05 22:03:18.745960 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/8999-Teolândia-BA.pdf
    2019-06-05 22:03:40.013222 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9003-Redenção-CE.pdf
    2019-06-05 22:03:44.920758 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9042-Minas do Leão-RS.pdf
    2019-06-05 22:03:49.229580 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10084-Palmeira dos Índios-AL.pdf
    2019-06-05 22:04:35.789295 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10243-Januária-MG.pdf
    2019-06-05 22:04:49.134757 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10408-Regeneração-PI.pdf
    2019-06-05 22:05:19.183070 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10320-Bagé-RS.pdf
    2019-06-05 22:05:36.550713 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10644-Casa Nova-BA.pdf
    2019-06-05 22:06:21.059822 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10640-Serrinha-BA.pdf
    2019-06-05 22:06:59.990604 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10440-Mazagão-AP.pdf
    2019-06-05 22:07:43.948375 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10359-Rorainópolis-RR.pdf
    2019-06-05 22:08:09.539296 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10323-São Borja-RS.pdf
    2019-06-05 22:08:17.520618 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10374-Jataí-GO.pdf
    2019-06-05 22:09:01.266251 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10379-São Domingos-SC.pdf
    2019-06-05 22:09:46.437324 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10407-Oeiras-PI.pdf
    2019-06-05 22:10:41.809363 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10291-Criciúma-SC.pdf
    2019-06-05 22:10:55.354109 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10383-Caldas Novas-GO.pdf
    2019-06-05 22:11:21.479151 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10311-Manhuaçu-MG.pdf
    2019-06-05 22:11:38.593587 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10289-Estância-SE.pdf
    2019-06-05 22:12:15.006752 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10403-Tobias Barreto-SE.pdf
    2019-06-05 22:13:06.546984 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10333-Princesa Isabel-PB.pdf
    2019-06-05 22:13:52.989232 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10309-Sete Lagoas-MG.pdf
    2019-06-05 22:14:07.894603 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10436-Cosmópolis-SP.pdf
    2019-06-05 22:14:16.003847 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10453-Imperatriz-MA.pdf
    2019-06-05 22:14:44.213164 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10346-São Bento-PB.pdf
    2019-06-05 22:15:23.141373 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10327-Cruzeiro do Sul-AC.pdf
    2019-06-05 22:15:34.083186 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10356-Lages-SC.pdf
    2019-06-05 22:16:01.897519 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10541-Serra Talhada-PE.pdf
    2019-06-05 22:18:02.469415 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10089-Hortolândia-SP.pdf
    2019-06-05 22:18:13.245146 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10237-Guarapuava-PR.pdf
    2019-06-05 22:18:16.069904 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10416-Crateús-CE.pdf
    2019-06-05 22:18:17.375030 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10321-Uruguaiana-RS.pdf
    2019-06-05 22:18:26.115603 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10009-Cianorte-PR.pdf
    2019-06-05 22:18:30.711308 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10335-Colatina-ES.pdf
    2019-06-05 22:18:44.796788 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10331-Nova Venécia-ES.pdf
    2019-06-05 22:19:05.343577 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10402-Itabaiana-SE.pdf
    2019-06-05 22:20:31.367733 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10332-Petrolina-PE.pdf
    2019-06-05 22:22:59.703523 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10279-Içara-SC.pdf
    2019-06-05 22:23:21.995150 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10319-Cruz Alta-RS.pdf
    2019-06-05 22:23:34.499495 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10430-Juazeiro do Norte-CE.pdf
    2019-06-05 22:23:46.247837 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10062-Arapiraca-AL.pdf
    2019-06-05 22:24:04.810385 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10305-Gurupi-TO.pdf
    2019-06-05 22:24:07.180550 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10410-Sobral-CE.pdf
    2019-06-05 22:24:14.101065 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10337-Santa Maria-RS.pdf
    2019-06-05 22:24:39.201447 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10314-Goiás-GO.pdf
    2019-06-05 22:24:46.669266 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10343-Dionísio Cerqueira-SC.pdf
    2019-06-05 22:25:03.129153 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10395-Três Lagoas-MS.pdf
    2019-06-05 22:25:32.415176 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/9958-Itapeva-SP.pdf
    2019-06-05 22:25:41.050350 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10091-Piancó-PB.pdf
    2019-06-05 22:28:43.706263 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10400-Piracicaba-SP.pdf
    2019-06-05 22:29:09.588505 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10642-Barreiras-BA.pdf
    2019-06-05 22:29:47.823625 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10435-Sorocaba-SP.pdf
    2019-06-05 22:30:09.342995 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10325-Cachoeira do Sul-RS.pdf
    2019-06-05 22:30:10.747443 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10088-Araçatuba-SP.pdf
    2019-06-05 22:30:20.547941 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10643-Feira de Santana-BA.pdf
    2019-06-05 22:30:30.414743 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10437-Tabatinga-AM.pdf
    2019-06-05 22:30:39.138911 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10317-Santo Ângelo-RS.pdf
    2019-06-05 22:30:55.997006 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10292-Lagarto-SE.pdf
    2019-06-05 22:31:02.221378 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10368-Itaituba-PA.pdf
    2019-06-05 22:31:12.307878 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10308-Canguaretama-RN.pdf
    2019-06-05 22:31:35.918659 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10391-Catalão-GO.pdf
    2019-06-05 22:32:24.839274 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10247-Barbacena-MG.pdf
    2019-06-05 22:32:34.040742 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10322-Alegrete-RS.pdf
    2019-06-05 22:32:50.151929 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10315-Teófilo Otoni-MG.pdf
    2019-06-05 22:33:06.470631 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10318-Curvelo-MG.pdf
    2019-06-05 22:33:37.291520 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10406-Caracol-PI.pdf
    2019-06-05 22:33:51.696695 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10313-Barbalha-CE.pdf
    2019-06-05 22:34:04.032134 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10245-Nova Xavantina-MT.pdf
    2019-06-05 22:34:26.071711 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10638-Alagoinhas-BA.pdf
    2019-06-05 22:35:10.557886 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/9947-Cachoeiro de Itapemirim-ES.pdf
    2019-06-05 22:35:31.946675 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10046-Araras-SP.pdf
    2019-06-05 22:35:48.766901 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10588-Garanhuns-PE.pdf
    2019-06-05 22:36:54.626645 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10193-Goianinha-RN.pdf
    2019-06-05 22:37:07.395144 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10310-Passos-MG.pdf
    2019-06-05 22:37:16.562803 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10424-Breves-PA.pdf
    2019-06-05 22:37:33.671612 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/9802-Campo Verde-MT.pdf
    2019-06-05 22:37:51.459626 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10641-Jequié-BA.pdf
    2019-06-05 22:38:16.275406 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10090-Salinas-MG.pdf
    2019-06-05 22:38:45.066637 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10281-Araguaína-TO.pdf
    2019-06-05 22:38:46.773782 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10362-Ceres-GO.pdf
    2019-06-05 22:38:58.817335 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10365-Caruaru-PE.pdf
    2019-06-05 22:40:02.510613 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10345-Alexandria-RN.pdf
    2019-06-05 22:40:16.440454 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10405-Bom Jesus-PI.pdf
    2019-06-05 22:40:27.437637 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10238-Umuarama-PR.pdf
    2019-06-05 22:40:37.235895 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10434-Pinheiro-MA.pdf
    2019-06-05 22:41:14.102919 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/9824-Cornélio Procópio-PR.pdf
    2019-06-05 22:41:38.079845 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10639-Paulo Afonso-BA.pdf
    2019-06-05 22:42:01.834264 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10388-Sertãozinho-SP.pdf
    2019-06-05 22:42:09.382291 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10442-Viçosa-MG.pdf
    2019-06-05 22:42:13.833237 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10286-Cascavel-PR.pdf
    2019-06-05 22:42:42.949845 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10438-Icó-CE.pdf
    2019-06-05 22:42:52.966012 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10287-Londrina-PR.pdf
    2019-06-05 22:43:09.325680 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10312-Juiz de Fora-MG.pdf
    2019-06-05 22:43:28.929470 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10324-Santa Rosa-RS.pdf
    2019-06-05 22:43:37.211706 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10361-Rio Verde-GO.pdf
    2019-06-05 22:44:08.736821 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10371-Aquidauana-MS.pdf
    2019-06-05 22:44:51.756491 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10444-Itaperuna-RJ.pdf
    2019-06-05 22:46:11.468352 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12322-Parnamirim-RN.pdf
    2019-06-05 22:46:28.851254 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12344-Itajubá-MG.pdf
    2019-06-05 22:46:35.287997 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12190-Tamandaré-PE.pdf
    2019-06-05 22:47:10.286170 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12370-Itatira-CE.pdf
    2019-06-05 22:47:11.759647 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12553-Olho d'Água das Cunhãs-MA.pdf
    2019-06-05 22:47:54.352666 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12205-Vitória do Xingu-PA.pdf
    2019-06-05 22:48:26.536409 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12257-Autazes-AM.pdf
    2019-06-05 22:49:32.751451 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12167-Barreiros-PE.pdf
    2019-06-05 22:49:55.498064 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12269-São José do Rio Preto-SP.pdf
    2019-06-05 22:50:40.180789 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12312-Rio Largo-AL.pdf
    2019-06-05 22:51:01.006089 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12421-Vitorino Freire-MA.pdf
    2019-06-05 22:52:07.031615 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12139-Anagé-BA.pdf
    2019-06-05 22:52:54.602967 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12282-Montes Claros-MG.pdf
    2019-06-05 22:53:29.073304 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12281-Campo Grande-MS.pdf
    2019-06-05 22:53:52.861717 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12192-Rio Branco-AC.pdf
    2019-06-05 22:54:19.323076 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12143-Introdução.pdf
    2019-06-05 22:54:38.538347 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12311-Teresópolis-RJ.pdf
    2019-06-05 22:54:55.238788 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12372-Ubajara-CE.pdf
    2019-06-05 22:55:05.459981 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12356-Pouso Alegre-MG.pdf
    2019-06-05 22:55:16.267904 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12155-Palmas-TO.pdf
    2019-06-05 22:55:17.234815 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12361-Boa Vista-RR.pdf
    2019-06-05 22:55:29.736160 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12154-São Raimundo Nonato-PI.pdf
    2019-06-05 22:55:50.503517 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12355-Uberlândia-MG.pdf
    2019-06-05 22:56:46.385799 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12549-Timon-MA.pdf
    2019-06-05 22:57:31.648874 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12194-Santo André-SP.pdf
    2019-06-05 22:57:51.096678 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12179-Santarém-PA.pdf
    2019-06-05 22:58:40.370088 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12178-São José-SC.pdf
    2019-06-05 22:58:49.815757 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12368-Várzea Grande-MT.pdf
    2019-06-05 22:59:23.067893 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12267-São Carlos-SP.pdf
    2019-06-05 23:00:11.574821 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12152-Maringá-PR.pdf
    2019-06-05 23:00:51.598593 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12204-Abaetetuba-PA.pdf
    2019-06-05 23:01:26.166871 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12360-Muriaé-MG.pdf
    2019-06-05 23:02:18.864809 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12388-Cajazeiras-PB.pdf
    2019-06-05 23:02:58.732316 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12264-Aparecida de Goiânia-GO.pdf
    2019-06-05 23:03:55.399067 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12367-Camocim-CE.pdf
    2019-06-05 23:03:58.239036 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/11988-Joinville-SC.pdf
    2019-06-05 23:04:07.611164 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12177-Florianópolis-SC.pdf
    2019-06-05 23:04:24.428139 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12159-Pancas-ES.pdf
    2019-06-05 23:04:40.817510 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12122-Santos-SP.pdf
    2019-06-05 23:05:00.691292 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12338-General Maynard-SE.pdf
    2019-06-05 23:05:11.730754 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12191-Ouricuri-PE.pdf
    2019-06-05 23:05:55.949198 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12161-Vila Velha-ES.pdf
    2019-06-05 23:06:22.532990 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12070-Caxias do Sul-RS.pdf
    2019-06-05 23:06:45.303355 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12287-Uberaba-MG.pdf
    2019-06-05 23:07:02.588030 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12362-Porto Velho-RO.pdf
    2019-06-05 23:08:05.570941 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12197-Bauru-SP.pdf
    2019-06-05 23:08:17.655518 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12352-Lavras-MG.pdf
    2019-06-05 23:08:27.790443 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12142-Mata Grande-AL.pdf
    2019-06-05 23:08:37.026866 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12371-Milagres-CE.pdf
    2019-06-05 23:08:50.885350 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12340-Ferreira Gomes-AP.pdf
    2019-06-05 23:09:02.202959 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12353-Natal-RN.pdf
    2019-06-05 23:09:20.443516 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12123-São José dos Campos-SP.pdf
    2019-06-05 23:09:41.505346 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12150-Ponta Grossa-PR.pdf
    2019-06-05 23:10:15.151930 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12369-Iguatu-CE.pdf
    2019-06-05 23:10:31.981734 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12316-Mossoró-RN.pdf
    2019-06-05 23:10:43.684043 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12175-Chapecó-SC.pdf
    2019-06-05 23:10:48.932932 ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12373-Crato-CE.pdf
    2019-06-05 23:10:58.546904 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1842-São Raimundo do Doca Bezerra-MA.pdf
    2019-06-05 23:11:08.855600 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1878-Arujá-SP.pdf
    2019-06-05 23:11:11.986354 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1877-Lagarto-SE.pdf
    2019-06-05 23:11:24.156350 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1860-Santa Cruz do Capibaribe-PE.pdf
    2019-06-05 23:12:02.482319 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1840-Santo Antônio da Barra-GO.pdf
    2019-06-05 23:12:07.732175 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1864-Paranaguá-PR.pdf
    2019-06-05 23:12:10.437260 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1876-Japaratuba-SE.pdf
    2019-06-05 23:12:25.323994 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1825-Manoel Urbano-AC.pdf
    2019-06-05 23:12:34.739470 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1872-Muçum-RS.pdf
    2019-06-05 23:12:39.387157 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1875-Benedito Novo-SC.pdf
    2019-06-05 23:12:46.230342 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1835-Itapagé-CE.pdf
    2019-06-05 23:13:07.353116 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1883-Taubaté-SP.pdf
    2019-06-05 23:13:10.367574 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1831-Lamarão-BA.pdf
    2019-06-05 23:13:15.873665 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1882-Santa Albertina-SP.pdf
    2019-06-05 23:13:21.057265 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1857-Manaíra-PB.pdf
    2019-06-05 23:13:26.155661 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1865-Roncador-PR.pdf
    2019-06-05 23:13:34.932485 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1837-São Mateus-ES.pdf
    2019-06-05 23:13:40.853507 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1836-Jaguaribe-CE.pdf
    2019-06-05 23:14:04.906490 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1828-América Dourada-BA.pdf
    2019-06-05 23:14:15.509727 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1843-Borda da Mata-MG.pdf
    2019-06-05 23:14:21.406538 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1829-Aurelino Leal-BA.pdf
    2019-06-05 23:14:35.537227 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1838-Edealina-GO.pdf
    2019-06-05 23:14:39.003550 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1850-Selvíria-MS.pdf
    2019-06-05 23:14:56.110446 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1861-Betânia do Piauí-PI.pdf
    2019-06-05 23:15:08.675450 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1869-Upanema-RN.pdf
    2019-06-05 23:15:14.567766 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1863-Araucária-PR.pdf
    2019-06-05 23:15:52.612097 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1884-Novo Acordo-TO.pdf
    2019-06-05 23:16:01.800104 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1839-Nova Glória-GO.pdf
    2019-06-05 23:16:05.719153 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1846-Durandé-MG.pdf
    2019-06-05 23:16:11.173381 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1844-Campo Belo-MG.pdf
    2019-06-05 23:16:14.286867 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1832-Ubaíra-BA.pdf
    2019-06-05 23:16:21.589608 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1848-Nova Ponte-MG.pdf
    2019-06-05 23:16:27.074242 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1833-Boa Viagem-CE.pdf
    2019-06-05 23:16:43.509535 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1867-Fernando Pedroza-RN.pdf
    2019-06-05 23:16:49.125698 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1855-Primavera-PA.pdf
    2019-06-05 23:17:00.554778 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1826-Feliz Deserto-AL.pdf
    2019-06-05 23:17:27.278128 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1870-Arroio dos Ratos-RS.pdf
    2019-06-05 23:17:31.421754 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1834-Iracema-CE.pdf
    2019-06-05 23:17:38.791736 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1879-Cesário Lange-SP.pdf
    2019-06-05 23:17:46.859726 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1873-Segredo-RS.pdf
    2019-06-05 23:17:51.569696 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1847-Minduri-MG.pdf
    2019-06-05 23:17:56.927131 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1862-Floriano-PI.pdf
    2019-06-05 23:18:07.463685 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1853-Bagre-PA.pdf
    2019-06-05 23:18:18.324424 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1866-Maricá-RJ.pdf
    2019-06-05 23:18:24.343929 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1852-Santo Antônio do Leste-MT.pdf
    2019-06-05 23:18:36.686791 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1851-Reserva do Cabaçal-MT.pdf
    2019-06-05 23:18:44.554258 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1881-Pratânia-SP.pdf
    2019-06-05 23:18:46.705244 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1874-Bandeirante-SC.pdf
    2019-06-05 23:18:50.828850 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1856-Curral de Cima-PB.pdf
    2019-06-05 23:19:06.196993 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1849-Santana de Cataguases-MG.pdf
    2019-06-05 23:19:09.932422 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1868-João Câmara-RN.pdf
    2019-06-05 23:19:19.708600 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1845-Caputira-MG.pdf
    2019-06-05 23:19:27.891815 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1871-Bento Gonçalves-RS.pdf
    2019-06-05 23:19:33.933633 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1858-Caruaru-PE.pdf
    2019-06-05 23:20:30.133283 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1841-Bela Vista do Maranhão-MA.pdf
    2019-06-05 23:20:54.919008 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1827-Urucurituba-AM.pdf
    2019-06-05 23:21:11.927580 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1830-Canápolis-BA.pdf
    2019-06-05 23:21:25.900819 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1859-Quipapá-PE.pdf
    2019-06-05 23:22:22.899254 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1897-Palminópolis-GO.pdf
    2019-06-05 23:22:27.488315 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1896-Diorama-GO.pdf
    2019-06-05 23:22:30.036809 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1916-Agrestina-PE.pdf
    2019-06-05 23:22:55.533001 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1920-Santo Antônio dos Milagres-PI.pdf
    2019-06-05 23:23:02.090208 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1914-Queimadas-PB.pdf
    2019-06-05 23:23:05.214950 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1921-Bituruna-PR.pdf
    2019-06-05 23:23:22.834566 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1928-Presidente Médici-RO.pdf
    2019-06-05 23:23:36.157149 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1898-Piracanjuba-GO.pdf
    2019-06-05 23:23:46.386554 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1937-Nossa Senhora Aparecida-SE.pdf
    2019-06-05 23:23:59.929659 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1912-Santa Maria do Pará-PA.pdf
    2019-06-05 23:24:10.391177 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1922-Indianópolis-PR.pdf
    2019-06-05 23:24:14.048953 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1892-Farias Brito-CE.pdf
    2019-06-05 23:24:22.159403 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1926-Parazinho-RN.pdf
    2019-06-05 23:24:28.342219 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1935-Sangão-SC.pdf
    2019-06-05 23:24:34.510552 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1893-Horizonte-CE.pdf
    2019-06-05 23:24:42.099598 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1905-Mesquita-MG.pdf
    2019-06-05 23:24:49.107011 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1887-Morro do Chapéu-BA.pdf
    2019-06-05 23:25:10.611823 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1906-Patrocínio-MG.pdf
    2019-06-05 23:25:31.573416 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1931-Itaara-RS.pdf
    2019-06-05 23:25:34.309926 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1909-Colíder-MT.pdf
    2019-06-05 23:25:43.188782 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1891-Arneiroz-CE.pdf
    2019-06-05 23:25:56.782836 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1934-Jupiá-SC.pdf
    2019-06-05 23:25:59.571658 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1929-Uiramutã-RR.pdf
    2019-06-05 23:26:23.630777 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1933-Santa Clara do Sul-RS.pdf
    2019-06-05 23:26:27.449070 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1888-Nova Ibiá-BA.pdf
    2019-06-05 23:26:33.295188 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1917-Orocó-PE.pdf
    2019-06-05 23:27:02.628769 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1919-Bela Vista do Piauí-PI.pdf
    2019-06-05 23:27:08.937529 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1894-Poranga-CE.pdf
    2019-06-05 23:27:23.839673 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1900-Itaipava do Grajaú-MA.pdf
    2019-06-05 23:27:40.534506 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1925-Itaú-RN.pdf
    2019-06-05 23:27:46.892350 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1942-Riversul-SP.pdf
    2019-06-05 23:27:54.136520 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1924-Porciúncula-RJ.pdf
    2019-06-05 23:27:56.407944 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1885-Santana do Mundaú-AL.pdf
    2019-06-05 23:28:13.014385 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1938-Adamantina-SP.pdf
    2019-06-05 23:28:19.922626 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1943-São Sebastião da Grama-SP.pdf
    2019-06-05 23:28:23.711040 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1911-Bujaru-PA.pdf
    2019-06-05 23:28:37.378919 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1940-Palmares Paulista-SP.pdf
    2019-06-05 23:28:43.001492 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1908-Antônio João-MS.pdf
    2019-06-05 23:28:53.341876 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1936-Divina Pastora-SE.pdf
    2019-06-05 23:28:58.374390 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1901-Carrancas-MG.pdf
    2019-06-05 23:29:02.467744 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1904-Itinga-MG.pdf
    2019-06-05 23:29:10.920649 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1902-Cláudio-MG.pdf
    2019-06-05 23:29:16.488006 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1941-Pontes Gestal-SP.pdf
    2019-06-05 23:29:26.945085 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1907-São João do Manteninha-MG.pdf
    2019-06-05 23:29:33.256020 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1889-Rio do Antônio-BA.pdf
    2019-06-05 23:29:37.782839 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1915-Umbuzeiro-PB.pdf
    2019-06-05 23:29:48.618759 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1930-Glorinha-RS.pdf
    2019-06-05 23:29:50.862423 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1918-Taquaritinga do Norte-PE.pdf
    2019-06-05 23:30:26.785938 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1886-Barreiras-BA.pdf
    2019-06-05 23:30:36.887174 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1899-Fortuna-MA.pdf
    2019-06-05 23:30:51.580309 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1939-Auriflama-SP.pdf
    2019-06-05 23:30:56.065307 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1895-Ponto Belo-ES.pdf
    2019-06-05 23:31:02.917259 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1890-Tremedal-BA.pdf
    2019-06-05 23:31:13.385416 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1932-Relvado-RS.pdf
    2019-06-05 23:31:16.125283 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1927-São Miguel-RN.pdf
    2019-06-05 23:31:36.336822 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1923-Itaguajé-PR.pdf
    2019-06-05 23:31:40.325165 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1913-São Félix do Xingu-PA.pdf
    2019-06-05 23:31:49.966643 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1910-Santa Rita do Trivelato-MT.pdf
    2019-06-05 23:31:57.477958 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1944-Bandeirantes do Tocantins-TO.pdf
    2019-06-05 23:32:05.369182 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2467-Mamanguape-PB.pdf
    2019-06-05 23:32:21.607109 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2459-Bela Vista da Caroba-PR.pdf
    2019-06-05 23:32:23.907068 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2491-Sobral-CE.pdf
    2019-06-05 23:32:39.522096 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2477-Terra Rica-PR.pdf
    2019-06-05 23:32:53.798673 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2489-Japoatã-SE.pdf
    2019-06-05 23:33:12.049527 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2483-Pontal do Paraná-PR.pdf
    2019-06-05 23:33:30.179639 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2497-Santo André-PB.pdf
    2019-06-05 23:33:33.354045 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2487-Groaíras-CE.pdf
    2019-06-05 23:33:44.780855 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2455-São João da Ponta-PA.pdf
    2019-06-05 23:33:55.288245 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2499-São Roque do Canaã-ES.pdf
    2019-06-05 23:34:04.482420 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2495-Ibirapitanga-BA.pdf
    2019-06-05 23:34:09.914225 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2463-Santana-AP.pdf
    2019-06-05 23:34:35.547936 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2475-Jundiá-AL.pdf
    2019-06-05 23:34:49.854937 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2473-Faro-PA.pdf
    2019-06-05 23:35:00.097665 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2471-Dourados-MS.pdf
    2019-06-05 23:35:05.161113 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2469-Monte Alegre-RN.pdf
    2019-06-05 23:35:19.273428 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2457-Palestina do Pará-PA.pdf
    2019-06-05 23:35:27.563295 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2479-Condado-PE.pdf
    2019-06-05 23:36:29.107243 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2481-Iranduba-AM.pdf
    2019-06-05 23:36:38.048797 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2465-Balsas-MA.pdf
    2019-06-05 23:37:01.998148 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2493-Arraial do Cabo-RJ.pdf
    2019-06-05 23:37:18.107247 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2501-Pacoti-CE.pdf
    2019-06-05 23:37:28.112574 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2461-Itacuruba-PE.pdf
    2019-06-05 23:38:03.501057 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2781-São Domingos-SE.pdf
    2019-06-05 23:38:14.307067 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2795-Cidade Ocidental-GO.pdf
    2019-06-05 23:38:21.976668 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2821-Aurora do Pará-PA.pdf
    2019-06-05 23:38:33.606918 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2761-Iúna-ES.pdf
    2019-06-05 23:38:44.005239 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2837-Belford Roxo-RJ.pdf
    2019-06-05 23:38:51.123037 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2847-Lagoa Alegre-PI.pdf
    2019-06-05 23:39:07.445882 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2859-Vazante-MG.pdf
    2019-06-05 23:39:22.957868 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2811-Itutinga-MG.pdf
    2019-06-05 23:39:27.244770 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2777-Caldas Brandão-PB.pdf
    2019-06-05 23:39:36.587547 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2793-Dois Irmãos das Missões-RS.pdf
    2019-06-05 23:39:42.529183 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2789-São Sebastião do Passé-BA.pdf
    2019-06-05 23:39:48.858900 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2877-Patrocínio Paulista-SP.pdf
    2019-06-05 23:40:02.830483 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2843-Brejolândia-BA.pdf
    2019-06-05 23:40:10.661306 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2807-Adrianópolis-PR.pdf
    2019-06-05 23:40:16.251095 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2849-Cacimba de Dentro-PB.pdf
    2019-06-05 23:40:24.151559 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2845-Itapoá-SC.pdf
    2019-06-05 23:40:33.095315 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2855-Nanuque-MG.pdf
    2019-06-05 23:40:47.502934 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2871-São José do Sul-RS.pdf
    2019-06-05 23:40:52.241669 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2865-Barra do Ribeiro-RS.pdf
    2019-06-05 23:40:59.065999 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2783-Hidrolândia-CE.pdf
    2019-06-05 23:41:16.541060 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2763-São José do Campestre-RN.pdf
    2019-06-05 23:41:32.203126 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2831-Itatira-CE.pdf
    2019-06-05 23:41:46.211305 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2825-Campanha-MG.pdf
    2019-06-05 23:41:52.577825 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2813-Amargosa-BA.pdf
    2019-06-05 23:41:58.506172 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2785-Água Nova-RN.pdf
    2019-06-05 23:42:03.959019 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2767-Fortaleza dos Valos-RS.pdf
    2019-06-05 23:42:11.632027 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2817-Populina-SP.pdf
    2019-06-05 23:42:17.296594 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2867-Rodelas-BA.pdf
    2019-06-05 23:42:26.373206 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2787-São Sebastião do Oeste-MG.pdf
    2019-06-05 23:42:31.652812 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2863-Amajari-RR.pdf
    2019-06-05 23:42:46.960920 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2857-Xexéu-PE.pdf
    2019-06-05 23:43:13.764228 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2829-Santo Antônio do Jardim-SP.pdf
    2019-06-05 23:43:18.227386 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2791-Iporá-GO.pdf
    2019-06-05 23:43:25.130680 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2771-Ilha Solteira-SP.pdf
    2019-06-05 23:43:31.029259 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2769-Tapira-MG.pdf
    2019-06-05 23:43:39.280713 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2803-São Francisco de Assis do Piauí-PI.pdf
    2019-06-05 23:43:53.876952 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2833-Bacuri-MA.pdf
    2019-06-05 23:44:23.656311 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2875-Ribeirãozinho-MT.pdf
    2019-06-05 23:44:27.820070 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2873-Tupirama-TO.pdf
    2019-06-05 23:44:32.502499 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2841-Joanópolis-SP.pdf
    2019-06-05 23:44:38.672789 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2853-Luciára-MT.pdf
    2019-06-05 23:44:51.308937 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2851-Laranjeiras do Sul-PR.pdf
    2019-06-05 23:45:03.016952 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2805-Araguanã-MA.pdf
    2019-06-05 23:45:20.525542 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2773-Roteiro-AL.pdf
    2019-06-05 23:45:42.021265 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2765-Uraí-PR.pdf
    2019-06-05 23:45:48.146789 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2775-Flor do Sertão-SC.pdf
    2019-06-05 23:45:55.788010 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2819-Mirante da Serra-RO.pdf
    2019-06-05 23:46:14.743645 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2835-Olindina-BA.pdf
    2019-06-05 23:46:23.263321 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2779-Jaguaribara-CE.pdf
    2019-06-05 23:46:34.031991 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2799-Passa e Fica-RN.pdf
    2019-06-05 23:46:44.557339 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2809-Tejuçuoca-CE.pdf
    2019-06-05 23:46:52.297545 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2839-Castanhal-PA.pdf
    2019-06-05 23:47:02.130294 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2869-Pratápolis-MG.pdf
    2019-06-05 23:47:10.547136 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2797-Itaporanga d'Ajuda-SE.pdf
    2019-06-05 23:47:26.547569 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/3072-Piçarra-PA.pdf
    2019-06-05 23:47:34.483856 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2815-Araçoiaba-PE.pdf
    2019-06-05 23:47:56.382017 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2827-Aliança-PE.pdf
    2019-06-05 23:48:46.510151 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2861-Paraíso-SP.pdf
    2019-06-05 23:48:49.589306 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2801-Santa Rita do Pardo-MS.pdf
    2019-06-05 23:48:59.480722 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2957-Casa Nova-BA.pdf
    2019-06-05 23:49:07.407537 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2993-Perdigão-MG.pdf
    2019-06-05 23:49:12.167338 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3032-Terra Roxa-PR.pdf
    2019-06-05 23:49:16.483698 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2977-Guarani de Goiás-GO.pdf
    2019-06-05 23:49:31.443669 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3018-Limoeiro-PE.pdf
    2019-06-05 23:49:46.050505 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3042-Campo Bom-RS.pdf
    2019-06-05 23:49:55.583353 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3056-Capela-SE.pdf
    2019-06-05 23:50:14.954709 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2967-Abaiara-CE.pdf
    2019-06-05 23:50:26.977787 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3036-Martins-RN.pdf
    2019-06-05 23:50:39.959388 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3060-Bastos-SP.pdf
    2019-06-05 23:50:43.076573 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2953-Juruá-AM.pdf
    2019-06-05 23:50:51.844705 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2987-Formiga-MG.pdf
    2019-06-05 23:51:02.331576 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3058-Anhumas-SP.pdf
    2019-06-05 23:51:08.566421 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3012-Vigia-PA.pdf
    2019-06-05 23:51:16.436446 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3016-Picuí-PB.pdf
    2019-06-05 23:51:40.409832 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3044-Chiapetta-RS.pdf
    2019-06-05 23:51:52.687719 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3062-Fernandópolis-SP.pdf
    2019-06-05 23:51:55.542856 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2975-Presidente Kennedy-ES.pdf
    2019-06-05 23:52:03.282637 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2983-Brejo de Areia-MA.pdf
    2019-06-05 23:52:23.274830 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2955-Ferreira Gomes-AP.pdf
    2019-06-05 23:52:28.208368 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2981-São João d'Aliança-GO.pdf
    2019-06-05 23:52:32.692179 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3064-Itapecerica da Serra-SP.pdf
    2019-06-05 23:52:38.064626 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3022-Terezinha-PE.pdf
    2019-06-05 23:53:01.979666 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3040-Riacho de Santana-RN.pdf
    2019-06-05 23:53:08.702148 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2971-Crato-CE.pdf
    2019-06-05 23:53:21.151069 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3024-Dirceu Arcoverde-PI.pdf
    2019-06-05 23:53:43.005095 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3068-Pontal-SP.pdf
    2019-06-05 23:53:49.325650 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2951-Boca da Mata-AL.pdf
    2019-06-05 23:53:54.477181 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2973-Morrinhos-CE.pdf
    2019-06-05 23:54:07.566845 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2963-Itarantim-BA.pdf
    2019-06-05 23:54:13.448443 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3070-Araguatins-TO.pdf
    2019-06-05 23:54:18.330383 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2999-Várzea da Palma-MG.pdf
    2019-06-05 23:54:34.083599 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2961-Cipó-BA.pdf
    2019-06-05 23:54:42.586446 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2965-Maracás-BA.pdf
    2019-06-05 23:54:47.922663 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2991-Novorizonte-MG.pdf
    2019-06-05 23:54:53.122360 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3020-Palmares-PE.pdf
    2019-06-05 23:55:07.452047 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3008-Cachoeira do Arari-PA.pdf
    2019-06-05 23:55:17.920397 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3052-Mirim Doce-SC.pdf
    2019-06-05 23:55:23.331643 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2995-Rodeiro-MG.pdf
    2019-06-05 23:55:28.938038 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2979-Jaupaci-GO.pdf
    2019-06-05 23:55:35.611903 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2989-Monte Santo de Minas-MG.pdf
    2019-06-05 23:55:44.488003 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2985-Mata Roma-MA.pdf
    2019-06-05 23:56:09.489145 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3048-Ubiretama-RS.pdf
    2019-06-05 23:56:15.317533 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3010-Trairão-PA.pdf
    2019-06-05 23:56:35.797589 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2959-Catolândia-BA.pdf
    2019-06-05 23:56:42.511335 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3034-Iguaba Grande-RJ.pdf
    2019-06-05 23:56:55.404357 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3004-Gaúcha do Norte-MT.pdf
    2019-06-05 23:57:06.696307 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3001-Douradina-MS.pdf
    2019-06-05 23:57:12.373184 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3066-Mirassolândia-SP.pdf
    2019-06-05 23:57:16.702269 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2997-Vargem Bonita-MG.pdf
    2019-06-05 23:57:19.095692 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3054-Boquim-SE.pdf
    2019-06-05 23:57:26.308493 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3006-Nova Canaã do Norte-MT.pdf
    2019-06-05 23:57:39.356908 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2969-Aracoiaba-CE.pdf
    2019-06-05 23:58:05.966487 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3038-Paraná-RN.pdf
    2019-06-05 23:58:13.237800 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3014-Bananeiras-PB.pdf
    2019-06-05 23:59:01.719701 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3028-Ariranha do Ivaí-PR.pdf
    2019-06-05 23:59:07.491868 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3050-Araranguá-SC.pdf
    2019-06-05 23:59:12.349530 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3026-Manoel Emídio-PI.pdf
    2019-06-05 23:59:52.203677 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3046-Jaguari-RS.pdf
    2019-06-05 23:59:56.960287 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/3030-Lunardelli-PR.pdf
    2019-06-06 00:00:00.504382 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3176-Marapanim-PA.pdf
    2019-06-06 00:00:12.316296 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3138-Jijoca de Jericoacoara-CE.pdf
    2019-06-06 00:00:29.202626 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3146-Aurilândia-GO.pdf
    2019-06-06 00:00:38.327421 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3234-Pardinho-SP.pdf
    2019-06-06 00:00:42.992358 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3200-Petrópolis-RJ.pdf
    2019-06-06 00:00:54.336212 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3232-Lavínia-SP.pdf
    2019-06-06 00:00:58.483582 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3210-Coronel Pilar-RS.pdf
    2019-06-06 00:01:01.915686 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3218-Três Barras-SC.pdf
    2019-06-06 00:01:24.644676 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3190-Júlio Borges-PI.pdf
    2019-06-06 00:01:40.669969 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3192-São Miguel do Fidalgo-PI.pdf
    2019-06-06 00:01:48.362331 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3158-Coronel Murta-MG.pdf
    2019-06-06 00:02:01.260736 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3208-Alta Floresta D'Oeste-RO.pdf
    2019-06-06 00:02:19.697049 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3212-Encruzilhada do Sul-RS.pdf
    2019-06-06 00:02:36.262475 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3174-Nova Olímpia-MT.pdf
    2019-06-06 00:03:02.830902 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3150-Orizona-GO.pdf
    2019-06-06 00:03:25.848376 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3177-Nova Timboteua-PA.pdf
    2019-06-06 00:03:40.744772 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3204-Marcelino Vieira-RN.pdf
    2019-06-06 00:03:52.113926 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3179-São Domingos do Araguaia-PA.pdf
    2019-06-06 00:04:14.438363 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3160-Córrego Danta-MG.pdf
    2019-06-06 00:04:24.427625 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3222-Divina Pastora-SE.pdf
    2019-06-06 00:04:34.527149 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3180-Baía da Traição-PB.pdf
    2019-06-06 00:04:47.365200 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3152-Bela Vista do Maranhão-MA.pdf
    2019-06-06 00:05:06.720835 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3128-Botuporã-BA.pdf
    2019-06-06 00:05:25.249499 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3202-Apodi-RN.pdf
    2019-06-06 00:06:34.459163 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3236-Salto-SP.pdf
    2019-06-06 00:06:38.523376 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3140-Salitre-CE.pdf
    2019-06-06 00:07:12.210905 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3196-Iretama-PR.pdf
    2019-06-06 00:07:19.682945 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3226-Bom Sucesso de Itararé-SP.pdf
    2019-06-06 00:07:23.819652 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3198-Santa Mônica-PR.pdf
    2019-06-06 00:07:29.917609 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3238-São Valério da Natividade-TO.pdf
    2019-06-06 00:07:36.771172 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3216-São Luiz Gonzaga-RS.pdf
    2019-06-06 00:07:42.939543 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3188-Parnamirim-PE.pdf
    2019-06-06 00:08:19.256301 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3170-Camapuã-MS.pdf
    2019-06-06 00:08:39.167262 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3172-Juscimeira-MT.pdf
    2019-06-06 00:08:50.815283 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3130-Gentio do Ouro-BA.pdf
    2019-06-06 00:09:13.304245 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3182-Tavares-PB.pdf
    2019-06-06 00:09:50.101376 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3166-Rio do Prado-MG.pdf
    2019-06-06 00:09:59.381135 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3168-São Roque de Minas-MG.pdf
    2019-06-06 00:10:05.181916 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3164-Itacarambi-MG.pdf
    2019-06-06 00:10:29.521504 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3206-Ouro Branco-RN.pdf
    2019-06-06 00:10:37.888125 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3148-Campinaçu-GO.pdf
    2019-06-06 00:10:50.525066 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3220-Xavantina-SC.pdf
    2019-06-06 00:10:59.001244 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3136-Croatá-CE.pdf
    2019-06-06 00:11:22.536985 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3144-Cariacica-ES.pdf
    2019-06-06 00:11:44.612554 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3194-Bom Sucesso-PR.pdf
    2019-06-06 00:11:49.635998 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3124-Maribondo-AL.pdf
    2019-06-06 00:12:05.896525 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3224-Japaratuba-SE.pdf
    2019-06-06 00:12:18.604152 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3162-Guimarânia-MG.pdf
    2019-06-06 00:12:37.938737 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3132-Milagres-BA.pdf
    2019-06-06 00:14:05.144916 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3184-Camutanga-PE.pdf
    2019-06-06 00:14:26.278243 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3228-Borborema-SP.pdf
    2019-06-06 00:14:32.692069 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3230-Itaju-SP.pdf
    2019-06-06 00:14:35.825482 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3186-Jucati-PE.pdf
    2019-06-06 00:15:00.484986 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3154-Coelho Neto-MA.pdf
    2019-06-06 00:16:03.413163 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3126-Barra do Mendes-BA.pdf
    2019-06-06 00:16:38.660905 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3214-Porto Lucena-RS.pdf
    2019-06-06 00:17:01.035800 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3122-Marechal Thaumaturgo-AC.pdf
    2019-06-06 00:17:21.874991 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3142-Senador Pompeu-CE.pdf
    2019-06-06 00:17:45.511570 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3156-Caetanópolis-MG.pdf
    2019-06-06 00:17:57.804239 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3134-Mirangaba-BA.pdf
    2019-06-06 00:18:12.888887 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3382-General Maynard-SE.pdf
    2019-06-06 00:18:29.888139 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3376-Humaitá-AM.pdf
    2019-06-06 00:18:50.503581 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3384-Pancas-ES.pdf
    2019-06-06 00:19:00.288540 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3332-Boninal-BA.pdf
    2019-06-06 00:19:11.947010 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3415-Cachoeirinha-PE.pdf
    2019-06-06 00:19:36.498728 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3346-Nuporanga-SP.pdf
    2019-06-06 00:19:41.085018 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3324-Pinhalão-PR.pdf
    2019-06-06 00:20:04.764621 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3366-Itambacuri-MG.pdf
    2019-06-06 00:20:36.950945 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3436-Trombudo Central-SC.pdf
    2019-06-06 00:20:47.125743 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3425-Capitão de Campos-PI.pdf
    2019-06-06 00:21:06.386881 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3358-Tiros-MG.pdf
    2019-06-06 00:21:20.000287 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3380-Cristinápolis-SE.pdf
    2019-06-06 00:21:44.162026 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3388-Paripueira-AL.pdf
    2019-06-06 00:22:17.817966 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3362-Biquinhas-MG.pdf
    2019-06-06 00:22:24.625928 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3427-Simplício Mendes-PI.pdf
    2019-06-06 00:22:56.590139 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3354-Juquitiba-SP.pdf
    2019-06-06 00:23:12.324983 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3322-Nossa Senhora das Graças-PR.pdf
    2019-06-06 00:23:33.425699 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3390-Goianésia do Pará-PA.pdf
    2019-06-06 00:23:52.096025 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3336-Formigueiro-RS.pdf
    2019-06-06 00:24:05.032808 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3370-Matias Barbosa-MG.pdf
    2019-06-06 00:24:23.589442 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3423-Riachão do Bacamarte-PB.pdf
    2019-06-06 00:25:48.421418 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3413-Ferreiros-PE.pdf
    2019-06-06 00:26:19.723259 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3409-Ararendá-CE.pdf
    2019-06-06 00:26:42.651272 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3326-Antônio Cardoso-BA.pdf
    2019-06-06 00:27:03.452064 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3417-Presidente Médici-MA.pdf
    2019-06-06 00:27:25.685315 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3405-Chaval-CE.pdf
    2019-06-06 00:27:49.228075 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3356-Itajobi-SP.pdf
    2019-06-06 00:27:57.591660 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3429-Itajá-GO.pdf
    2019-06-06 00:28:08.330182 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3364-Jenipapo de Minas-MG.pdf
    2019-06-06 00:28:36.660024 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3372-Pedra Branca do Amaparí-AP.pdf
    2019-06-06 00:28:49.533486 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3392-Medicilândia-PA.pdf
    2019-06-06 00:29:18.117300 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3368-Canaã-MG.pdf
    2019-06-06 00:29:26.157426 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3438-Mondaí-SC.pdf
    2019-06-06 00:29:37.192820 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3374-Uiramutã-RR.pdf
    2019-06-06 00:29:54.888772 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3344-Vera Cruz-RS.pdf
    2019-06-06 00:30:09.960071 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3398-Caicó-RN.pdf
    2019-06-06 00:30:41.025876 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3340-Lagoa Bonita do Sul-RS.pdf
    2019-06-06 00:30:50.023867 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3403-Itapagé-CE.pdf
    2019-06-06 00:31:23.682858 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3386-Sete Quedas-MS.pdf
    2019-06-06 00:31:37.821913 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3433-Jaraguá-GO.pdf
    2019-06-06 00:31:54.136981 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3350-Paranapuã-SP.pdf
    2019-06-06 00:32:12.458951 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3328-Itamari-BA.pdf
    2019-06-06 00:32:36.719524 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3401-Severiano Melo-RN.pdf
    2019-06-06 00:32:49.941715 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3334-Vereda-BA.pdf
    2019-06-06 00:33:07.411537 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3435-Nova América-GO.pdf
    2019-06-06 00:33:13.995631 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3396-Nazaré-TO.pdf
    2019-06-06 00:33:19.149591 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3378-Miracema-RJ.pdf
    2019-06-06 00:33:38.050414 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3399-Nova Cruz-RN.pdf
    2019-06-06 00:34:02.325025 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3407-Martinópole-CE.pdf
    2019-06-06 00:34:30.918755 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3431-Americano do Brasil-GO.pdf
    2019-06-06 00:34:41.003357 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3342-São João do Polêsine-RS.pdf
    2019-06-06 00:34:46.207063 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3360-Josenópolis-MG.pdf
    2019-06-06 00:35:00.122170 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3352-Lupércio-SP.pdf
    2019-06-06 00:35:10.477392 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3330-Curaçá-BA.pdf
    2019-06-06 00:35:40.857449 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3394-Porto dos Gaúchos-MT.pdf
    2019-06-06 00:35:56.543674 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3421-Imaculada-PB.pdf
    2019-06-06 00:36:27.258210 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3411-Afogados da Ingazeira-PE.pdf
    2019-06-06 00:37:13.559223 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3419-Maranhãozinho-MA.pdf
    2019-06-06 00:38:17.389067 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3320-Rio Branco do Ivaí-PR.pdf
    2019-06-06 00:38:27.770484 ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3348-Guaraci-SP.pdf



```python
os.remove("temp_report.txt")
```


```python
cities.to_csv("../target_feature/01_target_feature.csv",
              sep=';',
              encoding='utf-8',
              index=False)
```