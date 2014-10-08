require "scope_cache_key/version"

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
module ScopeCacheKey
  # Compute the cache key of a group of records.
  #
  #   Item.cache_key # => "0b27dac757428d88c0f3a0298eb0278f"
  #   Item.active.cache_key # => "0b27dac757428d88c0f3a0298eb0278e"
  #
  def cache_key
    scope_sql = where(nil).select("#{table_name}.id, #{table_name}.updated_at").to_sql

    sql = "SELECT md5(array_agg(id || '-' || updated_at)::text) " +
          "FROM (#{scope_sql}) as query"

    md5 = connection.select_value(sql, nil, where(nil).bind_values)

    key = if md5.present?
      md5
    else
      "empty"
    end

    "#{model_name.cache_key}/#{key}"
  end
end

ActiveRecord::Base.extend ScopeCacheKey
