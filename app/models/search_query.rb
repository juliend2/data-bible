class SearchQuery
  QUOTED_STRING = :QUOTED_STRING
  STRING = :STRING
  OR = :OR
  AND = :AND
  NEGATIVE_MATCH = :NEGATIVE_MATCH
  LEFT_PAREN = :LEFT_PAREN
  RIGHT_PAREN = :RIGHT_PAREN

  class Lexer
    
    def tokenize(code)
      # Cleanup code by remove extra line breaks
      code.chomp!
      
      # Current character position we're parsing
      i = 0
      
      # Collection of all parsed tokens in the form [:TOKEN_TYPE, value]
      tokens = []
      
      # This is how to implement a very simple scanner.
      # Scan one character at the time until you find something to parse.
      while i < code.size
        chunk = code[i..-1]
        
        if string = chunk[/\A"(.*?)"/, 1]
          tokens << [QUOTED_STRING, string]
          i += string.size + 2

        # Match long operators such as ||, &&, ==, !=, <= and >=.
        # One character long operators are matched by the catch all `else` at the bottom.
        elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
          operator_keyword = case operator
          when '||' then OR
          when '&&' then AND
          end
          tokens << [operator_keyword, operator]
          i += operator.size
        
        elsif parenthese = chunk[/\A(\(|\))/, 1]
          paren = if parenthese == '('
            LEFT_PAREN
          elsif parenthese == ')'
            RIGHT_PAREN
          end
          tokens << [paren, parenthese]
          i += 1

        # Ignore whitespace
        elsif chunk.match(/\A /)
          i += 1
        
        # Catch all single characters
        # We treat all other single characters as a token. Eg.: ( ) , . ! + - <
        else
          value = chunk[0,1]
          if tokens.empty? || tokens.last[0] != STRING
            tokens << [STRING, value]
          else
            tokens.last[1] << value
          end
          i += 1
          
        end
        
      end
      
      tokens
    end
  end

  def initialize(string)
    @string = string
    lexer = Lexer.new
    @tokens = lexer.tokenize(@string)
    @column = 'verse_versions.content'
  end

  attr_reader :string, :tokens

  def to_sql
    str = ''
    while @tokens.size > 0
    # @tokens.each_with_index do |token, i|
      token = @tokens.first
      (type, value) = token
      if type == STRING || type == QUOTED_STRING
        str << "#{@column} LIKE '%#{value}%'"
        @tokens.shift
      elsif type == NEGATIVE_MATCH
        negative_match = @tokens[1]
        str << "#{@column} NOT LIKE '%#{negative_match}%'"
        @tokens.shift(2)
      elsif type == LEFT_PAREN || type == RIGHT_PAREN
        str << "#{value}"
        @tokens.shift
      elsif type == OR
        str << " OR "
        @tokens.shift
      elsif type == AND
        str << " AND "
        @tokens.shift
      else
        @tokens.shift
      end
    end
    str
  end
end
