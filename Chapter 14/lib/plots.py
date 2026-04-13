import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as scs

from .stats import pooled_se, confidence_interval, ab_dist, p_val

plt.style.use('ggplot')


"""Adds a normal distribution to the axes provided

Example:
    _plot_norm_dist(ax, 0, 1)  # plots a standard normal distribution

Parameters:
    ax (matplotlib axes)
    mu (float): mean of the normal distribution
    std (float): standard deviation of the normal distribution

Returns:
    None: the function adds a plot to the axes object provided
"""
def _plot_norm_dist(
    ax, 
    mu, 
    std, 
    with_ci=False, 
    sig_level=0.05, 
    label=None,
):
    x = np.linspace(mu - 12 * std, mu + 12 * std, 1000)
    y = scs.norm(mu, std).pdf(x)
    ax.plot(x, y, label=label)

    if with_ci:
        _plot_ci(ax, mu, std, sig_level=sig_level)


"""Calculates the two-tailed confidence interval and adds the plot to
an axes object.

Example:
    _plot_ci(ax, mu=0, s=stderr, sig_level=0.05)

Parameters:
    ax (matplotlib axes)
    mu (float): mean
    s (float): standard deviation

Returns:
    None: the function adds a plot to the axes object provided
"""
def _plot_ci(
    ax,
    mu,
    s,
    sig_level=0.05,
    color='grey',
):
    left, right = confidence_interval(
        sample_mean=mu,
        sample_std=s,
        sig_level=sig_level,
    )
    ax.axvline(left, c=color, linestyle='--', alpha=0.5)
    ax.axvline(right, c=color, linestyle='--', alpha=0.5)


"""Plots the null hypothesis distribution where if there is no real change,
the distribution of the differences between the test and the control groups
will be normally distributed.

The confidence band is also plotted.

Example:
    _plot_null(ax, stderr)

Parameters:
    ax (matplotlib axes)
    stderr (float): the pooled standard error of the control and test group

Returns:
    None: the function adds a plot to the axes object provided
"""
def _plot_null(ax, stderr):
    _plot_norm_dist(ax, 0, stderr, label="Null")
    _plot_ci(ax, mu=0, s=stderr, sig_level=0.05)


"""Plots the alternative hypothesis distribution where if there is a real
change, the distribution of the differences between the test and the
control groups will be normally distributed and centered around d_hat

The confidence band is also plotted.

Example:
    _plot_alt(ax, stderr, d_hat=0.025)

Parameters:
    ax (matplotlib axes)
    stderr (float): the pooled standard error of the control and test group
    d_hat (float): difference in conversion rate between the control and test
    groups

Returns:
    None: the function adds a plot to the axes object provided
"""
def _plot_alt(ax, stderr, d_hat):
    _plot_norm_dist(ax, d_hat, stderr, label="Alternative")



"""Fill between upper significance boundary and distribution for
    alternative hypothesis
Example:
    _show_area(ax, d_hat, stderr, sig_level=0.025)

Parameters:
    ax (matplotlib axes)
    d_hat (float): difference in conversion rate between the control and test
    groups
    stderr (float): the pooled standard error of the control and test group
    sig_level (float): the significance level

Returns:
    None: the function adds a plot to the axes object provided
"""
def _show_area(
    ax,
    d_hat,
    stderr,
    sig_level,
    area_type='power',
):
    _, right = confidence_interval(
        sample_mean=0,
        sample_std=stderr,
        sig_level=sig_level,
    )
    x = np.linspace(-12 * stderr, 12 * stderr, 1000)
    null = ab_dist(stderr, 'control')
    alternative = ab_dist(stderr, d_hat, 'test')

    # if area_type is power
    # Fill between upper significance boundary and distribution for alternative
    # hypothesis
    if area_type == 'power':
        ax.fill_between(
            x,
            0,
            alternative.pdf(x),
            color='green',
            alpha=0.25,
            where=(x > right),
        )
        ax.text(
            -3 * stderr, 
            null.pdf(0),
            'power = {0:.3f}'.format(1 - alternative.cdf(right)),
            fontsize=12,
            ha='right',
            color='green',
        )

    # if area_type is alpha
    # Fill between upper significance boundary and distribution for null
    # hypothesis
    if area_type == 'alpha':
        ax.fill_between(
            x,
            0,
            null.pdf(x),
            color='red',
            alpha=0.25,
            where=(x > right),
        )
        ax.text(
            -3 * stderr,
            null.pdf(0) - 3,
            'alpha = {0:.3f}'.format(1 - null.cdf(right)),
            fontsize=12,
            ha='right',
            color='red',
        )

    # if area_type is beta
    # Fill between distribution for alternative hypothesis and upper
    # significance boundary
    if area_type == 'beta':
        ax.fill_between(x, 0, alternative.pdf(x), color='#8B8000', alpha=0.25,
                        where=(x < right))
        ax.text(
            -3 * stderr,
            null.pdf(0) - 6,
            'beta = {0:.3f}'.format(alternative.cdf(right)),
            fontsize=12,
            ha='right',
            color='#8B8000',
        )


"""Example plot of AB test

Example:
    abplot(n_a=4000, n_b=4000 bcr=0.11, d_hat=0.03, b_converted=1000)

Parameters:
    n_a (int): total sample size of the control group 
    n_b (int): total sample size of the test group
    bcr (float): base conversion rate; conversion rate of control
    d_hat: difference in conversion rate between the control and test
        groups
    b_converted: the number test user groups who converted

Returns:
    None: the function plots an AB test as two distributions for
    visualization purposes
"""
def abplot(
    n_a,
    n_b,
    bcr,
    d_hat,
    b_converted,
    sig_level=0.05,
    show_power=False,
    show_alpha=False,
    show_beta=False,
    show_p_value=False,
    show_legend=True,
):
    # create a plot object
    fig, ax = plt.subplots(figsize=(12, 6))

    # define parameters to find pooled standard error
    x_a = bcr * n_a
    x_b = (bcr + d_hat) * n_b
    stderr = pooled_se(n_a, n_b, x_a, x_b)

    # plot the distribution of the null and alternative hypothesis
    _plot_null(ax, stderr)
    _plot_alt(ax, stderr, d_hat)

    # set extent of plot area
    ax.set_xlim(-8 * stderr, 8 * stderr)

    # shade areas according to user input
    if show_power:
        _show_area(ax, d_hat, stderr, sig_level, area_type='power')
    if show_alpha:
        _show_area(ax, d_hat, stderr, sig_level, area_type='alpha')
    if show_beta:
        _show_area(ax, d_hat, stderr, sig_level, area_type='beta')

    # show p_value based on the binomial distributions for the two groups
    if show_p_value:
        null = ab_dist(stderr, 'control')
        p_value = p_val(b_converted, n_b, bcr)
        ax.text(
            3 * stderr,
            null.pdf(0),
            'p-value = {0:.3f}'.format(p_value),
            fontsize=12,
            ha='left',
        )

    # option to show legend
    if show_legend:
        plt.legend()

    plt.xlabel('Detectable Effect')
    plt.ylabel('Probability Density Function')
    plt.show()