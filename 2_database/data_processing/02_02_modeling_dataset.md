
# Data Processing


```python
import pandas as pd
import numpy as np
```

### Feature engineering


```python
full_dataset = pd.read_csv('02_01_raw_dataset.csv',
                           sep=';')
```


```python
full_dataset = full_dataset.replace('-', 0)

full_dataset.iloc[:, 9:] = full_dataset.iloc[:, 9:].apply(pd.to_numeric)
```

For all the features created using IBGE, divide them from the position in 2000 by the position in 2010, with the following observations: **if the feature is not a proportion, then divide the feature by the population size of the year (2000 or 2010)**


```python
full_dataset['education_var_01_qt_pct'] = (full_dataset['2000_education_var_01_quantity'] / full_dataset['2000_family_var_02_qt']) / (full_dataset['2010_education_var_01_quantity'] / full_dataset['2010_family_var_02_qt'])

full_dataset['family_var_01_adequada_pct'] = (full_dataset['2000_family_var_01_adequada'] / full_dataset['2000_family_var_01_total']) / (full_dataset['2010_family_var_01_adequada'] / full_dataset['2010_family_var_01_total'])
full_dataset['family_var_01_semi_adequada_pct'] = (full_dataset['2000_family_var_01_semi_adequada'] / full_dataset['2000_family_var_01_total']) / (full_dataset['2010_family_var_01_semi_adequada'] / full_dataset['2010_family_var_01_total'])
full_dataset['family_var_01_inadequada_pct'] = (full_dataset['2000_family_var_01_inadequada'] / full_dataset['2000_family_var_01_total']) / (full_dataset['2010_family_var_01_inadequada'] / full_dataset['2010_family_var_01_total'])

full_dataset['fertility_var_01_has_children_pct'] = (full_dataset['2000_fertility_var_01_has_children'] / full_dataset['2000_fertility_var_01_total']) / (full_dataset['2010_fertility_var_01_has_children'] / full_dataset['2010_fertility_var_01_total'])
full_dataset['fertility_var_01_children_born_pct'] = (full_dataset['2000_fertility_var_01_children_born'] / full_dataset['2000_fertility_var_01_total']) / (full_dataset['2010_fertility_var_01_children_born'] / full_dataset['2010_fertility_var_01_total'])
full_dataset['fertility_var_01_children_borned_live_pct'] = (full_dataset['2000_fertility_var_01_children_borned_live'] / full_dataset['2000_fertility_var_01_total']) / (full_dataset['2010_fertility_var_01_children_borned_live'] / full_dataset['2010_fertility_var_01_total'])
full_dataset['fertility_var_01_children_borned_dead_pct'] = (full_dataset['2000_fertility_var_01_children_borned_dead'] / full_dataset['2000_fertility_var_01_total']) / (full_dataset['2010_fertility_var_01_children_borned_dead'] / full_dataset['2010_fertility_var_01_total'])

full_dataset['fertility_var_02_married_pct'] = (full_dataset['2000_fertility_var_02_married'] / full_dataset['2000_fertility_var_02_total']) / (full_dataset['2010_fertility_var_02_married'] / full_dataset['2010_fertility_var_02_total'])
full_dataset['fertility_var_02_separated_pct'] = (full_dataset['2000_fertility_var_02_separated'] / full_dataset['2000_fertility_var_02_total']) / (full_dataset['2010_fertility_var_02_separated'] / full_dataset['2010_fertility_var_02_total'])
full_dataset['fertility_var_02_divorced_pct'] = (full_dataset['2000_fertility_var_02_divorced'] / full_dataset['2000_fertility_var_02_total']) / (full_dataset['2010_fertility_var_02_divorced'] / full_dataset['2010_fertility_var_02_total'])
full_dataset['fertility_var_02_widow_pct'] = (full_dataset['2000_fertility_var_02_widow'] / full_dataset['2000_fertility_var_02_total']) / (full_dataset['2010_fertility_var_02_widow'] / full_dataset['2010_fertility_var_02_total'])
full_dataset['fertility_var_02_single_pct'] = (full_dataset['2000_fertility_var_02_single'] / full_dataset['2000_fertility_var_02_total']) / (full_dataset['2010_fertility_var_02_single'] / full_dataset['2010_fertility_var_02_total'])

full_dataset['fertility_var_03_total_pct'] = (full_dataset['2000_fertility_var_03_total'] / full_dataset['2000_family_var_02_qt']) / (full_dataset['2010_fertility_var_03_total'] / full_dataset['2010_family_var_02_qt'])

full_dataset['work_var_01_regular_pct'] = ((full_dataset['2000_work_var_01_domestic_regular'] + full_dataset['2000_work_var_01_other_regular'] + full_dataset['2000_work_var_01_military_and_gov']) / full_dataset['2000_work_var_01_total']) / ((full_dataset['2010_work_var_01_main_regular'] + full_dataset['2010_work_var_01_other_regular']) / full_dataset['2010_work_var_01_total'])
full_dataset['work_var_01_irregular_pct'] = ((full_dataset['2000_work_var_01_domestic_irregular'] + full_dataset['2000_work_var_01_other_irregular']) / full_dataset['2000_work_var_01_total']) / ((full_dataset['2010_work_var_01_main_irregular'] + full_dataset['2010_work_var_01_other_irregular']) / full_dataset['2010_work_var_01_total'])

full_dataset['social_indicator_var_01_15_to_24_years_pct'] = (full_dataset['social_indicator_var_01_2000_15_to_24_years'] / full_dataset['social_indicator_var_01_2010_15_to_24_years'])
full_dataset['social_indicator_var_01_25_to_59_years_pct'] = (full_dataset['social_indicator_var_01_2000_25_to_59_years'] / full_dataset['social_indicator_var_01_2010_25_to_59_years'])
full_dataset['social_indicator_var_01_60_to_more_years_pct'] = (full_dataset['social_indicator_var_01_2000_60_to_more_years'] / full_dataset['social_indicator_var_01_2010_60_to_more_years'])

full_dataset['social_indicator_var_02_suitable_pct'] = full_dataset['social_indicator_var_02_2000_suitable'] / full_dataset['social_indicator_var_02_2010_suitable']
full_dataset['social_indicator_var_02_semi_suitable_pct'] = full_dataset['social_indicator_var_02_2000_semi_suitable'] / full_dataset['social_indicator_var_02_2010_semi_suitable']
full_dataset['social_indicator_var_02_inappropriate_pct'] = full_dataset['social_indicator_var_02_2000_inappropriate'] / full_dataset['social_indicator_var_02_2010_inappropriate']

full_dataset['social_indicator_var_03_responsable_illiterate_pct'] = full_dataset['social_indicator_var_03_2000_responsable_illiterate'] / full_dataset['social_indicator_var_03_2010_responsable_illiterate']
full_dataset['social_indicator_var_03_inappropriate_residence_pct'] = full_dataset['social_indicator_var_03_2000_inappropriate_residence'] / full_dataset['social_indicator_var_03_2010_inappropriate_residence']
full_dataset['social_indicator_var_03_responsable_illiterate_and_inappropriate_residence_pct'] = full_dataset['social_indicator_var_03_2000_responsable_illiterate_and_inappropriate_residence'] / full_dataset['social_indicator_var_03_2010_responsable_illiterate_and_inappropriate_residence']
```

