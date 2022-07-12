require 'benchmark'

# DTree stores a set of stings as a character tree that can be traversed with O(1) complexity to find
# if a given string is in the set. Supports exact matches and sequences of digits [0-9]
class DTree < Hash
  def initialize(*strings)
    super()
    strings.each { |s| add s }
  end

  # Add a string or char/token array, may contain :digits token.
  def add(s)
    s = s.chars rescue s
    if s.empty?
      self[:terminal] = true
    else
      (self[s[0]] ||= DTree.new).add(s[1..])
    end
  end

  # True if s is an exact match.
  def match(s) match_at(s, 0) == s.length; end

  # Returns length of match at index i of strign s, or nil if no match.
  def match_at(s, i)
    return 0 if self[:terminal] # Shortest match
    return nil if i >= s.size   # Incomplete match
    if d = self[s[i]]           # DTree for first character
      n = d.match_at(s, i+1)
      return n.nil? ? nil : n + 1
    end
    if (d = self[:digits]) && (nd = count_digits(s, i)) > 0 # Match digits wildcard
      n =  d.match_at(s, i+nd)
      return n.nil? ? nil : n + nd
    end
    return nil
  end

  # Find a match in string s, returns position and length of match.
  def find_in(s)
    i = 0
    while i < s.size
      n = match_at(s, i)
      return [i,n] if !n.nil?
      i += 1
    end
    return nil
  end

  private

  ZERO="0"
  NINE="9"

  def count_digits(s, i)
    start = i
    while i < s.size && ZERO <= s[i] && s[i] <= NINE
      i += 1
    end
    return i - start
  end
end
