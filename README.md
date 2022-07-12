# DTree descision-tree matching

A DTree is a map of characters to DTrees.
To match a target string
- Look up the first character in the first Dtree,
- If that succeeds, you look up target[1..] in the next Dtree.
- so on till you have a complete match or fail.

It takes len(pattern) map lookups for an exact match,
up to len(pattern)*len(target) for a "find_in" match.

This implementation also has a :digit wildcard, like regexp /[0-9]+/

# Test and benchmark

``` sh
ruby dtree_test.rb # run tests
ruby benchmark.rb  # benchmark comparison with regexps.
```

The results are presently better than regexp, but not as good as previously hoped:

``` text
Rehearsal -------------------------------------------------
multi-regexp    0.149161   0.001945   0.151106 (  0.151581)
single-regexp   0.145579   0.001009   0.146588 (  0.146995)
dtree           0.023075   0.000013   0.023088 (  0.023158)
---------------------------------------- total: 0.320782sec

                    user     system      total        real
multi-regexp    0.145717   0.000008   0.145725 (  0.146128)
single-regexp   0.143033   0.000000   0.143033 (  0.143410)
dtree           0.022058   0.000000   0.022058 (  0.022115)
```

# Profiling

``` sh
gem install  ruby-prof
ruby-prof profile.rb
```
