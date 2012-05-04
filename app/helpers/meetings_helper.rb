module MeetingsHelper
  def current_date
    return Time.new.strftime("%d-%m-%Y")
  end
end