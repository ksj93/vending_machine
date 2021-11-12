# ItemSetクラス:5
# VendingMachineクラス

# 管理に関する部分を集まったクラス
class ItemSet
  # 投入する貨幣は決まっているので定数として定義
  MONEY = [10, 50, 100, 500, 1000].freeze

  # インスタンスを生成する時の初期化
  def initialize
    # @total_sales_moneyは全体の売上金額
    @total_sales_money = 0
    # 投入金額
    @slot_money = 0
    # 売る上げ金額
    @sales_money = 0
    # 商品の価格
    # @drink、@drink_stock、@drink_jpは同じキーを使う
    @drink = {}
    # 商品の在庫
    @drink_stock ={}
    # 商品の品名
    @drink_jp ={}
  end

  # メニュー式で他のコードに接近するメソッド
  def maintenance
    puts "-----------------------------------------"
    puts "管理モード"
    puts "現在総売上金額:#{@total_sales_money}円"
    puts "-----------------------------------------"
    puts "1 プリセット"
    puts "2 品物の追加・除去"
    puts "3 在庫追加"
    puts "4 売上金額回収"
    puts "5 終わる"
    puts "-----------------------------------------"
    # メニュー選択
    # getsで受けた数字と同じ条件の処理を行う
    # getsの後ろにto_iがついたのはgetsに入れた数字は文字扱いされるため整数に変える必要がある
    maintenance_select = gets.to_i

    # presetの処理が終わったら、maintenanceを行う
    # ターミナル上ではメニューに戻ったように見える(下のコードも同じ流れの処理)
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
    # maintenanceの処理が終わる
    elsif maintenance_select == 5

    # 1から5の範囲の以外の数字を入れれば、メッセージを表示した後、もう一回、maintenanceメソッドを行う
    # maintenance_select == 0はgets.to_iによって文字を入れた時、
    # 文字は全部0に返すため、文字の誤入力を防ぐ為入れた条件
    elsif maintenance_select>5 || maintenance_select == 0
      puts "ボタンを押して下さい"
      maintenance
    end
  end

  # 基本的な品揃え
  # presetメソッドを行うと基本的な品目を追加する
  def preset
    @drink = {cola:150,juice:180,water:100}
    @drink_stock ={cola:5,juice:3,water:2}
    @drink_jp ={cola:"コーラ",juice:"ジュース",water:"水"}
  end

  # 品目の在庫、売上金額を確認する
  def drink_stock
    puts "現在の売上金額:#{@sales_money}円"
    @drink_jp.each do |key,value|
      puts "#{value}　在庫:#{@drink_stock[key]} 個　値段:#{@drink[key]} 円"
    end
  end

  # 品目の追加や削除するメソッドに行くためのメニュータイプのメソッド
  # maintenanceメソッドで２番を選択するとsettingメソッドを行う
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

  # 品目を追加するメソッド
  # getsメソッドを通して、品目の情報を入力する
  def add_item
    puts "売る飲み物の英名を入力してください"
    key_insert = gets.chomp
    puts "売る飲み物の品名を入力してください"
    drink_jp_title = gets.chomp
    puts "売る飲み物の在庫を入力してください"
    drink_stock_number = gets.to_i
    puts "売る飲み物の値段を入力してください"
    drink_price =gets.to_i
    上で入力した内容を変数に入れて、その変数をキーと内容としてハッシュに格納
    @drink_jp.store(key_insert,drink_jp_title)
    @drink_stock.store(key_insert,drink_stock_number)
    @drink.store(key_insert,drink_price)
  end

  # 品目の削除のメニュー
  # getsを使用して分岐
  def delete_item
    puts "1 選択削除"
    puts "2 全部削除"
    puts "3 戻る"
    delete_select = gets.to_i
    if delete_select == 1
      delete_item_select

    # ２を入力すると３個のハッシュが空きになる
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

  # 削除する時、物の選択と確認の為の現在商品のリスト
  # 商品の品名の情報を持っている@drink_jpハッシュを繰り返してリストを作る
  def sales_item_list
    puts "販売中の品物"
    i=0
    @drink_jp.each do |key,value|
      i+=1
      puts "#{i} #{value}"
    end
    puts "#{i+1} 戻る"
  end

  # 1個づつ削除するメソッド
  def delete_item_select
    # 売っている物のリスト
    sales_item_list
    # getsを使用した分岐
    select_del_drink = gets.to_i
    i = 0
    # ハッシュ一つを繰り返して、iが条件(入力した数字)が一致するとその時のデータを削除する
    @drink_jp.each do |key,value|
      i +=1
      if select_del_drink == i
        # キーを同じく設定したので削除する時も一つのハッシュの繰り返しで、キーを参照して３個のハッシュ全部削除
        @drink.delete(key)
        @drink_jp.delete(key)
        @drink_stock.delete(key)
        puts "#{value}は販売中止"
        # 上の処理が終わった後、削除メニューに戻る
        delete_item
      elsif select_del_drink == @drink_jp.size+1
        delete_item
      elsif select_del_drink > @drink_jp.size+1 || select_del_drink == 0
        puts "ボタンを押して下さい"

      end
    end
  end

  # 在庫を追加するメソッド
  def restock_item
    # 売っている物のリスト
    sales_item_list
    restock_item_select = gets.to_i
    i=0
    # ハッシュ一つを繰り返して、iが条件(入力した数字)が一致するとその時のデータの在庫を追加する
    @drink_jp.each do |key,value|
      i +=1
      if restock_item_select == i
        # 在庫として追加する数量
        stock_drink_num = gets.to_i
        # 在庫を追加するので@drink_stockの足す
        @drink_stock[key] += stock_drink_num
        # メニュー戻る
        restock_item
      elsif restock_item_select == @drink_jp.size+1

      elsif restock_item_select > @drink_jp.size+1 || restock_item_select == 0
        puts "ボタンを押して下さい"
        restock_item
      end
    end
  end

  # 売上金額(@sales_money)を自販機から出して、全体売上金額(@total_sales_money)に足す
  def collect_sales_money
    @total_sales_money +=@sales_money
    @sales_money = 0
    puts "現在の総売り上げ:#{@total_sales_money}円です"
  end

