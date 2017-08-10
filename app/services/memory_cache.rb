module MemoryCache
  extend self

  def memoize(*key_fragments, &block)
    # cache hit
    key = key_fragments.hash
    cached_value = read(key)
    return cached_value if cached_value

    # cache miss
    puts "Cache miss: [#{key}]"
    new_value = block.call
    write(key, new_value)
    new_value
  end

  def read(key)
    value = MemoryStoreClient.get(key)
    puts "Cache hit: [#{key}] => #{value.inspect[0..20]}..."
    value
  end

  def write(key, value)
    puts "Cache write: [#{key}] => #{value.inspect[0..20]}..."
    MemoryStoreClient.set(key, value)
  end

  def flush_all!
    MemoryStoreClient.flush
    puts "Cache flushed."
  end
end
