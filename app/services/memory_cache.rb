module MemoryCache
  extend self

  def memoize(*key_fragments, &block)
    # cache hit
    key = key_fragments.hash
    cached_value = read(key)
    return cached_value if cached_value

    # cache miss
    new_value = block.call
    write(key, new_value)
    new_value
  end

  def read(key)
    value = MemoryStoreClient.get(key)
    AppLogger.log(self, "read [#{key}] => #{value.inspect[0..50]}...")
    value
  end

  def write(key, value)
    AppLogger.log(self, "write [#{key}] => #{value.inspect[0..50]}...")
    MemoryStoreClient.set(key, value)
  end

  def flush_all!
    MemoryStoreClient.flush
    AppLogger.log(self, 'flushed')
  end
end
