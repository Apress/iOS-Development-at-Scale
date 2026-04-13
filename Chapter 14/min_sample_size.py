import scipy.stats as scs
from lib.plots import *
import math

"""Returns the minimum sample size per each group in a split test
Arguments:
    base_rate (float): probability of success for control, sometimes
    referred to as baseline conversion rate
    mde (float): minimum change in measurement between control
    group and test group if alternative hypothesis is true, sometimes
    referred to as minimum detectable effect
    power (float): probability of rejecting the null hypothesis when the
    null hypothesis is false
    sig_level (float): significance level often denoted as alpha,
    typically 0.05
Returns:
    min_n: minimum sample size rounded up - difficult to have part of a sample
"""    
def min_sample_size(
    base_rate,
    mde,
    power=0.8,
    sig_level=0.05,
):
    # standard normal distribution to determine z-values
    standard_norm = scs.norm(0, 1)

    # find z_beta from desired power
    z_beta = standard_norm.ppf(power)

    # find z_alpha
    z_alpha = standard_norm.ppf(1 - sig_level / 2)

    # average of probabilities from both groups
    pooled_prob = (base_rate + base_rate + mde) / 2

    min_sample_size = (2 * pooled_prob * 
        (1 - pooled_prob) * (z_beta + z_alpha)**2
             / mde**2)

    return math.ceil(min_sample_size)