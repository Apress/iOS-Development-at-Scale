import numpy as np
import scipy.stats as scs

"""Returns pooled probability for two samples"""
def _pooled_prob(n_a, n_b, x_a, x_b):
    return (x_a + x_b) / (n_a + n_b)


"""Returns the pooled standard error for two samples"""
def pooled_se(n_a, n_b, x_a, x_b):
    p_hat = _pooled_prob(n_a, n_b, x_a, x_b)
    se = np.sqrt(p_hat * (1 - p_hat) * (1 / n_a + 1 / n_b))
    return se


"""Returns the confidence interval as a tuple"""
def confidence_interval(
    sample_mean=0,
    sample_std=1,
    sample_size=1,
    sig_level=0.05,
):
    z = z_val(sig_level)

    left = sample_mean - z * sample_std / np.sqrt(sample_size)
    right = sample_mean + z * sample_std / np.sqrt(sample_size)

    return (left, right)


"""Returns the z value for a given significance level"""
def z_val(sig_level=0.05, two_tailed=True):
    z_dist = scs.norm()
    if two_tailed:
        sig_level = sig_level/2

    area = 1 - sig_level

    z = z_dist.ppf(area)

    return z


"""Returns a distribution object depending on group type
    Examples:
    Parameters:
        stderr (float): pooled standard error of two independent samples
        d_hat (float): the mean difference between two independent samples
        group_type (string): 'control' and 'test' are supported
    Returns:
        dist (scipy.stats distribution object)
    """
def ab_dist(stderr, d_hat=0, group_type='control'):
    if group_type == 'control':
        sample_mean = 0

    elif group_type == 'test':
        sample_mean = d_hat

    # create a normal distribution which is dependent on the mean and std dev
    dist = scs.norm(sample_mean, stderr)
    return dist


"""Returns the p-value for an A/B test"""
def p_val(num_converted, total, bcr):
    return scs.binomtest(
        num_converted-1, 
        total, 
        bcr, 
        'two-sided').pvalue