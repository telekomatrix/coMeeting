module MeetingsHelper
  def current_date(meeting)
    if meeting.new_record?
      d = Time.new
    else
      d = meeting.date
    end
    d.strftime("%d-%m-%Y")
  end
end