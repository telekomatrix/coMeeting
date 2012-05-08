module MeetingsHelper
  def current_date()
    Time.new.strftime("%d/%m/%Y")
  end

  def meeting_date(meeting)
    meeting.date.strftime("%d/%m/%Y")
  end
end