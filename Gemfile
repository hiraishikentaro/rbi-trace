# frozen_string_literal: true

source "https://rubygems.org"

# Gemspecで定義された依存関係を使用
gemspec

# 開発環境でのみ使用するGem
group :development do
  gem "pry", "~> 0.14"
  gem "pry-byebug", "~> 3.10"
end

# テスト環境でのみ使用するGem
group :test do
  gem "simplecov", "~> 0.22", require: false
end

# 開発・テスト環境で使用するGem
group :development, :test do
  gem "guard", "~> 2.18"
  gem "guard-rspec", "~> 4.7"
  gem "guard-rubocop", "~> 1.5"
end
