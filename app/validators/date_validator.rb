class DateValidator < ActiveModel::EachValidator

  def before(a, b);       a < b;  end
  def after(a, b);        a > b;  end
  def on_or_before(a, b); a <= b; end
  def on_or_after(a, b);  a >= b; end

  def validate_each(record, attribute, value)
    return unless value.present?
    unless options.blank?
      options.each do |key, compare_date|
        parsed_date = DateTime.parse(value)
        case key
          when :before
            unless before(parsed_date, compare_date)
              record.errors[attribute] << (options[:message] || "Date is before #{compare_date}")
            end
          when :after
            unless before(parsed_date, compare_date)
              record.errors[attribute] << (options[:message] || "Date is after #{compare_date}")
            end
          when :on_or_after
            unless on_or_after(parsed_date, compare_date)
              record.errors[attribute] << (options[:message] || "Date is on or after #{compare_date}")
            end
          when :on_or_before
            unless on_or_before(parsed_date, compare_date)
              record.errors[attribute] << (options[:message] || "Date is on or before #{compare_date}")
            end
        end
      end
    end
  end
end