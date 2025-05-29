# frozen_string_literal: true

require "parser/current"

module RBI
  module Trace
    # Rubyコードを解析してAST（抽象構文木）を生成するクラス
    class Parser
      # パーサーの初期化
      def initialize
        @parser = ::Parser::CurrentRuby.new
      end

      # ファイルを解析してASTを返す
      # @param file_path [String] 解析対象のファイルパス
      # @return [Parser::AST::Node] 解析結果のAST
      # @raise [ParseError] 解析に失敗した場合
      def parse_file(file_path)
        source_code = File.read(file_path)
        parse_string(source_code, file_path)
      rescue Errno::ENOENT
        raise ParseError, "ファイルが見つかりません: #{file_path}"
      rescue ::Parser::SyntaxError => e
        raise ParseError, "構文エラー: #{e.message}"
      end

      # 文字列を解析してASTを返す
      # @param source_code [String] 解析対象のソースコード
      # @param file_name [String] ファイル名（エラー表示用）
      # @return [Parser::AST::Node] 解析結果のAST
      # @raise [ParseError] 解析に失敗した場合
      def parse_string(source_code, file_name = "(string)")
        @parser.parse(source_code, file_name)
      rescue ::Parser::SyntaxError => e
        raise ParseError, "構文エラー in #{file_name}: #{e.message}"
      end

      private

      attr_reader :parser
    end
  end
end
