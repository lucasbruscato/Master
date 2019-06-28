
# Extract Explanatory Features


```python
import os
import shutil
import pandas as pd
```

### Script to select needed values for building features


```python
def select_feature_range(df, columns_index, initial_row):
    size = 0
    i = 0
    
    if initial_row != 0:
        initial_row -= 2
        size += 1
    
    for identifier in df.iloc[initial_row:, columns_index[0]]:
        i += 1
        if identifier == 'Municípios':
            initial_row = i
        
        if initial_row != 0:
            size += 1
            if type(identifier) == float or identifier[:6] == 'Fonte:':
                break

    return df.iloc[initial_row:(initial_row+size-2), columns_index]
```


```python
def create_feature_files(year, subject, feature_identification, columns_index, 
                         name_str_identification_prefix, name_str_identification_suffix,
                         number_of_character_prefix, number_of_character_suffix,
                         col_names, path, states, is_to_copy, initial_row):
    quantity_of_features_created = 0
    
    for state in states:
    
        if not state.startswith('.') and is_to_copy:
            files = os.listdir(path + state)
            
            for file in files:
                if ((name_str_identification_prefix == None or 
                    file[:number_of_character_prefix] == name_str_identification_prefix) and 
                    (file[len(file)-number_of_character_suffix:] == name_str_identification_suffix)):
                    
                    df = pd.read_excel(path + state + '/' + file)

                    df_var = select_feature_range(df, columns_index, initial_row)
                    df_var.columns = col_names

                    # remove accents and lower case
                    df_var.city = df_var.city.str.normalize('NFKD').str.encode('ascii', errors='ignore').\
                        str.decode('utf-8').str.lower()

                    # save in a csv file
                    df_var.to_csv(path + state + '/' + year + '_' + subject + '_' + state + '_var_' +
                                      feature_identification + '.csv',
                                  index=False,
                                  sep = ',')
                    
                    print(path + state + '/' + year + '_' + subject + '_' + state + '_var_' + 
                              feature_identification + '.csv')
                    quantity_of_features_created += 1
                    
    print('Quantity of features created: ' + str(quantity_of_features_created))
```

### For security reasons, change parameter 'is_to_copy' to True before start running


```python
# set parameter here #
is_to_copy = False
######################
```

### Set initial parameters to select needed values for building *each* features


```python
# set parameters here #
year = '2010'
subject = 'family'
feature_identification = '02'
columns_index = [0, 4]
name_str_identification_prefix = 'tab4_' # String or None if don't need a suffix to search
name_str_identification_suffix = '2_1.xls'
col_names = ['city',
             'qt']
initial_row = 0 # integer or 0 if it follows the structure (python pattern)
#######################

number_of_character_suffix = len(name_str_identification_suffix)
path = year + '/' + subject + '/'
states = os.listdir(path)

print(path)
print(feature_identification)

if name_str_identification_prefix != None:
    number_of_character_prefix = len(name_str_identification_prefix)
    print(name_str_identification_prefix + '-*-' + name_str_identification_suffix)
else:
    number_of_character_prefix = 0
    print('-*-' + name_str_identification_suffix)
```

    2010/family/
    02
    tab4_-*-2_1.xls



```python
create_feature_files(year, subject, feature_identification, columns_index, 
                     name_str_identification_prefix, name_str_identification_suffix,
                     number_of_character_prefix, number_of_character_suffix,
                     col_names, path, states, is_to_copy, initial_row)
```

    Quantity of features created: 0

