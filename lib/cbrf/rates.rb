require "hpricot"
require "open-uri"

module CBRF
  class Rates
    cattr_accessor :cache

    attr_reader :date, :currencies

    def self.for(date)
      url = "http://www.cbr.ru/currency_base/D_print.aspx?date_req=#{date.strftime('%d/%m/%Y')}"

      if cache.is_a?(MemCache) and cached_rates = cache.get("cbrf_currency_#{ date }")
        return cached_rates
      else
        rates = new(Hpricot(open(url)))

        cache.set("cbrf_currency_#{ date }", rates, 1.day) if cache.is_a?(MemCache)

        return rates
      end
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