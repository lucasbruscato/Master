
# Rename Folders


```python
import os
import os.path
import random
```

### Create list of folders to access and rename files


```python
folders = ["2000/education",
           "2000/family",
           "2000/fertility",
           "2000/social_indicator",
           "2000/work",
           "2010/education",
           "2010/family",
           "2010/fertility",
           "2010/social_indicator",
           "2010/work"]

state_acronym_and_name_list = [
    ["ac", "acre"],
    ["al", "alagoas"],
    ["ap", "amapa"],
    ["am", "amazonas"],
    ["ba", "bahia"],
    ["ce", "ceara"],
    ["df", "distrito_federal"],
    ["es", "espirito_santo"],
    ["go", "goias"],
    ["ma", "maranhao"],
    ["mt", "mato_grosso"],
    ["ms", "mato_grosso_do_sul"],
    ["mg", "minas_gerais"],
    ["pa", "para"],
    ["pb", "paraiba"],
    ["pr", "parana"],
    ["pe", "pernambuco"],
    ["pi", "piaui"],
    ["rj", "rio_de_janeiro"],
    ["rn", "rio_grande_do_norte"],
    ["rs", "rio_grande_do_sul"],
    ["ro", "rondonia"],
    ["rr", "roraima"],
    ["sc", "santa_catarina"],
    ["sp", "sao_paulo"],
    ["se", "sergipe"],
    ["to", "tocantins"]]
```

### Rename files based on pattern


