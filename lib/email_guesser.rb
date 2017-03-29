class EmailGuesser

  # Create array of possible first names from file
  @first_names = []
  File.open(File.join(File.dirname(__FILE__), "first_names.txt"), "r").each do |line|
    @first_names.push(line.chomp)
  end

  # Create array of possible last names from file
  @last_names = []
  File.open(File.join(File.dirname(__FILE__), "last_names.txt"), "r").each do |line|
    @last_names.push(line.chomp)
  end

  # Determine domain given an email address as argument
  def self.domain(address)
    if address.empty?
      nil
    else
      address.split('@')[1]
    end
  end

  def self.get_format(address)
    if address.empty?
      nil
    else
      @prefix = address.split("@")[0]
      if @prefix.split(".").length == 1
        if self.is_first_name?(@prefix)
          "first"
        elsif self.is_last_name?(@prefix)
          "last"
        elsif self.is_last_name?(@prefix[1,@prefix.length-1])
          "flast"
        elsif self.is_first_last_combined?(@prefix)
          "firstlast"
        else
          "unknown"
        end
      elsif @prefix.split(".").length == 2 && @prefix.split(".")[0].length > 1 && @prefix.split(".")[1].length > 1
        "first.last"
      elsif @prefix.split(".").length == 2 && @prefix.split(".")[0].length == 1
        "f.last"
      else
        "first.l"
      end
    end
  end

  def self.is_first_name?(string)
    if string.empty?
      return false
    elsif @first_names.include? string.chomp.downcase
      return true
    else
      return false
    end
  end

  def self.is_last_name?(string)
    if string.empty?
      return false
    elsif @last_names.include? string.chomp.downcase
      return true
    else
      return false
    end
  end

  def self.is_first_last_combined?(string)
    if string.empty? || string.length < 5
      nil
    else
      len = string.length
      for i in (1..len-3)
        segment = string[0,i]
        if self.is_first_name?(segment)
          return true
        end
      end
    end
  end

end
