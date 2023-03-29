require 'json'

class ApplicationReport
  def initialize(json_filename)
  end

  #
  # channel parameter
  #   * 'all': returns all applications
  #   * 'qr': filter applications with channel = 'qr'
  #   * 'sales': filter applications with channel = 'sales'
  #   * 'website': filter applications with channel = 'website'
  #
  # Returns the average number of applications by hour (0 to 23) depending on
  # the total number of days available in the JSON file.
  def retrieve_trend(channel = 'all')
  end
end