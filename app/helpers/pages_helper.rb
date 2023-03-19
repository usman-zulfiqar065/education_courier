module PagesHelper
  def date_format(date)
    date.strftime('%d %b %Y')
  end
end