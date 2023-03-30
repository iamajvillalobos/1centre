require "json"
require "date"

class ApplicationReport
  def initialize(json_filename)
    file = File.read("./applications.json")
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
    filtered_by_channel = if channel == "all"
      @applications
    else
      @applications.select { |app| app.channel == channel }
    end

    filtered_by_day = filtered_by_channel.group_by do |app|
      Date.parse(app.timestamp)
    end

    filtered_by_day.each do |day, apps|
      apps.each do |app|
        datetime = DateTime.parse(app.timestamp)

        @trend[datetime.hour] ||= 0
        @trend[datetime.hour] += 1
      end
    end

    @trend.each do |hour, value|
      @trend[hour] = (value.to_f / filtered_by_day.size).round
    end

    @trend
  end
end
