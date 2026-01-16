---
layout: post
title: "A failing test for Christmas"
date: "2018-01-01"
tags:
  - technical
  - Ruby
  - Ruby on Rails
  - SQL
description: "It seems I have really well behaved on 2017, because Santa Claus brought me a failing test for Christmas. :stuck_out_tongue_winking_eye: I found out a piece of code, that was only wrong from 26th to 31st December. :christmas_tree:

Image you want to write a Ruby method for a Rails project, where you want to get all the users of the database that have birthday today or in the next 6 days, given that the birth date is stored in the database for all users. How would you do it?"

---

It seems I have really well behaved on 2017, because Santa Claus brought me a failing test for Christmas. :stuck_out_tongue_winking_eye: I found out a piece of code, that was only wrong from 26th to 31st December. :christmas_tree:



### The code

Imagine you want to write a Ruby method for a Rails project, where you want to get all the users of the database that have birthday today or in the next 6 days, given that the birth date is stored in the database for all users. How would you do it?

As for the birthday you don't care of the year of the dates, you could just replace the users' birth years by the current one and check if they are in the range you want. So, the code I found looked something like:

``` ruby
def next_birthdays_1(number_days)
  today = Date.current
  User.select do |user|
    (today..today + number_days.days).cover?(user.birthday.change(year: today.year))
  end
end
```

This code seemed to work. There was even a test for it and it passed. But on 26th December, the new year coming broke the test, showing that the code was wrong. For example, if a user was born on `01/01/1960`, the range `26/12/2017` to `01/01/2018` doesn't cover `01/01/2017`.

Let's fix the code! :muscle:

We can stop trying to be too smart and just testing if the day and month of the users birth dates match any of the dates in the range:

``` ruby
def next_birthdays_2(number_days)
  today = Date.current
  select do |user|
    (today..today + number_days.days).any? do |date|
      user.birthday.strftime('%d%m') == date.strftime('%d%m')
    end
  end
end
```

This code works and it works the whole year. :rofl: But what happens if now we want to get the birthdays of the next 30 days and we have for example 30000 users. Would this code be efficient enough? Can we do it better? :thinking:

One thing I come up with was reusing the original idea, that we do not care about the year, but using two dates instead. So to know if a user was born in `01/01/1960`, the range `26/12/2017` to `01/01/2018` should cover `01/01/2017` or `01/01/2018`. As for both dates, the birthday is the same one. So, we can write this as follows:

``` ruby
def next_birthdays_3(number_days)
  today = Date.current
  User.select do |user|
    (today..today + number_days.days).cover?(user.birthday.change(year: today.year)) ||
      (today..today + number_days.days).cover?(user.birthday.change(year: (today.year + 1)))
  end
end
```

But **this method is wrong, as it has a problem which also had the first one**. What happens if the user was born the 29th February of a leap year? `birthday.change(year: 2017)` would fail, as 2017 was not a leap year and 29th February of 2017 doesn't exist. :see_no_evil: But we can do a smart trick to keep using the same idea: using string comparison without taking into account the leap years! :smile: It would look like:

``` ruby
def next_birthdays_4(number_days)
  today = Date.current
  today_str = today.strftime('%Y%m%d')
  limit = today + number_days.days
  limit_str = limit.strftime('%Y%m%d')
  User.select do |user|
    birthday_str = user.birthday.strftime('%m%d')
    birthday_today_year = "#{today.year}#{birthday_str}"
    birthday_limit_year = "#{limit.year}#{birthday_str}"

    birthday_today_year.between?(today_str, limit_str) || birthday_limit_year.between?(today_str, limit_str)
  end
end
```

Note that this method is not equivalent to `next_birthdays_2`, as it returns the users that have birthday in 29th February if the range includes this date even if it is not a leap year. But I would say this is an advantage, as we do not want that the people who were born on 29th February do not have birthday party some years. :wink:


But remember that this is a Rails project, so we can do it even better if we reuse this idea to build an SQL query! :tada: For example, for [PostgreSQL](https://www.postgresql.org){:target="_blank"} 9.4:

``` ruby
def next_birthdays_5(number_days)
  today = Date.current
  today_str = today.strftime('%Y%m%d')
  limit = today + number_days.days
  limit_str = limit.strftime('%Y%m%d')
  User.where(
    "(('#{today.year}' || to_char(birthday, 'MMDD')) between '#{today_str}' and '#{limit_str}')" \
    'or' \
    "(('#{limit.year}' || to_char(birthday, 'MMDD')) between '#{today_str}' and '#{limit_str}')"
  )
end
```

As it already happened in `next_birthdays_4`, this method returns the users that have birthday in 29th February if the range includes this date even if it is not a leap year.


In PostgreSQL we have the `Date` type and from PostgreSQL 9.2 also `daterange` which we could have use to make this query more efficient. This would have been equivalent to `next_birthdays_3` and would have had the same problem, it fails with leap years.



### Efficiency

And now it is time to try it! Let check how efficient are the methods number 2, 4 and 5 (as the the other two doesn't work properly as we had already analysed).

I have created 30000 users with different birth dates using [Faker](https://github.com/stympy/faker){:target="_blank"}. I have executed the different methods to know the number of people with birthday in the next 31 days and I have measured the execution time using `Benchmark.measured`. Those are elapsed real times for every of the method in my computer:

- `next_birthdays_2(30)` ~ **3.3 seconds**
- `next_birthdays_4(30)` ~ **0.9 seconds**
- `next_birthdays_5(30)` ~ **0.0003 seconds**

Take into account that `next_birthdays_2` is much more affected by the number of days than the other two methods. But even for 6 days it is really slow, as the elapsed real time in my computer for `next_birthdays_2(6)` is arround **1.45 seconds**. 


### Conclusion

And the funny thing of all this is that, as it is already 2018, even if I haven't fixed the test yet, the Christmas failing test doesn't fail anymore. :joy: This is because we forgot to add test cases for the limit cases and help us to learn that when working with dates we have to pay special attention to the changes of year and to the 29th of February and the leap years. And of course all this should be properly tested.

Another thing we can learn from the post is that as Rails developers we should never forget that the database queries are always way more efficient than the Ruby code we write.

Last but not least, we may consider if the effort to write a method worths the time you need to invest to write it. For example, in this case we could have considered if we could have lived with a method which returns the birthdays this month, which is much easier to implement, instead of this more complicate option. Or, if we do not expect that out application has a lot of users, we could have even used `next_birthdays_2`.

And if you want to take a look at the original code which inspired this post, you can find it in the following PR: [https://github.com/openSUSE/agile-team-dashboard/pull/100](https://github.com/openSUSE/agile-team-dashboard/pull/100){:target="_blank"}

Happy new year! :christmas_tree: :champagne:

