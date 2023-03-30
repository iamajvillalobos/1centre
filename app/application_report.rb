require "json"
require "date"

class ApplicationReport
  def initialize(json_filename)
    file = File.read(json_filename)
    @applications = JSON.parse(file, object_class: OpenStruct).applications
    @trend = {}
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
  def retrieve_trend(channel = "all")
    filter_by_channel(channel)
    group_by_day
    calculate_hourly_trend
    calculate_average_trend

    @trend
  end

  private

  def filter_by_channel(channel)
    return if channel == "all"

    @applications.select { |app| app.channel == channel }
  end

  def group_by_day
    @applications_by_day = @applications.group_by do |app|
      Date.parse(app.timestamp)
    end
  end

  def calculate_hourly_trend
    @applications_by_day.each do |day, apps|
      apps.each do |app|
        datetime = DateTime.parse(app.timestamp)

        @trend[datetime.hour] ||= 0
        @trend[datetime.hour] += 1
      end
    end
  end

  def calculate_average_trend
    @trend.each do |hour, value|
      @trend[hour] = (value.to_f / @applications_by_day.size).round
    end
  end
end
