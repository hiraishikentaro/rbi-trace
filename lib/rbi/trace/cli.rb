# frozen_string_literal: true

require "optparse"

module RBI
  module Trace
    # コマンドライン インターフェースを提供するクラス
    class CLI
      # CLIの初期化
      def initialize
        @options = {
          output_dir: "rbi",
          recursive: false,
          verbose: false
        }
      end

      # コマンドライン引数を解析して実行
      # @param args [Array<String>] コマンドライン引数
      def run(args)
        parse_options(args)

        if args.empty?
          puts "エラー: 解析対象のファイルまたはディレクトリを指定してください"
          puts option_parser.help
          exit 1
        end

        args.each do |path|
          process_path(path)
        end
      rescue Error => e
        puts "エラー: #{e.message}"
        exit 1
      end

      private

      # オプションを解析
      # @param args [Array<String>] コマンドライン引数
      def parse_options(args)
        option_parser.parse!(args)
      rescue OptionParser::InvalidOption => e
        puts "エラー: #{e.message}"
        puts option_parser.help
        exit 1
      end

      # オプションパーサーを作成
      # @return [OptionParser] オプションパーサー
      def option_parser
        @option_parser ||= OptionParser.new do |opts|
          opts.banner = "使用方法: rbi-trace [オプション] ファイル..."
          opts.separator ""
          opts.separator "オプション:"

          opts.on("-o", "--output DIR", "出力ディレクトリ (デフォルト: rbi)") do |dir|
            @options[:output_dir] = dir
          end

          opts.on("-r", "--recursive", "ディレクトリを再帰的に処理") do
            @options[:recursive] = true
          end

          opts.on("-v", "--verbose", "詳細な出力を表示") do
            @options[:verbose] = true
          end

          opts.on("-h", "--help", "このヘルプを表示") do
            puts opts
            exit
          end

          opts.on("--version", "バージョンを表示") do
            puts "rbi-trace #{VERSION}"
            exit
          end
        end
      end

      # パスを処理（ファイルまたはディレクトリ）
      # @param path [String] 処理対象のパス
      def process_path(path)
        if File.file?(path)
          process_file(path)
        elsif File.directory?(path)
          process_directory(path)
        else
          puts "警告: #{path} が見つかりません"
        end
      end

      # ファイルを処理
      # @param file_path [String] 処理対象のファイルパス
      def process_file(file_path)
        return unless file_path.end_with?(".rb")

        puts "処理中: #{file_path}" if @options[:verbose]

        parser = Parser.new
        generator = Generator.new

        begin
          ast = parser.parse_file(file_path)
          rbi_content = generator.generate(ast)

          output_path = generate_output_path(file_path)
          write_rbi_file(output_path, rbi_content)

          puts "生成完了: #{output_path}" if @options[:verbose]
        rescue Error => e
          puts "エラー (#{file_path}): #{e.message}"
        end
      end

      # ディレクトリを処理
      # @param dir_path [String] 処理対象のディレクトリパス
      def process_directory(dir_path)
        pattern = @options[:recursive] ? "**/*.rb" : "*.rb"
        files = Dir.glob(File.join(dir_path, pattern))

        files.each do |file_path|
          process_file(file_path)
        end
      end

      # 出力ファイルパスを生成
      # @param input_path [String] 入力ファイルパス
      # @return [String] 出力ファイルパス
      def generate_output_path(input_path)
        base_name = File.basename(input_path, ".rb")
        File.join(@options[:output_dir], "#{base_name}.rbi")
      end

      # RBIファイルを書き込み
      # @param output_path [String] 出力ファイルパス
      # @param content [String] ファイル内容
      def write_rbi_file(output_path, content)
        FileUtils.mkdir_p(File.dirname(output_path))
        File.write(output_path, content)
      end
    end
  end
end
