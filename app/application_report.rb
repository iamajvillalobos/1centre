require "json"
require "date"

class ApplicationReport
  def initialize(json_filename)
    file = File.read(json_filename)
    @applications = JSON.parse(file, object_class: OpenStruct).applications
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
    filtered_apps = filter_by_channel(channel)
    apps_by_day = group_by_day(filtered_apps)
    hourly_trend = calculate_hourly_trend(apps_by_day)
    calculate_average_trend(hourly_trend, apps_by_day.size)
  end

  private

  def filter_by_channel(channel)
    return @applications if channel == "all"

    @applications.select { |app| app.channel == channel }
  end

  def group_by_day(applications)
    applications.group_by do |app|
      Date.parse(app.timestamp)
    end
  end

  def calculate_hourly_trend(applications_by_day)
    trend = {}

    applications_by_day.each do |day, apps|
      apps.each do |app|
        datetime = DateTime.parse(app.timestamp)
        hour = datetime.hour

        trend[hour] ||= 0
        trend[hour] += 1
      end
    end

    trend
  end

  def calculate_average_trend(hourly_trend, days_count)
    hourly_trend.each_with_object({}) do |(hour, value), avg_trend|
      avg_trend[hour] = (value.to_f / days_count).round
    end
  end
end
