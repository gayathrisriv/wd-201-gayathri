def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
  x = []
  for i in dns_raw
    if (i[0] == "#")
      dns_raw.delete(i)
    end
  end

  for i in dns_raw
    x.push(i.split(",").map(&:strip))
  end

  for i in x
    if i == [""]
      x.delete(i)
    end
  end

  dns_raw = Hash[x.map.with_index { |x, i = 1| [i + 1, x] }]
  return dns_raw
end

def resolve(dns_records, lookup_chain, domain)
  class_Name_found = false  # The class_name_found use to find domain is in A class CNAME class
  domain_found = false  # The domain_found is use to cheak the domain is on the list or not.
  for isValues in dns_records.values # is values are use to itearate the dns_rocords.values
    for isDomain in isValues #isDomain is use to find the the domain is here or not.
      domain_find = isValues.length
      if isDomain == domain
        domain_found = true
        if class_Name_found == false
          if isValues[0] == "A"
            domain = isValues[domain_find - 1]
            lookup_chain.push(domain)
            class_Name_found = true
          end
          if isValues[0] == "CNAME"
            domain = isValues[domain_find - 1]
            isValues.delete(isValues[0])
            lookup_chain.push(domain)
            resolve(dns_records, lookup_chain, domain)
          end
        end
      end
    end
  end

  if domain_found == false
    print "Error: record not found for "
  end
  return lookup_chain
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