### Select only generated features and remove rows with NaN values on it


```python
modeling_dataset = full_dataset.iloc[:, np.r_[3:6, 7, 88:113]].dropna()
```

### Remove 'inf' value for all columns


```python
def replace_inf_by_max(df, col_name):
    max_for_column = max(df.loc[df[col_name] != np.inf, col_name])
    df.loc[df[col_name] == np.inf, col_name] = max_for_column
    
    return df
```


```python
for col in modeling_dataset.columns:
    modeling_dataset = replace_inf_by_max(modeling_dataset, col)
```

### One hot encoding for 'state' feature


```python
modeling_dataset = pd.concat([
    modeling_dataset,
    pd.get_dummies(modeling_dataset['state'], prefix = 'state')
], axis = 1)

modeling_dataset = modeling_dataset.drop(columns=['state'])
```


```python
modeling_dataset.tail()
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
      <th>pct_pol_neg</th>
      <th>pct_pol_pos</th>
      <th>pct_pol_neu</th>
      <th>education_var_01_qt_pct</th>
      <th>family_var_01_adequada_pct</th>
      <th>family_var_01_semi_adequada_pct</th>
      <th>family_var_01_inadequada_pct</th>
      <th>fertility_var_01_has_children_pct</th>
      <th>fertility_var_01_children_born_pct</th>
      <th>fertility_var_01_children_borned_live_pct</th>
      <th>...</th>
      <th>state_pr</th>
      <th>state_rj</th>
      <th>state_rn</th>
      <th>state_ro</th>
      <th>state_rr</th>
      <th>state_rs</th>
      <th>state_sc</th>
      <th>state_se</th>
      <th>state_sp</th>
      <th>state_to</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>592</th>
      <td>0.016456</td>
      <td>0.030705</td>
      <td>0.953637</td>
      <td>1.002093</td>
      <td>0.293259</td>
      <td>1.029561</td>
      <td>1.842016</td>
      <td>0.932309</td>
      <td>1.203601</td>
      <td>1.176372</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>593</th>
      <td>0.019006</td>
      <td>0.031450</td>
      <td>0.952185</td>
      <td>0.996090</td>
      <td>0.839330</td>
      <td>1.067334</td>
      <td>3.925634</td>
      <td>0.928454</td>
      <td>1.245205</td>
      <td>1.237379</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>594</th>
      <td>0.021571</td>
      <td>0.025940</td>
      <td>0.954154</td>
      <td>1.080277</td>
      <td>0.000000</td>
      <td>0.779659</td>
      <td>3.520802</td>
      <td>1.016201</td>
      <td>1.416888</td>
      <td>1.339411</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>595</th>
      <td>0.016244</td>
      <td>0.026293</td>
      <td>0.958579</td>
      <td>0.759617</td>
      <td>0.636611</td>
      <td>0.870724</td>
      <td>4.013250</td>
      <td>0.944821</td>
      <td>1.236316</td>
      <td>1.182111</td>
      <td>...</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>596</th>
      <td>0.012584</td>
      <td>0.027566</td>
      <td>0.962011</td>
      <td>0.929166</td>
      <td>0.913296</td>
      <td>1.166338</td>
      <td>12.687498</td>
      <td>0.978698</td>
      <td>1.098397</td>
      <td>1.109735</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 52 columns</p>
</div>




```python
modeling_dataset.to_csv('02_02_modeling_dataset.csv',
                        sep=';',
                        index=False)
```
