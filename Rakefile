# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

# RSpecタスクの設定
RSpec::Core::RakeTask.new(:spec)

# RuboCopタスクの設定
RuboCop::RakeTask.new

# デフォルトタスクの設定
task default: %i[spec rubocop]

# カスタムタスク
namespace :rbi do
  desc "サンプルファイルからRBIを生成"
  task :sample do
    require_relative "lib/rbi/trace"

    # サンプルファイルが存在する場合のみ実行
    sample_file = "examples/sample.rb"
    if File.exist?(sample_file)
      cli = RBI::Trace::CLI.new
      cli.run([sample_file, "--verbose"])
    else
      puts "サンプルファイルが見つかりません: #{sample_file}"
    end
  end
end

# 開発用タスク
namespace :dev do
  desc "開発環境のセットアップ"
  task :setup do
    puts "開発環境をセットアップしています..."
    system("bundle install")
    puts "セットアップ完了！"
  end

  desc "コードの品質チェック"
  task :check do
    puts "コード品質をチェックしています..."
    Rake::Task["rubocop"].invoke
    Rake::Task["spec"].invoke
    puts "チェック完了！"
  end
end
