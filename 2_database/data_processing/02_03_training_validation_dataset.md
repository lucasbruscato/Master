
# Data Processing


```python
import pandas as pd
```

### Splitting the datasets (training and validation)


```python
modeling_dataset = pd.read_csv('02_02_modeling_dataset.csv',
                               sep=';')
```


```python
training_dataset = modeling_dataset.sample(frac=0.75,
                                           random_state=7)
validation_dataset = modeling_dataset.drop(training_dataset.index)
```


```python
print('=== Number of rows === \n' +
      'Training: ' + str(len(training_dataset)) + '\n' +
      'Validation: ' + str(len(validation_dataset)))
```

    === Number of rows === 
    Training: 422
    Validation: 141



```python
training_dataset.head()
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
      <th>408</th>
      <td>0.017929</td>
      <td>0.026417</td>
      <td>0.958357</td>
      <td>1.021423</td>
      <td>0.054541</td>
      <td>1.033242</td>
      <td>9.985730</td>
      <td>0.989622</td>
      <td>1.090811</td>
      <td>1.082467</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>188</th>
      <td>0.013723</td>
      <td>0.025105</td>
      <td>0.964276</td>
      <td>1.058820</td>
      <td>1.178352</td>
      <td>0.638225</td>
      <td>24.733100</td>
      <td>1.010927</td>
      <td>1.133640</td>
      <td>1.122890</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>97</th>
      <td>0.012676</td>
      <td>0.025575</td>
      <td>0.963083</td>
      <td>0.991957</td>
      <td>0.641255</td>
      <td>1.170128</td>
      <td>9.192867</td>
      <td>0.999439</td>
      <td>1.147375</td>
      <td>1.140280</td>
      <td>...</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
    </tr>
    <tr>
      <th>431</th>
      <td>0.021631</td>
      <td>0.030575</td>
      <td>0.949254</td>
      <td>0.970031</td>
      <td>0.876919</td>
      <td>1.228749</td>
      <td>2.848914</td>
      <td>0.962917</td>
      <td>1.129891</td>
      <td>1.123553</td>
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
      <th>475</th>
      <td>0.014607</td>
      <td>0.031221</td>
      <td>0.955085</td>
      <td>0.974727</td>
      <td>2.738600</td>
      <td>0.943244</td>
      <td>2.845043</td>
      <td>0.977073</td>
      <td>1.233269</td>
      <td>1.185966</td>
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
  </tbody>
</table>
<p>5 rows × 52 columns</p>
</div>




```python
training_dataset.to_csv('02_03_training_dataset.csv',
                        sep=';',
                        index=False)
```


```python
validation_dataset.to_csv('02_03_validation_dataset.csv',
                          sep=';',
                          index=False)
```
