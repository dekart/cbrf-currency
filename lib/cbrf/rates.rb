require "hpricot"
require "open-uri"

module CBRF
  class Rates
    attr_reader :date, :currencies

    def self.for(date)
      url = "http://www.cbr.ru/currency_base/D_print.aspx?date_req=#{date.strftime('%d/%m/%Y')}"

      new(Hpricot(open(url)))
    end

    def initialize(document)
      @currencies = HashWithIndifferentAccess.new
      
      (document / "table table table tr").each_with_index do |row, index|
        next if index == 0

        currency = CBRF::Currency.new(row)
        
        @currencies[currency.symbol] = currency
      end
    end
  end
end