```python
for folder in folders:
    print(folder)
    for inner_folder in os.listdir(folder):
        new_folder_name = inner_folder
        for acronym in state_acronym_and_name_list:
            if inner_folder == acronym[0]:
                new_folder_name = acronym[1]
                break
        new_folder_name = str.replace(new_folder_name, "_munic_xls", "")
        new_folder_name = str.replace(new_folder_name, "_xls", "")
        
        print(folder + "/" + inner_folder + " -> " + folder + "/" + new_folder_name)
        
        os.rename(folder + "/" + inner_folder,
                  folder + "/" + new_folder_name)

```

    2000/education
    2000/education/se -> 2000/education/sergipe
    2000/education/sp -> 2000/education/sao_paulo
    2000/education/sc -> 2000/education/santa_catarina
    2000/education/pe -> 2000/education/pernambuco
    2000/education/pb -> 2000/education/paraiba
    2000/education/ms -> 2000/education/mato_grosso_do_sul
    2000/education/mt -> 2000/education/mato_grosso
    2000/education/go -> 2000/education/goias
    2000/education/.DS_Store -> 2000/education/.DS_Store
    2000/education/ac -> 2000/education/acre
    2000/education/am -> 2000/education/amazonas
    2000/education/ma -> 2000/education/maranhao
    2000/education/df -> 2000/education/distrito_federal
    2000/education/ap -> 2000/education/amapa
    2000/education/al -> 2000/education/alagoas
    2000/education/mg -> 2000/education/minas_gerais
    2000/education/rr -> 2000/education/roraima
    2000/education/rn -> 2000/education/rio_grande_do_norte
    2000/education/rs -> 2000/education/rio_grande_do_sul
    2000/education/ro -> 2000/education/rondonia
    2000/education/pr -> 2000/education/parana
    2000/education/pi -> 2000/education/piaui
    2000/education/pa -> 2000/education/para
    2000/education/ba -> 2000/education/bahia
    2000/education/es -> 2000/education/espirito_santo
    2000/education/ce -> 2000/education/ceara
    2000/education/rj -> 2000/education/rio_de_janeiro
    2000/education/to -> 2000/education/tocantins
    2000/family
    2000/family/se -> 2000/family/sergipe
    2000/family/sp -> 2000/family/sao_paulo
    2000/family/sc -> 2000/family/santa_catarina
    2000/family/pe -> 2000/family/pernambuco
    2000/family/pb -> 2000/family/paraiba
    2000/family/ms -> 2000/family/mato_grosso_do_sul
    2000/family/mt -> 2000/family/mato_grosso
    2000/family/go -> 2000/family/goias
    2000/family/ac -> 2000/family/acre
    2000/family/am -> 2000/family/amazonas
    2000/family/ma -> 2000/family/maranhao
    2000/family/df -> 2000/family/distrito_federal
    2000/family/ap -> 2000/family/amapa
    2000/family/al -> 2000/family/alagoas
    2000/family/mg -> 2000/family/minas_gerais
    2000/family/rr -> 2000/family/roraima
    2000/family/rn -> 2000/family/rio_grande_do_norte
    2000/family/rs -> 2000/family/rio_grande_do_sul
    2000/family/ro -> 2000/family/rondonia
    2000/family/pr -> 2000/family/parana
    2000/family/pi -> 2000/family/piaui
    2000/family/pa -> 2000/family/para
    2000/family/ba -> 2000/family/bahia
    2000/family/es -> 2000/family/espirito_santo
    2000/family/ce -> 2000/family/ceara
    2000/family/rj -> 2000/family/rio_de_janeiro
    2000/family/to -> 2000/family/tocantins
    2000/fertility
    2000/fertility/se -> 2000/fertility/sergipe
    2000/fertility/sp -> 2000/fertility/sao_paulo
    2000/fertility/sc -> 2000/fertility/santa_catarina
    2000/fertility/pe -> 2000/fertility/pernambuco
    2000/fertility/pb -> 2000/fertility/paraiba
    2000/fertility/ms -> 2000/fertility/mato_grosso_do_sul
    2000/fertility/mt -> 2000/fertility/mato_grosso
    2000/fertility/go -> 2000/fertility/goias
    2000/fertility/ac -> 2000/fertility/acre
    2000/fertility/am -> 2000/fertility/amazonas
    2000/fertility/ma -> 2000/fertility/maranhao
    2000/fertility/df -> 2000/fertility/distrito_federal
    2000/fertility/ap -> 2000/fertility/amapa
    2000/fertility/al -> 2000/fertility/alagoas
    2000/fertility/mg -> 2000/fertility/minas_gerais
    2000/fertility/rr -> 2000/fertility/roraima
    2000/fertility/rn -> 2000/fertility/rio_grande_do_norte
    2000/fertility/rs -> 2000/fertility/rio_grande_do_sul
    2000/fertility/ro -> 2000/fertility/rondonia
    2000/fertility/pr -> 2000/fertility/parana
    2000/fertility/pi -> 2000/fertility/piaui
    2000/fertility/pa -> 2000/fertility/para
    2000/fertility/ba -> 2000/fertility/bahia
    2000/fertility/es -> 2000/fertility/espirito_santo
    2000/fertility/ce -> 2000/fertility/ceara
    2000/fertility/rj -> 2000/fertility/rio_de_janeiro
    2000/fertility/to -> 2000/fertility/tocantins
    2000/social_indicator
    2000/social_indicator/se -> 2000/social_indicator/sergipe
    2000/social_indicator/sp -> 2000/social_indicator/sao_paulo
    2000/social_indicator/sc -> 2000/social_indicator/santa_catarina
    2000/social_indicator/pe -> 2000/social_indicator/pernambuco
    2000/social_indicator/pb -> 2000/social_indicator/paraiba
    2000/social_indicator/ms -> 2000/social_indicator/mato_grosso_do_sul
    2000/social_indicator/mt -> 2000/social_indicator/mato_grosso
    2000/social_indicator/go -> 2000/social_indicator/goias
    2000/social_indicator/ac -> 2000/social_indicator/acre
    2000/social_indicator/am -> 2000/social_indicator/amazonas
    2000/social_indicator/ma -> 2000/social_indicator/maranhao
    2000/social_indicator/df -> 2000/social_indicator/distrito_federal
    2000/social_indicator/ap -> 2000/social_indicator/amapa
    2000/social_indicator/al -> 2000/social_indicator/alagoas
    2000/social_indicator/mg -> 2000/social_indicator/minas_gerais
    2000/social_indicator/rr -> 2000/social_indicator/roraima
    2000/social_indicator/rn -> 2000/social_indicator/rio_grande_do_norte
    2000/social_indicator/rs -> 2000/social_indicator/rio_grande_do_sul
    2000/social_indicator/ro -> 2000/social_indicator/rondonia
    2000/social_indicator/pr -> 2000/social_indicator/parana
    2000/social_indicator/pi -> 2000/social_indicator/piaui
    2000/social_indicator/pa -> 2000/social_indicator/para
    2000/social_indicator/ba -> 2000/social_indicator/bahia
    2000/social_indicator/es -> 2000/social_indicator/espirito_santo
    2000/social_indicator/ce -> 2000/social_indicator/ceara
    2000/social_indicator/rj -> 2000/social_indicator/rio_de_janeiro
    2000/social_indicator/to -> 2000/social_indicator/tocantins
    2000/work
    2000/work/se -> 2000/work/sergipe
    2000/work/sp -> 2000/work/sao_paulo
    2000/work/sc -> 2000/work/santa_catarina
    2000/work/pe -> 2000/work/pernambuco
    2000/work/pb -> 2000/work/paraiba
    2000/work/ms -> 2000/work/mato_grosso_do_sul
    2000/work/mt -> 2000/work/mato_grosso
    2000/work/go -> 2000/work/goias
    2000/work/ac -> 2000/work/acre
    2000/work/am -> 2000/work/amazonas
    2000/work/ma -> 2000/work/maranhao
    2000/work/df -> 2000/work/distrito_federal
    2000/work/ap -> 2000/work/amapa
    2000/work/al -> 2000/work/alagoas
    2000/work/mg -> 2000/work/minas_gerais
    2000/work/rr -> 2000/work/roraima
    2000/work/rn -> 2000/work/rio_grande_do_norte
    2000/work/rs -> 2000/work/rio_grande_do_sul
    2000/work/ro -> 2000/work/rondonia
    2000/work/pr -> 2000/work/parana
    2000/work/pi -> 2000/work/piaui
    2000/work/pa -> 2000/work/para
    2000/work/ba -> 2000/work/bahia
    2000/work/es -> 2000/work/espirito_santo
    2000/work/ce -> 2000/work/ceara
    2000/work/rj -> 2000/work/rio_de_janeiro
    2000/work/to -> 2000/work/tocantins
    2010/education
    2010/education/santa_catarina_munic_xls -> 2010/education/santa_catarina
    2010/education/tocantins_munic_xls -> 2010/education/tocantins
    2010/education/rondonia_munic_xls -> 2010/education/rondonia
    2010/education/sao_paulo_munic_xls -> 2010/education/sao_paulo
    2010/education/paraiba_munic_xls -> 2010/education/paraiba
    2010/education/mato_grosso_do_sul_munic_xls -> 2010/education/mato_grosso_do_sul
    2010/education/bahia_munic_xls -> 2010/education/bahia
    2010/education/amapa_munic_xls -> 2010/education/amapa
    2010/education/ceara_munic_xls -> 2010/education/ceara
    2010/education/piaui_munic_xls -> 2010/education/piaui
    2010/education/acre_munic_xls -> 2010/education/acre
    2010/education/rio_grande_do_norte_munic_xls -> 2010/education/rio_grande_do_norte
    2010/education/roraima_munic_xls -> 2010/education/roraima
    2010/education/rio_de_janeiro_munic_xls -> 2010/education/rio_de_janeiro
    2010/education/para_munic_xls -> 2010/education/para
    2010/education/pernambuco_munic_xls -> 2010/education/pernambuco
    2010/education/parana_munic_xls -> 2010/education/parana
    2010/education/rio_grande_do_sul_munic_xls -> 2010/education/rio_grande_do_sul
    2010/education/maranhao_munic_xls -> 2010/education/maranhao
    2010/education/amazonas_munic_xls -> 2010/education/amazonas
    2010/education/alagoas_munic_xls -> 2010/education/alagoas
    2010/education/goias_munic_xls -> 2010/education/goias
    2010/education/minas_gerais_munic_xls -> 2010/education/minas_gerais
    2010/education/mato_grosso_do_munic_xls -> 2010/education/mato_grosso_do
    2010/education/distrito_federal_munic_xls -> 2010/education/distrito_federal
    2010/education/espirito_santo_munic_xls -> 2010/education/espirito_santo
    2010/education/sergipe_munic_xls -> 2010/education/sergipe
    2010/family
    2010/family/maranhao_xls -> 2010/family/maranhao
    2010/family/rio_de_janeiro_xls -> 2010/family/rio_de_janeiro
    2010/family/distrito_federal_xls -> 2010/family/distrito_federal
    2010/family/santa_catarina_xls -> 2010/family/santa_catarina
    2010/family/rio_grande_do_norte_xls -> 2010/family/rio_grande_do_norte
    2010/family/amazonas_xls -> 2010/family/amazonas
    2010/family/tocantins_xls -> 2010/family/tocantins
    2010/family/espirito_santo_xls -> 2010/family/espirito_santo
    2010/family/goias_xls -> 2010/family/goias
    2010/family/rio_grande_do_sul_xls -> 2010/family/rio_grande_do_sul
    2010/family/ceara_xls -> 2010/family/ceara
    2010/family/piaui_xls -> 2010/family/piaui
    2010/family/sergipe_xls -> 2010/family/sergipe
    2010/family/parana_xls -> 2010/family/parana
    2010/family/paraiba_xls -> 2010/family/paraiba
    2010/family/para_xls -> 2010/family/para
    2010/family/minas_gerais_xls -> 2010/family/minas_gerais
    2010/family/bahia_xls -> 2010/family/bahia
    2010/family/mato_grosso_do_sul_xls -> 2010/family/mato_grosso_do_sul
    2010/family/amapa_xls -> 2010/family/amapa
    2010/family/acre_xls -> 2010/family/acre
    2010/family/alagoas_xls -> 2010/family/alagoas
    2010/family/mato_grosso_xls -> 2010/family/mato_grosso
    2010/family/roraima_xls -> 2010/family/roraima
    2010/family/rondonia_xls -> 2010/family/rondonia
    2010/family/pernambuco_xls -> 2010/family/pernambuco
    2010/family/sao_paulo_xls -> 2010/family/sao_paulo
    2010/fertility
    2010/fertility/minas_gerais -> 2010/fertility/minas_gerais
    2010/fertility/mato_grosso -> 2010/fertility/mato_grosso
    2010/fertility/rio_de_janeiro -> 2010/fertility/rio_de_janeiro
    2010/fertility/paraiba -> 2010/fertility/paraiba
    2010/fertility/santa_catarina -> 2010/fertility/santa_catarina
    2010/fertility/piaui -> 2010/fertility/piaui
    2010/fertility/espirito_santo -> 2010/fertility/espirito_santo
    2010/fertility/amazonas -> 2010/fertility/amazonas
    2010/fertility/mato_grosso_do_sul -> 2010/fertility/mato_grosso_do_sul
    2010/fertility/rondonia -> 2010/fertility/rondonia
    2010/fertility/tocantins -> 2010/fertility/tocantins
    2010/fertility/sao_paulo -> 2010/fertility/sao_paulo
    2010/fertility/roraima -> 2010/fertility/roraima
    2010/fertility/acre -> 2010/fertility/acre
    2010/fertility/rio_grande_do_norte -> 2010/fertility/rio_grande_do_norte
    2010/fertility/amapa -> 2010/fertility/amapa
    2010/fertility/alagoas -> 2010/fertility/alagoas
    2010/fertility/bahia -> 2010/fertility/bahia
    2010/fertility/rio_grande_do_sul -> 2010/fertility/rio_grande_do_sul
    2010/fertility/sergipe -> 2010/fertility/sergipe
    2010/fertility/parana -> 2010/fertility/parana
    2010/fertility/para -> 2010/fertility/para
    2010/fertility/pernambuco -> 2010/fertility/pernambuco
    2010/fertility/maranhao -> 2010/fertility/maranhao
    2010/fertility/goias -> 2010/fertility/goias
    2010/fertility/distrito_federal -> 2010/fertility/distrito_federal
    2010/fertility/ceara -> 2010/fertility/ceara
    2010/social_indicator
    2010/social_indicator/minas_gerais -> 2010/social_indicator/minas_gerais
    2010/social_indicator/mato_grosso -> 2010/social_indicator/mato_grosso
    2010/social_indicator/rio_de_janeiro -> 2010/social_indicator/rio_de_janeiro
    2010/social_indicator/paraiba -> 2010/social_indicator/paraiba
    2010/social_indicator/santa_catarina -> 2010/social_indicator/santa_catarina
    2010/social_indicator/piaui -> 2010/social_indicator/piaui
    2010/social_indicator/espirito_santo -> 2010/social_indicator/espirito_santo
    2010/social_indicator/amazonas -> 2010/social_indicator/amazonas
    2010/social_indicator/mato_grosso_do_sul -> 2010/social_indicator/mato_grosso_do_sul
    2010/social_indicator/rondonia -> 2010/social_indicator/rondonia
    2010/social_indicator/tocantins -> 2010/social_indicator/tocantins
    2010/social_indicator/sao_paulo -> 2010/social_indicator/sao_paulo
    2010/social_indicator/roraima -> 2010/social_indicator/roraima
    2010/social_indicator/acre -> 2010/social_indicator/acre
    2010/social_indicator/rio_grande_do_norte -> 2010/social_indicator/rio_grande_do_norte
    2010/social_indicator/amapa -> 2010/social_indicator/amapa
    2010/social_indicator/alagoas -> 2010/social_indicator/alagoas
    2010/social_indicator/bahia -> 2010/social_indicator/bahia
    2010/social_indicator/rio_grande_do_sul -> 2010/social_indicator/rio_grande_do_sul
    2010/social_indicator/sergipe -> 2010/social_indicator/sergipe
    2010/social_indicator/parana -> 2010/social_indicator/parana
    2010/social_indicator/para -> 2010/social_indicator/para
    2010/social_indicator/pernambuco -> 2010/social_indicator/pernambuco
    2010/social_indicator/maranhao -> 2010/social_indicator/maranhao
    2010/social_indicator/goias -> 2010/social_indicator/goias
    2010/social_indicator/ceara -> 2010/social_indicator/ceara
    2010/work
    2010/work/santa_catarina_munic_xls -> 2010/work/santa_catarina
    2010/work/tocantins_munic_xls -> 2010/work/tocantins
    2010/work/rondonia_munic_xls -> 2010/work/rondonia
    2010/work/sao_paulo_munic_xls -> 2010/work/sao_paulo
    2010/work/paraiba_munic_xls -> 2010/work/paraiba
    2010/work/mato_grosso_do_sul_munic_xls -> 2010/work/mato_grosso_do_sul
    2010/work/mato_grosso_munic_xls -> 2010/work/mato_grosso
    2010/work/bahia_munic_xls -> 2010/work/bahia
    2010/work/amapa_munic_xls -> 2010/work/amapa
    2010/work/ceara_munic_xls -> 2010/work/ceara
    2010/work/piaui_munic_xls -> 2010/work/piaui
    2010/work/acre_munic_xls -> 2010/work/acre
    2010/work/rio_grande_do_norte_munic_xls -> 2010/work/rio_grande_do_norte
    2010/work/roraima_munic_xls -> 2010/work/roraima
    2010/work/rio_de_janeiro_munic_xls -> 2010/work/rio_de_janeiro
    2010/work/para_munic_xls -> 2010/work/para
    2010/work/pernambuco_munic_xls -> 2010/work/pernambuco
    2010/work/parana_munic_xls -> 2010/work/parana
    2010/work/rio_grande_do_sul_munic_xls -> 2010/work/rio_grande_do_sul
    2010/work/maranhao_munic_xls -> 2010/work/maranhao
    2010/work/amazonas_munic_xls -> 2010/work/amazonas
    2010/work/alagoas_munic_xls -> 2010/work/alagoas
    2010/work/goias_munic_xls -> 2010/work/goias
    2010/work/minas_gerais_munic_xls -> 2010/work/minas_gerais
    2010/work/distrito_federal_munic_xls -> 2010/work/distrito_federal
    2010/work/espirito_santo_munic_xls -> 2010/work/espirito_santo
    2010/work/sergipe_munic_xls -> 2010/work/sergipe

