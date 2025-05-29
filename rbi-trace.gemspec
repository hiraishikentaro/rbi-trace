# frozen_string_literal: true

require_relative "lib/rbi/trace/version"

Gem::Specification.new do |spec|
  # 基本情報
  spec.name = "rbi-trace"
  spec.version = RBI::Trace::VERSION
  spec.authors = ["Your Name"]
  spec.email = ["your.email@example.com"]

  # プロジェクトの説明
  spec.summary = "Ruby Interface (RBI) ファイル生成ツール"
  spec.description = "Rubyコードを解析してRBI（Ruby Interface）ファイルを自動生成するGem"
  spec.homepage = "https://github.com/yourusername/rbi-trace"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # メタデータ
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yourusername/rbi-trace"
  spec.metadata["changelog_uri"] = "https://github.com/yourusername/rbi-trace/blob/main/CHANGELOG.md"

  # ファイルの指定
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # 依存関係
  spec.add_dependency "parser", "~> 3.0"
  spec.add_dependency "prism", "~> 0.24"
  spec.add_dependency "sorbet-runtime", "~> 0.5"
  spec.add_dependency "unparser", "~> 0.6"

  # 開発用依存関係
  spec.add_development_dependency "debug", "~> 1.8"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "rubocop-rspec", "~> 2.20"
  spec.metadata["rubygems_mfa_required"] = "true"
end
