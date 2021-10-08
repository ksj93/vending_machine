class VendingMachine
  MONEY = [10, 50, 100, 500, 1000].freeze

  def initialize
    @slot_money = 0
    @sales_money = 0
    @drink = {cola:150,juice:180,water:100}
    @drink_stock ={cola:5,juice:3,water:2}
    @drink_jp ={cola:"コーラ",juice:"ジュース",water:"水"}
  end

  def start
    puts "-"*15
    puts "自販機です。"
    puts "行いたい行動に該当する番号を押してください。"
    puts "-"*15
    puts "購入可能な飲み物" + ("-"*4)
    puts "-"*15
    confirm_slot_money
    puts "-"*15
    puts "1 お金を投入する"
    puts "2 飲み物を買う"
    puts "3 在庫＆売上確認"
    puts "4 終わる"
    puts "-"*15
    select_menu = gets.to_i
    if select_menu == 1
      puts "投入可能金額:10,50,100,500,1000円"
      insert_coin = gets.to_i
      slot_money(insert_coin)
      return start
    elsif select_menu == 2
      buy_item_calculate
      return start
    elsif select_menu == 3
      drink_stock
      return start
    elsif select_menu == 4
      return_money
      puts "次も利用してください！"
    else
      puts "番号を押してください！"
      return start
    end
  end

  def slot_money(money)
    if MONEY.include?(money) ==false
      puts "投入出来ない金額です。"
    else
      @slot_money += money
      puts "#{@slot_money}円を投入しました。"
      puts "現在投入金額:#{@slot_money}円"
    end
  end

  def drink_stock
    puts "現在の売上金額:#{@sales_money}円"
    @drink_jp.each do |key,value|
      puts "#{value}　在庫:#{@drink_stock[key]} 個　値段:#{@drink[key]} 円"
    end
  end

  def confirm_slot_money
    puts "現在の投入金額:#{@slot_money}円"
    @drink.each do |key,value|
      if @slot_money>=@drink[key] && @drink_stock[key] >0
        puts "#{key}が購入可能"
      else
        puts "#{key}は購入不可能"
      end
    end
  end

  def buy_item_list
    i=0
    puts "現在の投入金額:#{@slot_money}円"
    @drink_jp.each do |key,value|
      i +=1
      puts "#{i} #{value}　値段:#{@drink[key]} 円"
    end
    puts "4:前に戻る"
  end
  # buy_item_calculateで選択肢の部分を別のメソッドに分離(211008_kim)

  def buy_item_calculate
    buy_item_list
    select_drink = gets.to_i
    if select_drink == 1
      calculate_function(:cola)
    elsif select_drink == 2
      calculate_function(:juice)
    elsif select_drink == 3
      calculate_function(:water)
    elsif select_drink == 4
        return start
    else
      puts "ボタンを押して下さい"
    end
  end
  # 選択に該当する処理が重複したのでkeyという引数を使うcalculate_functionに分離(211008_kim)

  def calculate_function(key)
    if @slot_money>=@drink[key] && @drink_stock[key] > 0
      @slot_money=@slot_money-@drink[key]
      @drink_stock[key] = @drink_stock[key]  -1
      @sales_money = @sales_money + @drink[key]
      puts "お釣りは#{@slot_money}円です。"
    else
      puts "購入出来ません！"
    end
  end

  def return_money
    puts "#{@slot_money}円を返します。"
    @slot_money = 0
  end
end
