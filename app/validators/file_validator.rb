class FileValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return unless value.present?
    unless options.blank?
      options.each do | key, passed_ext |
        case key
          when :in
            unless(passed_ext.include?(File.extname(value)))
              record.errors[attribute] << (options[:message] || "file type is wrong")
            end
        end
      end
    end
  end

end