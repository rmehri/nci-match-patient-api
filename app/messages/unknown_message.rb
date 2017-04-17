
class UnknownMessage < AbstractMessage

  def from_json(json, include_root=include_root_in_json)
    raise Errors::ResourceNotFound, "Unknown Message type for #{json}"
  end

end