module CBRF
  class Currency
    attr_reader :code, :symbol, :units, :name, :rate

    def initialize(row)
      cells = row / "td"

      @code   = cells[0].inner_text.strip.to_i
      @units  = cells[2].inner_text.strip.to_i
      @name   = cells[3].inner_text.strip.chars[2..-1]
      @rate   = cells[4].inner_text.strip.sub(",", ".").to_f

      # Fix for HTML markup bugs
      row.search("td:nth(1)>td").remove
      
      @symbol = cells[1].inner_text.gsub(/[^A-Z]+/, "").upcase.to_sym
    end
  end
end