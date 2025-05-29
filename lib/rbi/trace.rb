# frozen_string_literal: true

require_relative "trace/version"

module RBI
  # RBI（Ruby Interface）ファイル生成のためのメインモジュール
  module Trace
    # エラークラス定義
    class Error < StandardError; end
    class ParseError < Error; end
    class GenerationError < Error; end

    # ライブラリの初期化
    def self.setup
      # 必要な初期化処理をここに記述
    end
  end
end

# 必要なサブモジュールの読み込み
require_relative "trace/parser"
require_relative "trace/generator"
require_relative "trace/cli"
