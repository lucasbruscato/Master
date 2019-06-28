
# Data Processing


```python
import pandas as pd
import os
```

### Read and handle target feature


```python
target_feature = pd.read_csv('../target_feature/01_target_feature.csv',
                             sep=';')
```


```python
target_feature.head()
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
      <th>folder</th>
      <th>file_name</th>
      <th>number_of_words</th>
      <th>pct_pol_neg</th>
      <th>pct_pol_pos</th>
      <th>pct_pol_neu</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>ciclo_3</td>
      <td>8998-Santo Antônio de Jesus-BA.pdf</td>
      <td>45543</td>
      <td>0.015063</td>
      <td>0.032302</td>
      <td>0.954087</td>
    </tr>
    <tr>
      <th>1</th>
      <td>ciclo_3</td>
      <td>9024-Ulianópolis-PA.pdf</td>
      <td>17432</td>
      <td>0.018945</td>
      <td>0.022160</td>
      <td>0.959642</td>
    </tr>
    <tr>
      <th>2</th>
      <td>ciclo_3</td>
      <td>9010-Aldeias Altas-MA.pdf</td>
      <td>59605</td>
      <td>0.022763</td>
      <td>0.024140</td>
      <td>0.954407</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ciclo_3</td>
      <td>9034-Paraíba do Sul-RJ.pdf</td>
      <td>15486</td>
      <td>0.014342</td>
      <td>0.029007</td>
      <td>0.957103</td>
    </tr>
    <tr>
      <th>4</th>
      <td>ciclo_3</td>
      <td>9045-Governador Celso Ramos-SC.pdf</td>
      <td>5177</td>
      <td>0.011985</td>
      <td>0.025130</td>
      <td>0.963657</td>
    </tr>
  </tbody>
</table>
</div>




```python
target_feature['temp'] = target_feature['file_name'].str.replace('[0-9]|.pdf|-', ' ', regex=True)\
    .str.normalize('NFKD').str.encode('ascii', errors='ignore').str.decode('utf-8').str.lower().str.strip()
target_feature['city'] = target_feature['temp'].str[:-3]
target_feature['state'] = target_feature['temp'].str[-2:]
target_feature['city_state'] = target_feature['city'].map(str) + '_' + target_feature['state']

target_feature = target_feature.drop("temp", axis=1)
target_feature.head()
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
      <th>folder</th>
      <th>file_name</th>
      <th>number_of_words</th>
      <th>pct_pol_neg</th>
      <th>pct_pol_pos</th>
      <th>pct_pol_neu</th>
      <th>city</th>
      <th>state</th>
      <th>city_state</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>ciclo_3</td>
      <td>8998-Santo Antônio de Jesus-BA.pdf</td>
      <td>45543</td>
      <td>0.015063</td>
      <td>0.032302</td>
      <td>0.954087</td>
      <td>santo antonio de jesus</td>
      <td>ba</td>
      <td>santo antonio de jesus_ba</td>
    </tr>
    <tr>
      <th>1</th>
      <td>ciclo_3</td>
      <td>9024-Ulianópolis-PA.pdf</td>
      <td>17432</td>
      <td>0.018945</td>
      <td>0.022160</td>
      <td>0.959642</td>
      <td>ulianopolis</td>
      <td>pa</td>
      <td>ulianopolis_pa</td>
    </tr>
    <tr>
      <th>2</th>
      <td>ciclo_3</td>
      <td>9010-Aldeias Altas-MA.pdf</td>
      <td>59605</td>
      <td>0.022763</td>
      <td>0.024140</td>
      <td>0.954407</td>
      <td>aldeias altas</td>
      <td>ma</td>
      <td>aldeias altas_ma</td>
    </tr>
    <tr>
      <th>3</th>
      <td>ciclo_3</td>
      <td>9034-Paraíba do Sul-RJ.pdf</td>
      <td>15486</td>
      <td>0.014342</td>
      <td>0.029007</td>
      <td>0.957103</td>
      <td>paraiba do sul</td>
      <td>rj</td>
      <td>paraiba do sul_rj</td>
    </tr>
    <tr>
      <th>4</th>
      <td>ciclo_3</td>
      <td>9045-Governador Celso Ramos-SC.pdf</td>
      <td>5177</td>
      <td>0.011985</td>
      <td>0.025130</td>
      <td>0.963657</td>
      <td>governador celso ramos</td>
      <td>sc</td>
      <td>governador celso ramos_sc</td>
    </tr>
  </tbody>
</table>
</div>



### Read explanatory features: education, family, fertility and work (2000 and 2010)


```python
raw_dataset = target_feature
```


