class SimpleTranspiler
  class << self
    def ruby2c(s)
      if s.instance_of?(String) then
        s
      elsif s.instance_of?(Array) && s[0].instance_of?(Symbol) then
        case s[0]
        when :assign
          ruby2c(s[1]) + "=" + ruby2c(s[2]) + ";"
          
        when :var_field
          s[1][1]
        
        when :var_ref
          case s[1][1]
          when "true", "false"
            s[1][1].upcase
          else
            s[1][1]
          end
          
        when :void_stmt
          "" # this happens when rip "if true then # do nothing end" type of code
        
        when :binary
          case s[2]
          when :or
            operator = "||"
          when :and
            operator = "&&"
          else
            operator = s[2].to_s
          end
          ruby2c(s[1]) + operator + ruby2c(s[3])
          
        when :opassign
          ruby2c(s[1]) + ruby2c(s[2]) + ruby2c(s[3]) + ";"
          
        when :unary
          case s[1]
          when :not, :!
            "!" + ruby2c(s[2])
          else
            ruby2c(s[2])
          end
          
        when :paren
          "(" + ruby2c(s[1][0]) + ")"
          
        when :symbol
          ':' + s[1][1]
          
        when :field, :call
          ruby2c(s[1]) + "."  + ruby2c(s[3])
          
        when :@ident, :@int, :@kw, :@op
          s[1]
          
        when :@tstring_content
          '"' + s[1] + '"'
        
        # commented out for simplification
        #when :vcall
          
        when :command
          ruby2c(s[1]) + "(" + ruby2c(s[2]) + ");"
          
        when :method_add_arg
          command = s[1][1][1]
          # check if it matches dsl.
          case command
          when "is_pressed"
            ruby2c(s[1]) + "(PAD_" + ruby2c(s[2]).delete(":").upcase + ")"
          when "rand"
            ruby2c(s[1]) + "8()"
          else
            ruby2c(s[1]) + "(" + ruby2c(s[2]) + ")"
          end
          
        # Currently pssing block is not supported
        #when :method_add_block
        
        when :args_add_block
          a = Array.new
          s[1].each_with_index do |sexp,i|
            a << ruby2c(sexp)
          end
          a.join(",")
          
        when :while
          "while(" + ruby2c(s[1]) + "){" + ruby2c(s[2]) + "}"
          
        when :if, :if_mod, :elsif
          if s[0]==:elsif then
            keyword = "else if"
          else
            keyword = "if"
          end
          additional_condition = ruby2c(s[3]) if !s[3].nil?
          "#{keyword} (" + ruby2c(s[1]) + "){" + ruby2c(s[2]) + "} #{additional_condition}"
          
        #when :def
        # is not supported for to_c as return data type cannot be defined
        
        when :else
          "else {" + ruby2c(s[1]) + " } "
          
        else
          ruby2c(s[1])
          
        end
      # Safety net
      elsif s.instance_of?(Array) && s[0].instance_of?(Array) then
        a = Array.new
        s.each_with_index do |sexp,i|
          a << ruby2c(sexp)
        end
        a.join("\n")
      end
    end
  end
end