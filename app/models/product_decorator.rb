Product.class_eval do

  def option_values
    vals = option_types.map{|i| i.option_values }.flatten.uniq
  end
  
  def grouped_option_values
    option_values.group_by(&:option_type)
  end
  
  def variant_options_hash  
    return @variant_options_hash if @variant_options_hash
    @variant_options_hash = Hash[grouped_option_values.map{ |type, values| 
      [type.id.inspect, Hash[values.map{ |value|         
        [value.id.inspect, Hash[variants.includes(:option_values).select{ |variant| 
          variant.option_values.select{ |val| 
            val.id == value.id && val.option_type_id == type.id 
          }.length == 1 }.map{ |v| [ v.id, { :count => v.count_on_hand, :price => v.price } ] }]
        ]
      }]]
    }]
  end
  
end
