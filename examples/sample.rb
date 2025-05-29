# frozen_string_literal: true

# サンプルRubyファイル
# このファイルはrbi-traceのテスト用です

module SampleModule
  # サンプルクラス
  class SampleClass
    # 初期化メソッド
    # @param name [String] 名前
    # @param age [Integer] 年齢
    def initialize(name, age)
      @name = name
      @age = age
    end

    # 名前を取得
    # @return [String] 名前
    def name
      @name
    end

    # 年齢を取得
    # @return [Integer] 年齢
    def age
      @age
    end

    # 挨拶メソッド
    # @param greeting [String] 挨拶の言葉
    # @return [String] 挨拶文
    def greet(greeting = "こんにちは")
      "#{greeting}、私は#{@name}です。#{@age}歳です。"
    end

    # クラスメソッド
    # @param count [Integer] カウント
    # @return [Array<SampleClass>] インスタンスの配列
    def self.create_multiple(count)
      Array.new(count) { |i| new("サンプル#{i}", 20 + i) }
    end

    private

    # プライベートメソッド
    def validate_age
      @age >= 0
    end
  end

  # 継承クラス
  class ExtendedSample < SampleClass
    # 拡張初期化メソッド
    # @param name [String] 名前
    # @param age [Integer] 年齢
    # @param hobby [String] 趣味
    def initialize(name, age, hobby)
      super(name, age)
      @hobby = hobby
    end

    # 趣味を取得
    # @return [String] 趣味
    def hobby
      @hobby
    end

    # 拡張挨拶メソッド
    # @param greeting [String] 挨拶の言葉
    # @return [String] 拡張挨拶文
    def greet(greeting = "こんにちは")
      "#{super(greeting)} 趣味は#{@hobby}です。"
    end
  end

  # ユーティリティモジュール
  module Utilities
    # 文字列を大文字に変換
    # @param str [String] 変換対象の文字列
    # @return [String] 大文字に変換された文字列
    def self.upcase_string(str)
      str.upcase
    end

    # 配列をシャッフル
    # @param array [Array] シャッフル対象の配列
    # @return [Array] シャッフルされた配列
    def self.shuffle_array(array)
      array.shuffle
    end
  end
end
