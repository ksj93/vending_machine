require './item_setting'

class VendingMachine < ItemSet
  def initialize
    super
    @atari_number =[]
  end

  def start(config = 0)
    if config == 0
      if @drink.size >0
        run
      else
        preset
        run
      end
    else
      maintenance
      run
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

  def confirm_slot_money
    puts "現在の投入金額:#{@slot_money}円"
    @drink_jp.each do |key,value|
      if @slot_money>=@drink[key] && @drink_stock[key] >0
        puts "#{value}が購入可能"
      elsif @slot_money>=@drink[key] && @drink_stock[key] ==0
        puts "#{value}[在庫不足]"
      elsif @slot_money<@drink[key] && @drink_stock[key] >0
        puts "#{value}[投入金額不足]"
      else
        puts "#{value}は購入不可能"
      end
    end
  end


  def run
    puts "-"*15
    puts "自販機です。"
    puts "行いたい行動に該当する番号を押してください。"
    puts "-"*15
    puts "購入可能な飲み物" + ("-"*4)
    puts "-"*15
    confirm_slot_money
    puts "//////////////////////////////"
    puts "1 お金を投入する"
    puts "2 飲み物を買う"
    puts "3 在庫＆売上確認"
    puts "4 終わる"
    puts "\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
    select_menu = gets.to_i
    if select_menu == 1
      puts "投入可能金額:10,50,100,500,1000円"
      insert_coin = gets.to_i
      slot_money(insert_coin)
      run
    elsif select_menu == 2
      buy_item_calculate(0)
      run
    elsif select_menu == 3
      drink_stock
      run
    elsif select_menu == 4
      return_money
      puts "次も利用してください！"
    else
      puts "番号を押してください！"
      run
    end
  end

  def buy_item_list(buy_or_free = 0)
    if buy_or_free == 0
      i=0
      puts "現在の投入金額:#{@slot_money}円"
      @drink_jp.each do |key,value|
        i +=1
        if @drink_stock[key]>0
          puts "#{i} #{value}　値段:#{@drink[key]} 円"
        else
          puts "#{i} #{value}　[売り切れ]"
        end
      end
      puts "#{i+1}:前に戻る"
    else
      i=0
      @drink_jp.each do |key,value|
        i +=1
        if @drink_stock[key]>0
          puts "#{i} #{value}"
        else
          puts "#{i} #{value}[売り切れ]"
        end
      end
    end

  end

  def buy_item_calculate(buy_or_nonbuy = 0)
    if buy_or_nonbuy == 0
      buy_item_list
      select_drink = gets.to_i
      i = 0
      @drink_jp.each do |key,value|
        i +=1
        if select_drink == i
          calculate_function(key)
        elsif select_drink>@drink_jp.size+1 || select_drink == 0
          puts "ボタンを押して下さい"
        end
      end
    else
      buy_item_list(1)
      select_drink = gets.to_i
      i = 0
      @drink_jp.each do |key,value|
        i +=1
        if select_drink == i
          if @drink_stock[key]>0
            @drink_stock[key] = @drink_stock[key]  -1
            puts "#{value}です！"
          else
            puts "売り切れ"
            buy_item_calculate(1)
          end
        elsif select_drink>@drink_jp.size || select_drink == 0
          puts "ボタンを押して下さい"
        end
      end
    end
  end

  def calculate_function(key)
    if @slot_money>=@drink[key] && @drink_stock[key] > 0
      @slot_money=@slot_money-@drink[key]
      @drink_stock[key] = @drink_stock[key]  -1
      @sales_money = @sales_money + @drink[key]
      puts "#{@drink_jp[key]}です！"
      puts "お釣りは#{@slot_money}円です。"
      win_game
    elsif @drink_stock[key] == 0
      puts "売り切れ"
    elsif @slot_money < @drink[key]
      puts "お金が足りません"
    end
  end

  def return_money
    puts "#{@slot_money}円を返します。"
    @slot_money = 0
  end

  private

    def win_game
      puts "ルーレット始まります"
      free_gift
      if @atari_number.uniq.size == 1
        puts "当たり、飲み物を選んでください"
        buy_item_calculate(1)
        @atari_number = []
      else
        puts "残念！次の機会に…"
        @atari_number = []
      end
    end

    def free_gift
      @atari_number = Array.new(3,rand(0..9))
      @atari_number << rand(0..9)
      for i in 0..3
        sleep(0.7)
        puts @atari_number[i]
      end
      sleep(0.3)
      number_display = @atari_number.clone
      p number_display.join
    end

end
