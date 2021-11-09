class ItemSet
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize
    @total_sales_money = 0
    @slot_money = 0
    @sales_money = 0
    @drink = {}
    @drink_stock ={}
    @drink_jp ={}

  end

  def maintenance
    puts "-"*15
    puts "管理モード"
    puts "現在総売上金額:#{@total_sales_money}円"
    puts "-"*15
    puts "1 プリセット"
    puts "2 品物の追加・除去"
    puts "3 在庫追加"
    puts "4 売上金額回収"
    puts "5 終わる"
    puts "-"*15
    maintenance_select = gets.to_i
    if maintenance_select == 1
      preset
      maintenance
    elsif maintenance_select == 2
      setting
      maintenance
    elsif maintenance_select == 3
      restock_item
      maintenance
    elsif maintenance_select == 4
      collect_sales_money
      maintenance
    elsif maintenance_select == 5

    elsif maintenance_select>5 || maintenance_select == 0
      puts "ボタンを押して下さい"
      maintenance
    end
  end

  def preset
    @drink = {cola:150,juice:180,water:100}
    @drink_stock ={cola:5,juice:3,water:2}
    @drink_jp ={cola:"コーラ",juice:"ジュース",water:"水"}
  end

  def drink_stock
    puts "現在の売上金額:#{@sales_money}円"
    @drink_jp.each do |key,value|
      puts "#{value}　在庫:#{@drink_stock[key]} 個　値段:#{@drink[key]} 円"
    end
  end

  def setting
    drink_stock
    puts "1 品物の追加"
    puts "2 品物の削除"
    puts "3 終わる"
    setting_select = gets.to_i
    if setting_select == 1
      add_item
    elsif setting_select == 2
      delete_item
    elsif setting_select == 3

    elsif setting_select>3 || setting_select == 0
      puts "ボタンを押して下さい"
      setting
    end

  end

  def add_item
    puts "売る飲み物の英名を入力してください"
    key_insert = gets.chomp
    puts "売る飲み物の品名を入力してください"
    drink_jp_title = gets.chomp
    puts "売る飲み物の在庫を入力してください"
    drink_stock_number = gets.to_i
    puts "売る飲み物の値段を入力してください"
    drink_price =gets.to_i
    @drink_jp.store(key_insert,drink_jp_title)
    @drink_stock.store(key_insert,drink_stock_number)
    @drink.store(key_insert,drink_price)
  end

  def delete_item
    puts "1 選択削除"
    puts "2 全部削除"
    puts "3 戻る"
    delete_select = gets.to_i
    if delete_select == 1
      delete_item_select
    elsif delete_select == 2
      @drink = {}
      @drink_stock ={}
      @drink_jp ={}
      puts "全ての品物が販売中止"
    elsif delete_select == 3

    elsif delete_select > 3 || delete_select == 0
      puts "誤った入力です"
      delete_item
    end
  end

  def sales_item_list
    puts "販売中の品物"
    i=0
    @drink_jp.each do |key,value|
      i+=1
      puts "#{i} #{value}"
    end
    puts "#{i+1} 戻る"
  end

  def delete_item_select
    sales_item_list
    select_del_drink = gets.to_i
    i = 0
    @drink_jp.each do |key,value|
      i +=1
      if select_del_drink == i
        @drink.delete(key)
        @drink_jp.delete(key)
        @drink_stock.delete(key)
        puts "#{value}は販売中止"
        delete_item
      elsif select_del_drink == @drink_jp.size+1
        delete_item
      elsif select_del_drink > @drink_jp.size+1 || select_del_drink == 0
        puts "ボタンを押して下さい"

      end
    end
  end

  def restock_item
    sales_item_list
    restock_item_select = gets.to_i
    i=0
    @drink_jp.each do |key,value|
      i +=1
      if restock_item_select == i
        stock_drink_num = gets.to_i
        @drink_stock[key] += stock_drink_num
        restock_item
      elsif restock_item_select == @drink_jp.size+1

      elsif restock_item_select > @drink_jp.size+1 || restock_item_select == 0
        puts "ボタンを押して下さい"
        restock_item
      end
    end
  end

  def collect_sales_money
    @total_sales_money +=@sales_money
    @sales_money = 0
    puts "現在の総売り上げ:#{@total_sales_money}円です"
  end

end
