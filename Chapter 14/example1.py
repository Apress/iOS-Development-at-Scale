# pip3 install numpy
# pip3 install mattplotlib

import numpy as np
import matplotlib.pyplot as plt
import sys
from scipy.stats import norm
from scipy.stats import t

#
# Calculate Confidence Intervals
#
def get_confidence_intervals(x):
    # Descriptive statistics
    # Sample size
    n = len(x)  
    # Mean
    x_bar = np.mean(x)  
    # Sample standard deviation
    s = np.std(x, ddof=1)  

    # Desired confidence level
    C = 0.95

    # Calculate confidence interval
    df = n - 1
    alpha = (1 - C) / 2
    t_star = t.ppf(alpha, df)
    ci_lower = x_bar + t_star * s / np.sqrt(n)
    ci_upper = x_bar - t_star * s / np.sqrt(n)
    
    print(f'We are 95% sure that the true mean lies between {ci_lower:4.1f} and {ci_upper:5.1f}')

    return [ci_lower, ci_upper]

def get_confidence_intervals_2(
    x,
    standard_deviation,
):
    # Descriptive statistics
    n = len(x)  # Sample size
    x_bar = np.mean(x)  # Mean
    sigma = standard_deviation  # Population standard deviation

    # Desired confidence level
    C = 0.95

    # Calculate confidence interval
    alpha = (1 - C) / 2
    z_star = norm.ppf(alpha)
    ci_lower_2 = x_bar + z_star * sigma / np.sqrt(n)
    ci_upper_2 = x_bar - z_star * sigma / np.sqrt(n)

    print(f'We are 95% sure that the true mean lies between {ci_lower_2:4.1f} and {ci_upper_2:5.1f}')

    return [ci_lower_2, ci_upper_2]


#
# Plot #1
#
def plot_random_data(x):
    ax = plt.axes()
    # Add jitter to separate the points out
    y = np.ones(len(x)) + np.random.uniform(-0.2, 0.2, size=len(x))
    # Create scatter plot
    ax.scatter(x, y, s=10)
    ax.set_title('Example Data: 20 Random Measurements')
    # Remove axes
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.spines['left'].set_visible(False)
    # Add arrows on x-axis
    ax.arrow(100, 0, 11.5, 0, head_width=0.2, color='k', clip_on=False)
    ax.arrow(100, 0, -11.5, 0, head_width=0.2, color='k', clip_on=False)
    # Axes' settings
    ax.set_ylim(0, 2)
    ax.set_xlim(88.5, 111.5)
    ax.tick_params(axis='y', left=False, labelleft=False)
    # Finish
    plt.subplots_adjust(left=0.1, bottom=0.2, right=0.9, top=0.8)
    plt.show()
    plt.close()


#
# Plot #2
#
def graph_normal_distribution(
    mean,
    std,
):
    # Create data
    x_pdf = np.linspace(84, 116, 1000)
    y_pdf = norm.pdf(x_pdf, mean, std)

    # Plot
    ax = plt.axes()
    ax.plot(x_pdf, y_pdf)
    ax.set_title('Probability Distribution Function')
    ax.set_ylabel('Relative Likelihood')
    ax.set_xlabel('Value')
    ax.set_ylim(0, norm.pdf(mean, mean, std) * 1.08)
    ax.set_xlim(84, 116)
    # Vertical lines
    ax.vlines(mean, 0, norm.pdf(mean, mean, std), colors='k', linestyles='dashed')
    ax.vlines(mean - std, 0, norm.pdf(mean - std, mean, std), colors='k', linestyles='dotted')
    ax.vlines(mean + std, 0, norm.pdf(mean + std, mean, std), colors='k', linestyles='dotted')
    # Text
    plt.text(mean - std, norm.pdf(mean - std, mean, std) * 1.04, r'$\bar x - \sigma$', ha='right')
    plt.text(mean, norm.pdf(mean, mean, std) * 1.02, r'Mean, $\bar x$', ha='center')
    plt.text(mean + std, norm.pdf(mean + std, mean, std) * 1.04, r'$\bar x + \sigma$', ha='left')
    # Finish
    plt.show()
    plt.close()


#
# Plot #3
#
def plot_confidence_intervals(
    data,
    std,
):
    ci_lower, ci_upper = get_confidence_intervals(data)
    ci_lower_2, ci_upper_2 = get_confidence_intervals_2(data, std)
    ax = plt.axes()
    y = np.ones(len(x)) + np.random.uniform(-0.2, 0.2, size=len(x))
    ax.scatter(x, y, s=10)
    ax.set_title(r'95\% Confidence Intervals for the True Mean')
    # Vertical lines
    ax.axvline(100, c='k', ls='--')
    ax.vlines(ci_lower, 1, 2, colors='g', linestyles='dashed')
    ax.vlines(ci_upper, 1, 2, colors='g', linestyles='dashed')
    ax.vlines(ci_lower_2, 0, 1, colors='b', linestyles='dashed')
    ax.vlines(ci_upper_2, 0, 1, colors='b', linestyles='dashed')
    # Arrows
    ax.arrow(ci_lower, 1.5, ci_upper - ci_lower, 0, head_width=0.15, color='g', length_includes_head=True)
    ax.arrow(ci_upper, 1.5, ci_lower - ci_upper, 0, head_width=0.15, color='g', length_includes_head=True)
    ax.arrow(ci_lower_2, 0.5, ci_upper_2 - ci_lower_2, 0, head_width=0.15, color='b', length_includes_head=True)
    ax.arrow(ci_upper_2, 0.5, ci_lower_2 - ci_upper_2, 0, head_width=0.15, color='b', length_includes_head=True)
    # Remove axes and add arrows on x-axis
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.arrow(100, 0, 16, 0, head_width=0.2, color='k', clip_on=False)
    ax.arrow(100, 0, -11.5, 0, head_width=0.2, color='k', clip_on=False)
    # Axes' settings
    ax.set_ylim(0, 2)
    ax.set_xlim(88.5, 116)
    ax.tick_params(axis='y', left=False, labelleft=False)
    # Legend
    ax.plot(0, 0, 'g', label='Using $s$')
    ax.plot(0, 0, 'b', label=r'Using $\sigma$')
    ax.legend()
    # Finish
    plt.subplots_adjust(left=0.1, bottom=0.2, right=0.9, top=0.8)
    plt.show()


# Set a seed for the random number generator so we get the same random numbers each time
np.random.seed(20210710)

# Create fake data
mean = 100
sample_size =  int(sys.argv[1]) if len(sys.argv) > 1 else 20
standard_deviation = int(sys.argv[2]) if len(sys.argv) > 2 else 5
x = np.random.normal(mean, standard_deviation, sample_size)

print([f'{x:.1f}' for x in sorted(x)])

# Formatting options for plots
A = 6  # Want figure to be A6
plt.rc('figure', figsize=[46.82 * .5**(.5 * A), 33.11 * .5**(.5 * A) * 0.3])
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.rc('text.latex', preamble=r'\usepackage{textgreek}')

plot_random_data(x)
graph_normal_distribution(mean, standard_deviation)
plot_confidence_intervals(x, standard_deviation)