```python
state_name_to_acronym = pd.DataFrame({'full_state_name': 
                                      ['acre', 
                                       'alagoas', 
                                       'amapa', 
                                       'amazonas', 
                                       'bahia', 
                                       'ceara', 
                                       'distrito_federal', 
                                       'espirito_santo', 
                                       'goias', 
                                       'maranhao', 
                                       'mato_grosso', 
                                       'mato_grosso_do_sul', 
                                       'minas_gerais', 
                                       'para', 
                                       'paraiba', 
                                       'parana', 
                                       'pernambuco', 
                                       'piaui', 
                                       'rio_de_janeiro', 
                                       'rio_grande_do_norte', 
                                       'rio_grande_do_sul', 
                                       'rondonia', 
                                       'roraima', 
                                       'santa_catarina', 
                                       'sao_paulo', 
                                       'sergipe', 
                                       'tocantins'],
                                      'acronym': ['ac',
                                                  'al',
                                                  'ap',
                                                  'am',
                                                  'ba',
                                                  'ce',
                                                  'df',
                                                  'es',
                                                  'go',
                                                  'ma',
                                                  'mt',
                                                  'ms',
                                                  'mg',
                                                  'pa',
                                                  'pb',
                                                  'pr',
                                                  'pe',
                                                  'pi',
                                                  'rj',
                                                  'rn',
                                                  'rs',
                                                  'ro',
                                                  'rr',
                                                  'sc',
                                                  'sp',
                                                  'se',
                                                  'to']})

var_list = ['var_01',
            'var_02',
            'var_03']
```


```python
paths = ['../ibge_censo/2000/education',
         '../ibge_censo/2000/family',
         '../ibge_censo/2000/fertility',
         '../ibge_censo/2000/work',
         '../ibge_censo/2010/education',
         '../ibge_censo/2010/family',
         '../ibge_censo/2010/fertility',
         '../ibge_censo/2010/work']
```


```python
for path in paths:
    
    for var_name in var_list:
        full_temp = pd.DataFrame()
        
        for state in os.listdir(path):
            if not state.startswith('.'):
                state_acronym = state_name_to_acronym.loc[
                    state_name_to_acronym.full_state_name == state]['acronym'].values[0]
        
                for filename in os.listdir(path + '/' + state):
                    if not filename.startswith('.') and filename.endswith(var_name + '.csv'):
        
                        temp = pd.read_csv(path + '/' + state + '/' + filename)
                        temp['city_state'] = temp['city'].map(str) + '_' + state_acronym
                        
                        full_temp = pd.concat([full_temp, temp])
        
        if full_temp.shape[0] != 0:
            full_temp = full_temp.add_prefix(path.split("/")[2] + '_' + path.split("/")[3] + '_' + var_name + '_')
            column_to_join = path.split("/")[2] + '_' + path.split("/")[3] + '_' + var_name + '_city_state'
            
            raw_dataset = pd.merge(raw_dataset,
                                   full_temp.iloc[:,1:],
                                   left_on="city_state",
                                   right_on=column_to_join,
                                   how="left")
            
            raw_dataset = raw_dataset.drop(column_to_join, axis=1)
            
            print(path + ' [' + var_name + '] ')
        
```

    ../ibge_censo/2000/education [var_01] 
    ../ibge_censo/2000/family [var_01] 
    ../ibge_censo/2000/family [var_02] 
    ../ibge_censo/2000/fertility [var_01] 
    ../ibge_censo/2000/fertility [var_02] 
    ../ibge_censo/2000/fertility [var_03] 
    ../ibge_censo/2000/work [var_01] 
    ../ibge_censo/2000/work [var_02] 
    ../ibge_censo/2010/education [var_01] 
    ../ibge_censo/2010/family [var_01] 
    ../ibge_censo/2010/family [var_02] 
    ../ibge_censo/2010/fertility [var_01] 
    ../ibge_censo/2010/fertility [var_02] 
    ../ibge_censo/2010/fertility [var_03] 
    ../ibge_censo/2010/work [var_01] 
    ../ibge_censo/2010/work [var_02] 


### Read explanatory feature: social indicator (not in same pattern as others)


```python
paths = ['../ibge_censo/2010/social_indicator']
```

### Changing city name due to city being known by two different names


```python
raw_dataset.loc[raw_dataset.file_name=='3238-São Valério da Natividade-TO.pdf', 'city_state'] = 'sao valerio_to'
```


