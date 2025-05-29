# frozen_string_literal: true

require "simplecov"

# SimpleCovの設定（カバレッジ測定）
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"

  add_group "Libraries", "lib"
  add_group "Executables", "exe"

  minimum_coverage 80
end

require "rbi/trace"

# RSpecの設定
RSpec.configure do |config|
  # rspec-expectations の設定
  config.expect_with :rspec do |expectations|
    # 新しい期待値構文のみを有効にする（should構文を無効化）
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks の設定
  config.mock_with :rspec do |mocks|
    # 実際に存在するメソッドのみをモック化可能にする
    mocks.verify_partial_doubles = true
  end

  # 共有コンテキストのメタデータを有効にする
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # テストの実行順序をランダムにする
  config.order = :random

  # 失敗したテストのみを再実行するためのシード値を表示
  Kernel.srand config.seed

  # フィルタリング設定
  config.filter_run_when_matching :focus

  # 警告を有効にする
  config.warnings = true

  # プロファイリング（遅いテストの特定）
  config.profile_examples = 10

  # 出力フォーマットの設定
  config.default_formatter = "doc" if config.files_to_run.one?

  # テスト実行前後のフック
  config.before(:suite) do
    puts "RBI::Trace テストスイートを開始します"
  end

  config.after(:suite) do
    puts "RBI::Trace テストスイート完了"
  end
end
