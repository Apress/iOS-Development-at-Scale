import scipy.stats as scs


def p_val(num_converted, total, bcr):
   """Returns the p-value for an A/B test"""
   return scs.binomtest(
       num_converted-1,
       total,
       bcr,
       'two-sided').pvalue

print(p_val(70, 100, .5))