end


# 実際、自販機が挙動するクラス
# ItemSetから品目など受けるのでItemSetを継承
class VendingMachine < ItemSet

  # 初期化
  def initialize
    # ItemSetのinitializeの変数などを使う
    super
    # ルーレットゲームの為の空き配列を準備
    @atari_number =[]
  end

  # 自販機の初期状態を決めるメソッド
  # 変数config部分には特に入力がない場合0を入力する
  def start(config = 0)
    # 変数configで条件分岐
    # 変数configが0(変数の未入力と同じ)以外は何を入れてもmaintenance(ItemSetのメソッド)を行ってrunメソッドを行う
    if config == 0
    #   商品の情報が入っている@drinkのsize(ハッシュのデータ数を返すメソッド)を確認後、0ではない場合
    #   自販機を起動、0であればpreset(ItemSetのメソッド)を行い、基本的な商品情報を追加した後、自販機の起動
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

  # 自販機のメニュー(挙動に関する処理に移動するためのメソッド)
  def run
    puts "-----------------------------------------"
    puts "自販機です。"
    puts "行いたい行動に該当する番号を押してください。"
    puts "-----------------------------------------"
    puts "購入可能な飲み物" + ("-"*4)
    puts "-----------------------------------------"
    confirm_slot_money
    puts "-----------------------------------------"
    puts "1 お金を投入する"
    puts "2 飲み物を買う"
    puts "3 在庫＆売上確認"
    puts "4 終わる"
    puts "-----------------------------------------"
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

  # 現在の投入金額と在庫の状態を確認するメソッド
  def confirm_slot_money
    puts "現在の投入金額:#{@slot_money}円"
    # ハッシュを繰り返して、投入金額と商品の在庫の数を条件として分岐する
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

  # 貨幣を投入するメソッド
  # 変数moneyはrunメソッドでgetsで入れる
  def slot_money(money)
    # 定数の配列に入力した値が入っていると投入金額の変数@slot_moneyに入力した値を足す
    if MONEY.include?(money) ==false
      puts "投入出来ない金額です。"
    else
      @slot_money += money
      puts "#{@slot_money}円を投入しました。"
      puts "現在投入金額:#{@slot_money}円"
    end
  end

  # 購入メソッドの選択リストを作るメソッド
  def buy_item_list(buy_or_free = 0)
    # 引数によって処理を分岐する
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
      # ルーレットゲームの為のリスト
      # 当たりの場合無料なので、値段を表示しない
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

  #buy_item_listで作ったリストから選択して計算をするメソッド
  def buy_item_calculate(buy_or_nonbuy = 0)
    # ルーレットゲームの為、引数で処理を分岐
    if buy_or_nonbuy == 0
      buy_item_list
      select_drink = gets.to_i
      i = 0
      # ハッシュを繰り返して、入力した値とiが同じ値になるとcalculate_functionにハッシュのkeyを引数として渡す
      @drink_jp.each do |key,value|
        i +=1
        if select_drink == i
          calculate_function(key)
        elsif select_drink>@drink_jp.size+1 || select_drink == 0
          puts "ボタンを押して下さい"
        end
      end
    else
      # ルーレットゲームで当たりであれば、無料なので在庫だけ引く
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


  # 物を買った後、投入金額の引き、売上金額の足し、在庫の減少などを計算するメソッド
  def calculate_function(key)
    # buy_item_listで受けたハッシュのキーを使って、ハッシュのデータを参照して、計算する
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

  # 自販機のrunメソッドが終わる時、残った金額を戻す(@slot_moneyを0にする)
  def return_money
    puts "#{@slot_money}円を返します。"
    @slot_money = 0
  end


  # privateに設定して直接接近するのが出来ない
  private

    # ルーレットゲーム
    def win_game
      puts "ルーレット始まります"
      free_gift
      # @atari_numberの値4個が同じであれば、同じ数字を1個にまとめるuniqメソッドを使った時
      # 配列のsize(データの数)が1個になるはず
      if @atari_number.uniq.size == 1
        puts "当たり、飲み物を選んでください"
        buy_item_calculate(1)
        @atari_number = []
      else
        puts "残念！次の機会に…"
        @atari_number = []
      end
    end


    # 数字を順々に4字表示するメソッド
    def free_gift
      # 4字の内3文字は同じ値を入れる
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
