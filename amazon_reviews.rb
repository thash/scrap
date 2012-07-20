# -*- coding: utf-8 -*-

require 'rubygems'
require 'bundler/setup'
Bundler.require

# >>>>> Gemfile <<<<<
# source :rubygems
# gem 'httpclient'
# gem 'nokogiri'
# gem "pry"
# gem 'hashie'
# gem 'amazon-ecs'

# >>>>> input.txt <<<<<
# 9784837964766
# 9784812434147
# 9784837977315
# ...

##########################################################################################################
#
# ・出力希望データ：下記3つ(のレスポンス要素)
#  AverageRating　平均レーティング
#  TotalReviews　合計レビュー数
#  TotalReviewPages　合計レビューページ数
# https://images-na.ssl-images-amazon.com/images/G/09/associates/paapi/dg/index.html?RG_Reviews.html
# →納品データは、「ISDN 平均レーティング 合計レビュー数 合計レビューページ数」が1行に並んで、
#   スペースや/や,で区切られてる形にして下さい。
#
#--------------------------------- config ---------------------------------
# 入出力ファイル名, AWS key等を保存するファイル名
@input  = './input.txt'
@output = './output.txt'
@secret = './secret.yml'
# @secret should be YAML format. for example...
#     access_key: xxxxxxxxxxxxxxxxxxxx
#     secret_access_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#     associate_tag: xxxxxxxxxxx-22

# 入力のISBNリストからランダムに取ってテストする場合、個数を指定する。nilにすると全件。
@sample = 10 # 1,2,3... etc, and nil

# 4カラム目に商品ページへのURLを含めるかどうか
@@include_url = true

# エラーで"ISBN \n"となっているoutput行を再取得, 上書きするフラグ. 最初はfalseで進め, 1周したらtrueにする.
@retry_error = false

#--------------------------------- config ---------------------------------


##########################################################################################################
#                                                lib
##########################################################################################################
class MyAWS
  class Reviews < Amazon::Ecs
    class InValidKeys < StandardError; end
    def initialize(yaml)
      $secret    = Hashie::Mash.new(YAML.load_file(yaml))
      raise InValidKeys unless [:access_key, :secret_access_key, :associate_tag].map{|m| $secret.respond_to?(m) }.all?

      conf =  {
        access_key:        $secret.access_key,
        secret_access_key: $secret.secret_access_key,
        associate_tag:     $secret.associate_tag
      }

      MyAWS::Reviews.configure do |options|
        options[:associate_tag]     = conf[:associate_tag]
        options[:AWS_access_key_id] = conf[:access_key]
        options[:AWS_secret_key]    = conf[:secret_access_key]
      end
    end

    # ISBN(String)の配列を返す。
    # 第二引数として数値を渡した場合、指定個数のISBNをランダムに選んで返却
    def self.read_isbn(file, sample=nil)
      return [] if file == nil
      if sample
        File.readlines(file).map(&:strip).compact.sort.sample(sample)
      else
        File.readlines(file).map(&:strip).compact.sort
      end
    end

    def self.fetch_reviews_url(resp)
      # 引数がnilだったりレビュー数が0の場合nilを返す
      return nil if resp == nil
      return nil if (resp/"HasReviews").text != "true"
      ### iframeではないwebから取る場合こちら ###
      #(resp.doc.child.children.last/"Item IFrameURL").text
      #(resp.first_item/"ItemLink URL").select{|elem| elem.previous_element.child.text == "All Customer Reviews" }.first.child.text
      (resp/"IFrameURL").text
    end

    def self.fetch_asin(resp)
      return nil if resp == nil
      (resp/"ASIN").text
    end

    # Review IFrame  URLからHTML取得, 鋸をかける
    # AverageRating(float), TotalReviews(integer), TotalReviewPages(integer) のArrayを返す
    def self.get_review_summary(url)
      ### iframeではないwebから取る場合こちら ###
      # base = doc.css("table#productSummary span.crAvgStars")
      # average_rating = base.css(".swSprite").first.attributes["title"].value.split.last.to_f

      # Review数が0の時は固定値をreturn
      return [0, 0, 1] if url == nil

      doc    = Nokogiri::HTML(open(url))
      base = doc.css("div.crIFrameNumCustReviews")

      # Nokogiri Scrapingで目的のデータを取得
      average_rating = base.css("span.asinReviewsSummary img").first.attributes["title"].value.split.last.to_f
      total_reviews  = base.css(".asinReviewsSummary").first.next_element.text.scan(/\d+/).first.to_i

      # 1ページあたり10件のレビュー
      total_review_pages = (total_reviews/10) + 1

      # Example: [4.1, 18, 2]
      return [average_rating, total_reviews, total_review_pages]
    end

    def self.write_line(client, out, isbn, opts={})
      out << isbn.to_s + " "
      begin
        resp = client.item_lookup(isbn, opts).first_item

        # Amazonが取り扱っていない場合, 改行して次へ
        out << "\n" and return if resp == nil

        asin = MyAWS::Reviews.fetch_asin(resp)

        url    = MyAWS::Reviews.fetch_reviews_url(resp)
        result = MyAWS::Reviews.get_review_summary(url)

        # ファイル出力
        out << result.join(" ")
        out << " http://www.amazon.co.jp/dp/#{asin}/" if asin && @@include_url
        out << "\n"
      rescue => e
        # 例外処理 -- 標準出力にエラーを吐きつつ, outputには"ISBN \n"を出力
        puts "[#{isbn}] Exception Raised: #{e.message}"
        out << "\n"
      end
    end


    def method_missing(method, *args)
      Amazon::Ecs.__send__(method, *args)
    end

  end
end


##########################################################################################################
#                                               exec
##########################################################################################################
# secretファイルを元に認証クライアント生成
client = MyAWS::Reviews.new(@secret)

# 日本(Amazon.co.jp)を対象とし,
# ISBNで検索.
# レスポンスグループをReviewsに絞り込み
opts = {country: 'jp', IdType: 'ISBN', SearchIndex: 'Books', ResponseGroup: 'Reviews'}

finished  =  if File.exists?(@output)
               File.readlines(@output).map(&:strip).compact.map{|line| line.split.first}
             else
               []
             end
isbn_list = MyAWS::Reviews.read_isbn(@input, @sample)
unless @retry_error # 最初全部舐めるまで

  File.open(@output, "w") do |out|
    isbn_list.each do |isbn|
      # 一度通過してoutputに残っているisbnはskip.
      next if finished.include?(isbn)
      MyAWS::Reviews.write_line(client, out, isbn, opts)
    end
  end

else # @retry_error == true, つまりエラーISBNの再取得を試みるとき
  unless isbn_list.sort == finished.sort
    puts "not fully scanned yet!" and exit 1
  else

    tmp = "#{@output}_tmp"
    File.open(tmp, "w+") do |out|
      File.open(@output, "r") do |f|
        while line = f.gets
          if line.split.count == 1
            isbn = line.split.first
            MyAWS::Reviews.write_line(client, out, isbn, opts)
          else
            out << line
          end
        end
      end
    end

  end
end

