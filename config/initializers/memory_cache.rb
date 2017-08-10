# set MemoryStoreClient as memcached client
begin
  endpoint = Rails.configuration.environment.fetch('memcached_node_endpoint')
  Rails.logger.info "Setting MemoryStoreClient as memcached client at #{endpoint}"

  MemoryStoreClient = Dalli::Client.new(endpoint,
                                        namespace: 'patient-api',
                                        compress: true,
                                        expires_in: 24*3600) # one day default
  MemoryStoreClient.set('test', true)
  MemoryCache.flush_all!
rescue
  Rails.logger.error "ERROR: Memcached client is not runing at #{endpoint}."
  exit
end
