class Item_set
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
      return maintenance
    elsif maintenance_select == 2
      setting
      return maintenance
    elsif maintenance_select == 3
      restock_item
      return maintenance
    elsif maintenance_select == 4
      collect_sales_money
      return maintenance
    elsif maintenance_select == 5
      return run
    elsif maintenance_select>5 || maintenance_select == 0
      puts "ボタンを押して下さい"
      return maintenance
    end
  end

  def preset
    @drink = {cola:150,juice:180,water:100}
    @drink_stock ={cola:5,juice:3,water:2}
    @drink_jp ={cola:"コーラ",juice:"ジュース",water:"水"}
  end

  def setting
    puts "現在の品物"
    @drink_jp.each do |key,value|
      puts "#{value}　在庫:#{@drink_stock[key]} 個　値段:#{@drink[key]} 円"
    end
    puts "1 品物の追加"
    puts "2 品物の削除"
    puts "3 終わる"
    setting_select = gets.to_i
    if setting_select == 1
      add_item
      return setting
    elsif setting_select == 2
      delete_item
      return setting
    elsif setting_select == 3
      return maintenance
    elsif setting_select>3 || setting_select == 0
      puts "ボタンを押して下さい"
      return setting
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
    sales_item_list
    puts "1 選択削除"
    puts "2 全部削除"
    puts "3 戻る"
    delete_select = gets.to_i
    if delete_select == 1
      delete_item_select
      return delete_item
    elsif delete_select == 2
      @drink = {}
      @drink_stock ={}
      @drink_jp ={}
      puts "全ての品物が販売中止"
      return delete_item
    elsif delete_select == 3
      return setting
    elsif select_menu_num>3 || select_menu_num == 0
      puts "誤った入力です"
      return delete_item
    end
  end

  def sales_item_list(sales_list_argu = 0)
    if sales_list_argu == 0
      puts "販売中の品物"
      i=0
      puts "-"*15
      @drink_jp.each do |key,value|
        i+=1
        puts "#{i} #{value}"
      end
      puts "-"*15
    else
      puts "販売中の品物"
      i=0
      @drink_jp.each do |key,value|
        i+=1
        puts "#{i} #{value} 在庫:#{@drink_stock[key]}"
      end
      puts "#{i+1} 戻る"
    end
  end

  def delete_item_select
    select_del_drink = gets.to_i
    i = 0
    @drink_jp.each do |key,value|
      i +=1
      if select_del_drink == i
        @drink.delete(key)
        @drink_jp.delete(key)
        @drink_stock.delete(key)
        puts "#{value}は販売中止"
        return delete_item
      elsif select_del_drink == @drink_jp.size+1
        return delete_item
      elsif select_del_drink > @drink_jp.size+1 || select_del_drink == 0
        puts "ボタンを押して下さい"
        return
      end
    end
  end

  def restock_item
    sales_item_list("在庫")
    restock_item_select = gets.to_i
    i=0
    @drink_jp.each do |key,value|
      i +=1
      if restock_item_select == i
        stock_drink_num = gets.to_i
        @drink_stock[key] += stock_drink_num
        return restock_item
      elsif restock_item_select == @drink_jp.size+1
        return maintenance
      elsif restock_item_select>@drink_jp.size+1 || restock_item_select == 0
        puts "ボタンを押して下さい"
        return
      end
    end
  end

  def collect_sales_money
    @total_sales_money +=@sales_money
    @sales_money = 0
    puts "現在の総売り上げ:#{@total_sales_money}円です"
    return maintenance
  end

end

class VendingMachine < Item_set
  # 初期化
  def initialize
    super
  end

# 実行する
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
    @drink_jp.each do |key,value|
      if @slot_money>=@drink[key] && @drink_stock[key] >0
        puts "・#{value}が購入可能"
      elsif @slot_money<@drink[key] && @drink_stock[key] >0
        puts "・#{value}は購入不可能[投入金額不足]"
      elsif @slot_money>=@drink[key] && @drink_stock[key] ==0
        puts "・#{value}は購入不可能[在庫不足]"
      else
        puts "・#{value}は購入不可能"
      end
    end
  end

  def run
    puts "-"*30
    puts "自販機です。"
    puts "行いたい行動に該当する番号を押してください。"
    puts "-"*30
    puts ("//"*2) + "購入可能な飲み物" + ("//"*2)
    puts "-"*30
    confirm_slot_money
    puts "<"*20
    puts "1 お金を投入する"
    puts "2 飲み物を買う"
    puts "3 在庫＆売上確認"
    puts "4 終わる"
    puts ">"*20
    select_menu = gets.to_i
    if select_menu == 1
      puts "投入可能金額:10,50,100,500,1000円"
      insert_coin = gets.to_i
      slot_money(insert_coin)
      return run
    elsif select_menu == 2
      buy_item_calculate
      return run
    elsif select_menu == 3
      drink_stock
      return run
    elsif select_menu == 4
      return_money
      puts "次も利用してください！"
    else
      puts "番号を押してください！"
      return run
    end
  end

  def buy_item_list
    i=0
    puts "現在の投入金額:#{@slot_money}円"
    @drink_jp.each do |key,value|
      i +=1
      puts "#{i} #{value}　値段:#{@drink[key]} 円"
    end
    puts "#{i+1}:前に戻る"
  end

  def buy_item_calculate
    buy_item_list
    select_drink = gets.to_i
    i = 0
    @drink_jp.each do |key,value|
      i +=1
      if select_drink == i
        calculate_function(key)
        puts "#{value}です！"
      elsif select_drink>@drink_jp.size+1 || select_drink == 0
        puts "ボタンを押して下さい"
        return
      end
    end
  end

  def calculate_function(key)
    if @slot_money>=@drink[key] && @drink_stock[key] > 0
      @slot_money=@slot_money-@drink[key]
      @drink_stock[key] = @drink_stock[key]  -1
      @sales_money = @sales_money + @drink[key]
      puts "お釣りは#{@slot_money}円です。"
    else
      puts "売り切れ"
    end
  end

  def return_money
    puts "#{@slot_money}円を返します。"
    @slot_money = 0
  end
end

# 修正案
# 1.　場所によって、表記を変更しました。:232
# 2.　「購入できません」　→　「売り切れ」:300
# 3.　在庫不足　→　「2.飲み物を買う」の所でも、「在庫切れ＝売り切れ」の表記を表示。
#   　在庫ありの場合となしの場合で、分ける。267行（buy_item_list）クラス？メソッド？puts関係をまとめたい。
# 4.　1つ1つのメソッドに役割を明記することでさらに理解しやすくする。:181
