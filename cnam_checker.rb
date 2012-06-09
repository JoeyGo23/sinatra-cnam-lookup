class Checker
  attr_reader :results

  def initialize(name, tel)
    @results = cnam_results(tel)
    @name = name.downcase
  end

  def pass?
    @results == @name
  end

  private

  def cnam_results(tel)
    begin
      response = open("https://api.opencnam.com/v1/phone/#{tel}?format=json").read
      results = JSON.parse(response)
      results["cnam"].downcase.split(" ").reverse.join(" ")
    rescue
      nil
    end
  end
end