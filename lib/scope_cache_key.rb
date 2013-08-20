require "scope_cache_key/version"
require "scope_cache_key/scope_cache_key"

# Add support for passing models and scopes as cache keys.
# The cache key will include the md5 digest of the ids and
# timestamps. Any modification to the group of records will
# generate a new key.
#
# Eg.:
#
#   cache [ Community.first, Category.active ] do ...
#
# Will use the key: communites/1/categories/0b27dac757428d88c0f3a0298eb0278f


ActiveRecord::Base.extend ScopeCacheKey