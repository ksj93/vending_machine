# このコードをコピペしてrubyファイルに貼り付け、そのファイルをirbでrequireして実行しましょう。

# 例

# irb
# require '/Users/shibatadaiki/work_shiba/full_stack/sample.rb'
# （↑のパスは、自動販売機ファイルが入っているパスを指定する）

# 初期設定（自動販売機インスタンスを作成して、vmという変数に代入する）
# vm = VendingMachine.new

# 作成した自動販売機に100円を入れる
# vm.slot_money (100)

# 作成した自動販売機に入れたお金がいくらかを確認する（表示する）
# vm.current_slot_money

# 作成した自動販売機に入れたお金を返してもらう
# vm.return_money

class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze

  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    @sales_money = 0
    @cola_stock = 5
    @juice_stock = 3
    @water_stock = 2
    @drink = {cola:150,juice:180,water:100}
  end

  # 投入金額の総計を取得できる。
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
    puts "3 買える飲み物を確認する"
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
      puts "次も利用してください！"
      return_money
    else
      puts "番号を押してください！"
      return start
    end
  end
  # def current_slot_money
  #   # 自動販売機に入っているお金を表示する
  #   puts "現在#{@slot_money}円"
  # end

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
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
    puts "コーラ　在庫:#{@cola_stock} 個　値段:#{@drink[:cola]} 円"
    puts "ジュース　在庫:#{@juice_stock} 個　値段:#{@drink[:juice]} 円"
    puts "水　在庫:#{@water_stock} 個　値段:#{@drink[:water]} 円"
  end
  def confirm_slot_money
    puts "現在の投入金額:#{@slot_money}円"
    @drink.each do |key,value|
      if @slot_money>value
        puts "#{key}が購入可能"
      else
        puts "#{key}は購入不可能"
      end
    end
  end
  # def buy_item
  #   puts "行動を選択してください"
  #   puts "1:購入　2:購入可能品目"
  #   select = gets.to_i
  #     if select == 1
  #       buy_item_calculate
  #     elsif select == 2
  #       confirm_slot_money
  #     end
  # end

  def buy_item_calculate
    puts "現在の投入金額:#{@slot_money}"
    puts "1:コーラ #{@drink[:cola]}円"
    puts "2:ジュース #{@drink[:juice]}円"
    puts "3:水 #{@drink[:juice]}円"
    puts "4:前に戻る"
    select_drink = gets.to_i
    if select_drink == 1
      if @slot_money>@drink[:cola]
        @slot_money=@slot_money-@drink[:cola]
        @cola_stock = @cola_stock -1
        @sales_money = @sales_money + @drink[:cola]
        puts "お釣りは#{@slot_money}円です。"
      else
        puts "金額が足りません！"
      end
    elsif select_drink == 2
      if @slot_money>@drink[:juice]
        @slot_money=@slot_money-@drink[:juice]
        @juice_stock = @juice_stock -1
        @sales_money = @sales_money + @drink[:juice]
        puts "お釣りは#{@slot_money}円です。"
      else
        puts "金額が足りません！"
      end
    elsif select_drink == 3
      if @slot_money>@drink[:water]
        @slot_money=@slot_money-@drink[:water]
        @water_stock = @water_stock -1
        @sales_money = @sales_money + @drink[:water]
        puts "お釣りは#{@slot_money}円です。"
      else
        puts "金額が足りません！"
      end
    elsif select_drink == 4
        return start
    else
      puts "ボタンを押して下さい"
    end
  end


  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    puts @slot_money
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end



end
