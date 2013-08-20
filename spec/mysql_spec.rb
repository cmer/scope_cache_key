require 'spec_helper'

describe ScopeCacheKey do
  def md5(scope)
    string = scope.all.map { |i| "#{i.id}-#{i.updated_at.strftime('%F %T')}" }.join(",")
    Digest::MD5.hexdigest string
  end

  before(:all) do
    Rails = OpenStruct.new(env: "mysql2")
    configure_db("mysql2", "root")
    create_schema
  end

  it_behaves_like "an adapter with scope_cache_key"
end