class User < ActiveRecord::Base
  def age
    date_format = "%Y%m%d"
    today_timestamp = Date.today.strftime(date_format).to_i
    birth_date_timestamp = birth_date.strftime(date_format).to_i
    (today_timestamp - birth_date_timestamp) / 10000
  end
end