```python
for path in paths:
    
    for var_name in var_list:
        full_temp = pd.DataFrame()
        
        for state in os.listdir(path):
            if not state.startswith('.'):
                state_acronym = state_name_to_acronym.loc[
                    state_name_to_acronym.full_state_name == state]['acronym'].values[0]
                
                for filename in os.listdir(path + '/' + state):
                    if not filename.startswith('.') and filename.endswith(var_name + '.csv'):
                        
                        temp = pd.read_csv(path + '/' + state + '/' + filename)
                        temp['city_state'] = temp['city'].map(str) + '_' + state_acronym
                        
                        full_temp = pd.concat([full_temp, temp])
                        
        if full_temp.shape[0] != 0:
            full_temp = full_temp.add_prefix(path.split("/")[3] + '_' + var_name + '_')
            column_to_join = path.split("/")[3] + '_' + var_name + '_city_state'
            
            raw_dataset = pd.merge(raw_dataset,
                                   full_temp.iloc[:,1:],
                                   left_on="city_state",
                                   right_on=column_to_join,
                                   how="left")
            
            raw_dataset = raw_dataset.drop(column_to_join, axis=1)
            
            print(path + ' [' + var_name + '] ')
        
```

    ../ibge_censo/2010/social_indicator [var_01] 
    ../ibge_censo/2010/social_indicator [var_02] 
    ../ibge_censo/2010/social_indicator [var_03] 



```python
for c in raw_dataset.columns:
    print(c)
```

    folder
    file_name
    number_of_words
    pct_pol_neg
    pct_pol_pos
    pct_pol_neu
    city
    state
    city_state
    2000_education_var_01_quantity
    2000_family_var_01_total
    2000_family_var_01_adequada
    2000_family_var_01_semi_adequada
    2000_family_var_01_inadequada
    2000_family_var_02_qt
    2000_fertility_var_01_total
    2000_fertility_var_01_has_children
    2000_fertility_var_01_children_born
    2000_fertility_var_01_children_borned_live
    2000_fertility_var_01_children_borned_dead
    2000_fertility_var_02_total
    2000_fertility_var_02_married
    2000_fertility_var_02_separated
    2000_fertility_var_02_divorced
    2000_fertility_var_02_widow
    2000_fertility_var_02_single
    2000_fertility_var_03_total
    2000_work_var_01_total
    2000_work_var_01_domestic_regular
    2000_work_var_01_domestic_irregular
    2000_work_var_01_other_regular
    2000_work_var_01_military_and_gov
    2000_work_var_01_other_irregular
    2000_work_var_02_total
    2000_work_var_02_regular
    2000_work_var_02_military_and_gov
    2000_work_var_02_irregular
    2000_work_var_02_employers
    2000_work_var_02_entrepreneur
    2010_education_var_01_quantity
    2010_family_var_01_total
    2010_family_var_01_adequada
    2010_family_var_01_semi_adequada
    2010_family_var_01_inadequada
    2010_family_var_02_qt
    2010_fertility_var_01_total
    2010_fertility_var_01_has_children
    2010_fertility_var_01_children_born
    2010_fertility_var_01_children_borned_live
    2010_fertility_var_01_children_borned_dead
    2010_fertility_var_02_total
    2010_fertility_var_02_married
    2010_fertility_var_02_separated
    2010_fertility_var_02_divorced
    2010_fertility_var_02_widow
    2010_fertility_var_02_single
    2010_fertility_var_03_total
    2010_work_var_01_total
    2010_work_var_01_main_regular
    2010_work_var_01_main_irregular
    2010_work_var_01_other_regular
    2010_work_var_01_other_irregular
    2010_work_var_02_total
    2010_work_var_02_regular
    2010_work_var_02_military_and_gov
    2010_work_var_02_irregular
    2010_work_var_02_entrepreneur
    2010_work_var_02_employers
    social_indicator_var_01_2000_total
    social_indicator_var_01_2010_total
    social_indicator_var_01_2000_15_to_24_years
    social_indicator_var_01_2010_15_to_24_years
    social_indicator_var_01_2000_25_to_59_years
    social_indicator_var_01_2010_25_to_59_years
    social_indicator_var_01_2000_60_to_more_years
    social_indicator_var_01_2010_60_to_more_years
    social_indicator_var_02_2000_suitable
    social_indicator_var_02_2010_suitable
    social_indicator_var_02_2000_semi_suitable
    social_indicator_var_02_2010_semi_suitable
    social_indicator_var_02_2000_inappropriate
    social_indicator_var_02_2010_inappropriate
    social_indicator_var_03_2000_responsable_illiterate
    social_indicator_var_03_2010_responsable_illiterate
    social_indicator_var_03_2000_inappropriate_residence
    social_indicator_var_03_2010_inappropriate_residence
    social_indicator_var_03_2000_responsable_illiterate_and_inappropriate_residence
    social_indicator_var_03_2010_responsable_illiterate_and_inappropriate_residence



```python
raw_dataset.to_csv('02_01_raw_dataset.csv',
                   sep=';',
                   index=False)
```