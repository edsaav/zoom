class EmailGuesser

  def initialize()
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
  end

  # Determine domain given an email address as argument
  def domain(address)
    return address.split('@')[1] unless address.empty?
    nil
  end

  def get_format(address)
    if address.empty?
      nil
    else
      a = address.split("@")[0]
      if a.split(".").length == 1
        if is_first_name?(a)
          "first"
        elsif is_last_name?(a)
          "last"
        elsif is_last_name?(a[1,a.length-1])
          "flast"
        elsif is_first_last_combined?(a)
          "firstlast"
        else
          "unknown"
        end
      elsif a.split(".").length == 2 && a.split(".")[0].length > 1 && a.split(".")[1].length > 1
        "first.last"
      elsif a.split(".").length == 2 && a.split(".")[0].length == 1
        "f.last"
      else
        "first.l"
      end
    end
  end

  def is_first_name?(string)
    return true if @first_names.include?(string.chomp.downcase) && ! string.empty?
    false
  end

  def is_last_name?(string)
    return true if @last_names.include?(string.chomp.downcase) && ! string.empty?
    false
  end

  def is_first_last_combined?(string)
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

  def generate_email(first_name, last_name, sample_email)
    email_format = self.get_format(sample_email)
    suffix = "@" + self.domain(sample_email)
    case email_format
    when "first"
      first_name.downcase + suffix
    when "last"
      last_name.downcase + suffix
    when "flast"
      first_name[0,1].downcase + last_name.downcase + suffix
    when "firstlast"
      first_name.downcase + last_name.downcase + suffix
    when "first.last"
      first_name.downcase + "." + last_name.downcase + suffix
    when "f.last"
      first_name[0,1].downcase + "." + last_name.downcase + suffix
    when "first.l"
      first_name.downcase + "." + last_name[0,1].downcase + suffix
    else
      "ERROR GUESSING EMAIL"
    end
  end

end
