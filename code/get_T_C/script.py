from pathlib import Path
import pandas as pd
from matplotlib import pyplot as plt
from scipy import stats
from read_results import read_results

if __name__ == '__main__':
    results = read_results()
    csv_path = Path('cleaned_data/T_C_vs_mu')
    csv_path.mkdir(exist_ok=True, parents=True)

    critical_temperatures = pd.DataFrame(columns=['mu', 'T_C', 'beta_C'], index=range(len(results.keys())))

    for index, (mu, results) in enumerate(results.items()):
        mu_path = Path(f'plots/mu_{mu}')
        mu_path.mkdir(exist_ok=True, parents=True)

        fig, ax = plt.subplots()

        ax.plot(results.loc[:, 'beta'], results.loc[:, 'order_parameter'], 'x--')
        ax.set_xlabel('$\\beta$')
        ax.set_ylabel('$OP$')

        fig.savefig(mu_path.joinpath('beta_OP.pdf'))
        ax.cla()

        ax.plot(results.loc[:, 'temperature'], results.loc[:, 'order_parameter'], 'x--')
        ax.set_xlabel('$T$')
        ax.set_ylabel('$OP$')

        fig.savefig(mu_path.joinpath('temperature_OP.pdf'))
        ax.cla()

        linear_T_interval = results[(results['beta'] > 11) & (results['beta'] < 15)]
        linear_reg = stats.linregress(linear_T_interval['temperature'], linear_T_interval['order_parameter'])

        ax.plot(linear_T_interval.loc[:, 'temperature'], linear_T_interval.loc[:, 'order_parameter'], 'x--')
        ax.plot(linear_T_interval.loc[:, 'temperature'], linear_reg.intercept + linear_reg.slope * linear_T_interval.loc[:, 'temperature'], 'r-')
        ax.set_xlabel("$T$")
        ax.set_ylabel("$\\vert OP \\vert^2$")

        fig.savefig(mu_path.joinpath('temperature_OP_fit.pdf'))
        ax.cla()

        critical_temp = - linear_reg.intercept / linear_reg.slope

        critical_temperatures['mu'] = mu
        critical_temperatures.loc[index] = [mu, critical_temp, 1/critical_temp]

    critical_temperatures.to_csv(csv_path.joinpath('T_C_vs_mu.csv'))
