# frozen_string_literal: true

module RBI
  module Trace
    # ASTからRBIファイルを生成するクラス
    class Generator
      # ジェネレーターの初期化
      def initialize
        @output = []
        @indent_level = 0
      end

      # ASTからRBIファイルの内容を生成
      # @param ast [Parser::AST::Node] 解析済みのAST
      # @return [String] 生成されたRBIファイルの内容
      def generate(ast)
        @output = []
        @indent_level = 0

        add_header
        process_node(ast) if ast

        @output.join("\n")
      end

      private

      # RBIファイルのヘッダーを追加
      def add_header
        @output << "# typed: strong"
        @output << "# frozen_string_literal: true"
        @output << ""
        @output << "# このファイルはrbi-traceによって自動生成されました"
        @output << "# 手動で編集しないでください"
        @output << ""
      end

      # ASTノードを処理
      # @param node [Parser::AST::Node] 処理対象のノード
      def process_node(node)
        return unless node.is_a?(::Parser::AST::Node)

        case node.type
        when :class
          process_class_node(node)
        when :module
          process_module_node(node)
        when :def
          process_method_node(node)
        when :defs
          process_singleton_method_node(node)
        else
          # 子ノードを再帰的に処理
          node.children.each { |child| process_node(child) }
        end
      end

      # クラス定義ノードを処理
      # @param node [Parser::AST::Node] クラス定義ノード
      def process_class_node(node)
        class_name = extract_constant_name(node.children[0])
        superclass = node.children[1] ? extract_constant_name(node.children[1]) : nil

        if superclass
          add_line "class #{class_name} < #{superclass}"
        else
          add_line "class #{class_name}"
        end

        indent do
          process_node(node.children[2])
        end

        add_line "end"
        add_line ""
      end

      # モジュール定義ノードを処理
      # @param node [Parser::AST::Node] モジュール定義ノード
      def process_module_node(node)
        module_name = extract_constant_name(node.children[0])

        add_line "module #{module_name}"

        indent do
          process_node(node.children[1])
        end

        add_line "end"
        add_line ""
      end

      # メソッド定義ノードを処理
      # @param node [Parser::AST::Node] メソッド定義ノード
      def process_method_node(node)
        method_name = node.children[0]
        args = extract_method_arguments(node.children[1])

        add_line "def #{method_name}#{args}; end"
      end

      # 特異メソッド定義ノードを処理
      # @param node [Parser::AST::Node] 特異メソッド定義ノード
      def process_singleton_method_node(node)
        receiver = extract_constant_name(node.children[0])
        method_name = node.children[1]
        args = extract_method_arguments(node.children[2])

        add_line "def self.#{method_name}#{args}; end"
      end

      # 定数名を抽出
      # @param node [Parser::AST::Node] 定数ノード
      # @return [String] 定数名
      def extract_constant_name(node)
        return "" unless node

        case node.type
        when :const
          node.children[1].to_s
        when :cbase
          "::"
        else
          node.to_s
        end
      end

      # メソッドの引数を抽出
      # @param args_node [Parser::AST::Node] 引数ノード
      # @return [String] 引数の文字列表現
      def extract_method_arguments(args_node)
        return "()" unless args_node

        # 簡単な実装：引数の詳細な解析は後で実装
        "()"
      end

      # インデントを増やして処理を実行
      def indent
        @indent_level += 1
        yield
        @indent_level -= 1
      end

      # インデント付きで行を追加
      # @param line [String] 追加する行
      def add_line(line)
        indented_line = "  " * @indent_level + line
        @output << indented_line
      end
    end
  end
end
