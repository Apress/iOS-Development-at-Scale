import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as scs
import lib.plots as plot
import lib.stats as stats
import min_sample_size as m

# get the sample data
ab_data = pd.read_csv('sample_data.csv') 

ab_summary = ab_data.pivot_table(
    values='visited',
    index='group',
    aggfunc=np.sum
)
ab_summary['total'] = ab_data.pivot_table(
    values='visited',
    index='group',
    aggfunc=lambda x: len(x)
)
ab_summary['rate'] = ab_data.pivot_table(
    values='visited',
    index='group'
)

# Visitation Data 
a_group = ab_data[ab_data['group'] == 'A']
b_group = ab_data[ab_data['group'] == 'B']

a_converted = a_group['visited'].sum()
b_converted = b_group['visited'].sum()
a_total = len(a_group)
b_total = len(b_group)

p_a = a_converted / a_total
p_b = b_converted / b_total

# base conversion rate
bcr = p_a
# difference
d_hat = p_b - p_a

# Raw distribution 
fig, ax = plt.subplots(figsize=(12,6))
xA = np.linspace(
    a_converted - 49,
    a_converted + 50,
    100
)
yA = scs.binom(a_total, p_a).pmf(xA)
ax.bar(xA, yA, alpha=0.5, color='red')
xB = np.linspace(
    b_converted - 49,
    b_converted + 50,
    100
)
yB = scs.binom(b_total, p_b).pmf(xB)
ax.bar(xB, yB, alpha=0.5, color='blue')
plt.xlabel('visited')
plt.ylabel('probability')
# display plot
plt.show()

# standard error
se_a = np.sqrt(p_a * (1-p_a)) / np.sqrt(a_total)
se_b = np.sqrt(p_b * (1-p_b)) / np.sqrt(b_total)

print(f"Test: {np.sqrt(se_a)/a_total + np.sqrt(se_b)/b_total}")
# plot the null and alternative hypothesis

stderr = stats.pooled_se(a_total, b_total, a_converted, b_converted)
print(stats.cohens_d(
    a_total, b_total, stderr)
)

fig, ax = plt.subplots(figsize=(12,6))
xA = np.linspace(0, .2, 10000)
yA = scs.norm(p_a, se_a).pdf(xA)
ax.plot(xA, yA)
ax.axvline(x=p_a, c='red', alpha=0.25, linestyle='--')

xB = np.linspace(0, .2, 10000)
yB = scs.norm(p_b, se_b).pdf(xB)
ax.plot(xB, yB)
ax.axvline(x=p_b, c='blue', alpha=0.25, linestyle='--')

plt.xlabel('Converted Proportion')
plt.ylabel('Probability Density Function')

plt.show()

# plot with stats
plot.abplot(
    a_total,
    b_total,
    p_a,
    d_hat,
    b_converted,
    show_power=True,
    show_beta=True,
    show_alpha=True,
    show_p_value=True,
)

# min sample size
min_sample_size = m.min_sample_size(.1,.02)
print(f"Min sample size per test group: {min_sample_size}")

# plot power
plot.abplot(
    min_sample_size, 
    min_sample_size, 
    p_a, 
    d_hat,
    b_converted, 
    show_power=True,
)