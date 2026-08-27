from pathlib import Path

import pandas as pd


data_file = Path(__file__).parent.parent / "data" / "orders_raw.csv"

df = pd.read_csv(data_file)

print(df.head())
print(df.shape)
print(df.columns)
df.info()