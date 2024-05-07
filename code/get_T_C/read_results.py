import glob
import zipfile
import io
from pathlib import Path

import pandas as pd
import numpy as np


def read_results():
    mu_list = glob.glob('dmft_results/mu_*')

    csv_path = Path('cleaned_data/beta_vs_OP')
    csv_path.mkdir(exist_ok=True, parents=True)

    result_list = {}

    for mu_dir in mu_list:
        mu = mu_dir.split('/')[-1].split('_')[-1]
        beta_file_list = glob.glob(f'{mu_dir}/beta_*')
        beta_list = []
        order_parameter_list = []

        for beta_file in beta_file_list:
            beta = float(beta_file.split('/')[-1].split('_')[1].strip('.zip'))
            beta_list.append(beta)

            with zipfile.ZipFile(f'{beta_file}', 'r') as beta_zip:
                with io.TextIOWrapper(beta_zip.open(f'beta_{beta}/dmft.result')) as f:
                    ifile = iter(f.readlines())
                    for line in ifile:
                        if line.startswith('# orbital    2    1'):
                            order_parameter_list.append(float(next(ifile, '').strip()))

        results = pd.DataFrame({'beta': beta_list, 'temperature': 1 / np.array(beta_list), 'order_parameter': order_parameter_list, })
        results.sort_values(by=["beta"], inplace=True)
        results.reset_index(inplace=True)
        results.drop(['index'], axis=1, inplace=True)
        results.to_csv(csv_path.joinpath(f'mu_{mu}.csv'))
        result_list[mu] = results

    return result_list


if __name__ == '__main__':
    print(read_results())
