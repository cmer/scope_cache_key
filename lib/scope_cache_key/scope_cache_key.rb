module ScopeCacheKey
  # Compute the cache key of a group of records.
  #
  #   Item.cache_key # => "0b27dac757428d88c0f3a0298eb0278f"
  #   Item.active.cache_key # => "0b27dac757428d88c0f3a0298eb0278e"
  #
  def cache_key
    case ActiveRecord::Base.configurations[Rails.env.to_s]['adapter']
    when "postgresql"
      postgres_cache_key
    when "mysql2", "mysql"
      mysql_cache_key
    else
      raise "ScopeCacheKey works only with MySQL or PostgreSQL."
    end
  end

private
  def postgres_cache_key
    scope_sql = scoped.select("#{table_name}.id, #{table_name}.updated_at").to_sql

    sql = "SELECT md5(array_agg(id || '-' || updated_at)::text) " +
          "FROM (#{scope_sql}) as query"

    md5 = connection.select_value(sql)

    key = if md5.present?
      md5
    else
      "empty"
    end

    "#{model_name.cache_key}/#{key}"
  end

  def mysql_cache_key
    scope_sql = scoped.select("#{table_name}.id, #{table_name}.updated_at").to_sql
    return nil unless scope_sql.present?

    sql = "SELECT CONCAT(`id`, '-', `updated_at`) " +
          "FROM (#{scope_sql}) as query"

    concatenated_result = connection.select_values(sql).join(",")

    key = if concatenated_result.present?
      Digest::MD5.hexdigest(concatenated_result)
    else
      "empty"
    end

    "#{model_name.cache_key}/#{key}"
  end
end
