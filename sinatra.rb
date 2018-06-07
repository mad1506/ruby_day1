require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'nokogiri'
require 'json'

get '/menu' do
    menu = ["20층", "순남시래기", "양자강", "한우"]
    lunch = menu.sample
    lunch+'를 드세요.'
end

get '/lotto' do
    numbers = *(1..45)
    lotto = numbers.sample(6).sort

    lotto.to_s
end

get '/kospi' do
    response = HTTParty.get("http://finance.daum.net/quote/kospi.daum")

    kospi = Nokogiri::HTML(response)

    result = kospi.css("#hyenCost > b")

    '현재 코스피 지수는 '+result.text+'입니다.'
end

get '/check_lotto' do
   url = 'http://m.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809'
   lotto = HTTParty.get(url)
   result = JSON.parse(lotto)
   numbers = []
   bonus = result["bnusNo"]
   result.each do |k, v|
       if k.include?("drwtNo")
           numbers << v
       end
   end
   my_numbers = *(1..45)
   my_lotto = my_numbers.sample(6).sort
   
   count = 0
   bnscount = 0
   numbers.each do |num|
       count += 1 if my_lotto.include?(num)
   end
   bnscount = 1 if my_lotto.include?(bonus)
   
   if count == 6
      my_result = "1등"
   elsif count == 5 and bnscount == 1
      my_result = "2등"
   elsif count == 5
      my_result = "3등"
   elsif count == 4
      my_result = "4등"
   elsif count == 3
      my_result = "5등"
   else
      my_result = "꽝"
   end
   puts count, bnscount
   my_result
end

get '/html' do
    "<html>
        <head></head>
        <body>
            <h1>안녕하세요? 저는 바보입니다.</h1>
        </body>
    </html>"
end

get '/html_file' do
   @name = params[:name]
   name = "Hoho"
   erb :my_first_html
end

get '/calculate' do
   num1 = params[:num1].to_i
   num2 = params[:num2].to_i
   @add_result = num1 + num2
   @cha_result = num1 - num2
   @mul_result = num1 * num2
   @na_result = num1 / num2
   erb :calculate_html
end