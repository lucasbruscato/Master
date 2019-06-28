
# Create Initial SentiLex Database and Improve it


```python
import csv
import pandas as pd
import os
import os.path
import random
import PyPDF2
import unidecode
import pandas as pd
from collections import Counter
import csv
```

### Read SentiLex-PT02 and extract polarity


```python
# read csv file
sentilex_database = pd.read_csv("SentiLex-flex-PT02.txt", header = None)
sentilex_database.columns = ["adjective", "description"]

# extract "polarity" from "description"
polarity = pd.DataFrame(sentilex_database.description.str.split('\;+').str[3].str.split('\=+').str[1])
sentilex_database = pd.concat([sentilex_database, polarity], axis = 1, join = 'outer')

# remove duplicates
sentilex_database = sentilex_database.iloc[:, [0, 2]].drop_duplicates()
sentilex_database.columns = ["adjective", "polarity"]

# select only polarities in [-1, 0, 1]
polarities = ["-1", "0", "1"]
sentilex_database = sentilex_database[sentilex_database.polarity.isin(polarities)]
```


```python
sentilex_database.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>adjective</th>
      <th>polarity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>à-vontade</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>abafada</td>
      <td>-1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>abafadas</td>
      <td>-1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>abafado</td>
      <td>-1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>abafados</td>
      <td>-1</td>
    </tr>
  </tbody>
</table>
</div>



### Save initial sentilex database


```python
sentilex_database.to_csv("99_01_sentilex_database.csv",
                         sep = ';',
                         encoding = 'utf-8',
                         index = False)
```

### Define randomly reports for improving SentiLex-PT02


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

file_names_and_paths = []

for folder in folders:
    directory = '../programa_de_fiscalizacao_em_entes_federativos/' + folder
    
    number_of_files = len([name for name in os.listdir(directory) if os.path.isfile(os.path.join(directory, name))]) - 3
    random.seed(7)
    random_file_number = int(random.uniform(0, number_of_files))
    
    file_name_and_path = directory + "/" + os.listdir(directory)[random_file_number]
    file_names_and_paths.append(file_name_and_path)
    
file_names_and_paths
```




    ['../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9044-Putinga-RS.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10321-Uruguaiana-RS.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12311-Teresópolis-RJ.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1837-São Mateus-ES.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1906-Patrocínio-MG.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2483-Pontal do Paraná-PR.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2871-São José do Sul-RS.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2975-Presidente Kennedy-ES.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3179-São Domingos do Araguaia-PA.pdf',
     '../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3390-Goianésia do Pará-PA.pdf']



### Import reports, collect unique words and save words not in SentiLex-PT02


```python
print("List of reports read to improve SentiLex database")

words_without_polarity_full = pd.DataFrame(columns=['adjective', 'polarity'])

for file_number in range(0, len(file_names_and_paths)):
    
    file_name = file_names_and_paths[file_number]
    print(file_name)
    
    # create a pdf object
    file = open(file_name, 'rb')
    
    # create a pdf reader object
    file_reader = PyPDF2.PdfFileReader(file)

    # iterate all documents
    word_index = -1
    flag_in_a_word = 0
    words = []

    for i in range(file_reader.numPages):
        page = unidecode.unidecode(file_reader.getPage(i).extractText().lower())

        for j in range(len(page)):
            letter = page[j]

            if (not letter.isalpha()) and flag_in_a_word != 0:
                flag_in_a_word = 0
            elif letter.isalpha() and flag_in_a_word == 0:
                flag_in_a_word = 1
                word_index += 1
                words.append(letter)
            elif letter.isalpha() and flag_in_a_word != 0:
                words[word_index] += letter

    words_unique = pd.DataFrame(pd.DataFrame(words).iloc[:, 0].unique())
    words_unique.columns = ["adjective"]
    
    words_with_polarity = words_unique.merge(sentilex_database,
                                             left_on="adjective",
                                             right_on="adjective",
                                             how="left")
    
    words_without_polarity_full = pd.concat([words_without_polarity_full,
                                             words_with_polarity[words_with_polarity.polarity.isnull()]])


words_without_polarity_full = pd.DataFrame(words_without_polarity_full.adjective.unique())
words_without_polarity_full.columns = ['adjective']
words_without_polarity_full['polarity'] = ''

words_without_polarity_full.sort_values(by=['adjective'], inplace=True)

words_without_polarity_full.to_csv("improving_sentilex/99_create_improving_sentilex.csv",
                                   sep=';',
                                   encoding='utf-8',
                                   index=False)
```

    List of reports read to improve SentiLex database
    ../programa_de_fiscalizacao_em_entes_federativos/ciclo_3/9044-Putinga-RS.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/ciclo_4/10321-Uruguaiana-RS.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/ciclo_5/12311-Teresópolis-RJ.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_34/1837-São Mateus-ES.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_35/1906-Patrocínio-MG.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_36/2483-Pontal do Paraná-PR.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_37/2871-São José do Sul-RS.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_38/2975-Presidente Kennedy-ES.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_39/3179-São Domingos do Araguaia-PA.pdf
    ../programa_de_fiscalizacao_em_entes_federativos/edicoes_anteriores/sorteio_40/3390-Goianésia do Pará-PA.pdf
