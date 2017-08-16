# set MemoryStoreClient as memcached client
begin
  endpoint = Rails.configuration.environment.fetch('memcached_node_endpoint')
  Rails.logger.info "Setting MemoryStoreClient as memcached client at #{endpoint}"

  MemoryStoreClient = Dalli::Client.new(endpoint,
                                        namespace: 'patient-api',
                                        compress: true,
                                        expires_in: 24*3600) # one day default
  MemoryStoreClient.set('test', true)
rescue
  Rails.logger.error "ERROR: Memcached client is not reachable at #{endpoint}."
  exit
end

# set connection pool
MemoryStoreClientPool = ConnectionPool.new(size: 5, timeout: 5) { MemoryStoreClient }

# invalidate all
MemoryCache.flush_all!
