
# Import reports


```python
from selenium import webdriver
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile

import os
import time
import codecs
```

### Set configurations (only for 'edicoes_anteriores', others are manually)


```python
# set driver for browser connection
DRIVER_BIN = "/Users/lucas.bruscato/Google Drive/Github-Lucas/master/0_drivers/geckodriver_mac"
# DRIVER_BIN = "C:\\Users\\lbruscato\\Dropbox\\Github-Lucas\\master\\drivers\\geckodriver_windows.exe"

# set initial folder
folder = 'edicoes_anteriores/<folder name here>'
```

### Capture search dates and cities' names


```python
# open link file for the chosen folder
link_file = codecs.open(os.getcwd() + "/" + folder + "/link.txt", 'r', "utf-8")
text_link_file = link_file.read().split('\n')

# create the initial and final date to search
initial_date = (text_link_file[1].split('-'))[0]
final_date = (text_link_file[1].split('-'))[1]

# create an empty list of cities
cities = []

# fill cities list
for i in range(2, len(text_link_file)):
    city = text_link_file[i].split('-')
    cities.append(city[1].strip())

print("initial_date = " + initial_date)
print("final_date = " + final_date)
print(cities)
```

    initialDate = 01/01/2015
    finalDate = 31/12/2015
    ['Rio Branco do Ivaí', 'Nossa Senhora das Graças', 'Pinhalão', 'Antônio Cardoso', 'Itamari', 'Curaçá', 'Boninau', 'Vereda', 'Formigueiro', 'Lagoa Bonita do Sul', 'São João do Polêsine', 'Vera Cruz', 'Nuporanga', 'Guaraci', 'Paranapuã', 'Lupércio', 'Juquitiba', 'Itajobi', 'Tiros', 'Josenópolis', 'Biquinhas', 'Jenipapo de Minas', 'Itambacuri', 'Canaã', 'Matias Barbosa', 'Pedra Branca do Amapari', 'Uiramutã', 'Humaitá', 'Miracema', 'Cristinápolis', 'General Maynard', 'Pancas', 'Sete Quedas', 'Paripueira – AL', 'Goianésia do Pará', 'Medicilândia', 'Porto dos Gaúchos', 'Nazaré', 'Caicó', 'Nova Cruz', 'Severiano Melo', 'Itapagé', 'Chaval', 'Martinópole', 'Ararendá', 'Afogados da Ingazeira', 'Ferreiros', 'Cachoeirinha', 'Presidente Médici', 'Maranhãozinho', 'Imaculada', 'Riachão do Bacamarte', 'Capitão de Campos', 'Simplício Mendes', 'Itajá', 'Americano do Brasil', 'Jaraguá', 'Nova América', 'Trombudo Central', 'Mondaí']


### Open browser and download all cities' report


```python
# set browser preferences and profile (auto download)
profile = FirefoxProfile()
profile.set_preference('browser.helperApps.neverAsk.saveToDisk', "application/pdf,application/zip")
profile.set_preference('browser.download.folderList', 2)
profile.set_preference('browser.download.dir', os.getcwd() + "/" + folder)

# open browser
browser = webdriver.Firefox(executable_path = DRIVER_BIN, firefox_profile = profile)
browser.maximize_window()

for j in range(0, len(cities), 5):
    browser.get('https://auditoria.cgu.gov.br/')
    
    # fill fields
    Select(browser.find_element_by_id("linhaAtuacao")).select_by_visible_text('Fiscalização em Entes Federativos - Municípios')

    browser.find_element_by_id("de").send_keys(initialDate, Keys.TAB)
    browser.find_element_by_id("ate").send_keys(finalDate, Keys.TAB)
    
    for i in range(j, j + 5):
        if (i < len(cities)):
            browser.find_element_by_id("palavraChave").send_keys(cities[i], Keys.COMMAND, 'a')
            browser.find_element_by_id("palavraChave").send_keys(Keys.COMMAND, 'x')
            browser.find_element_by_id("token-input-municipios").send_keys(Keys.COMMAND, 'v')
            time.sleep(2)
            
            browser.find_element_by_id("token-input-municipios").send_keys(Keys.ENTER)
            time.sleep(1)
    
    # search and download files
    browser.find_element_by_id("btnPesquisar").click()
    time.sleep(2)
    
    browser.find_element_by_id("btnSelectAll").click()
    time.sleep(1)
    
    browser.find_element_by_id("btnBaixar").click()
    time.sleep(1)

```