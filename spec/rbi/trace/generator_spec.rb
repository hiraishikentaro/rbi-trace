# frozen_string_literal: true

RSpec.describe RBI::Trace::Generator do
  let(:generator) { described_class.new }
  let(:parser) { RBI::Trace::Parser.new }

  describe "#initialize" do
    it "ジェネレーターが初期化される" do
      expect(generator).to be_an_instance_of(described_class)
    end
  end

  describe "#generate" do
    context "nilのASTの場合" do
      it "ヘッダーのみを含むRBIを生成する" do
        result = generator.generate(nil)
        expect(result).to include("# typed: strong")
        expect(result).to include("# frozen_string_literal: true")
        expect(result).to include("# このファイルはrbi-traceによって自動生成されました")
      end
    end

    context "クラス定義のASTの場合" do
      let(:source_code) do
        <<~RUBY
          class TestClass
            def test_method
              puts "Hello"
            end
          end
        RUBY
      end

      it "クラス定義を含むRBIを生成する" do
        ast = parser.parse_string(source_code)
        result = generator.generate(ast)

        expect(result).to include("class TestClass")
        expect(result).to include("def test_method(); end")
        expect(result).to include("end")
      end
    end

    context "継承クラス定義のASTの場合" do
      let(:source_code) do
        <<~RUBY
          class ChildClass < ParentClass
            def child_method
              super
            end
          end
        RUBY
      end

      it "継承関係を含むRBIを生成する" do
        ast = parser.parse_string(source_code)
        result = generator.generate(ast)

        expect(result).to include("class ChildClass < ParentClass")
        expect(result).to include("def child_method(); end")
      end
    end

    context "モジュール定義のASTの場合" do
      let(:source_code) do
        <<~RUBY
          module TestModule
            def module_method
              "test"
            end
          end
        RUBY
      end

      it "モジュール定義を含むRBIを生成する" do
        ast = parser.parse_string(source_code)
        result = generator.generate(ast)

        expect(result).to include("module TestModule")
        expect(result).to include("def module_method(); end")
        expect(result).to include("end")
      end
    end

    context "ネストしたクラス・モジュールのASTの場合" do
      let(:source_code) do
        <<~RUBY
          module OuterModule
            class InnerClass
              def inner_method
                42
              end
            end
          end
        RUBY
      end

      it "ネストした構造を含むRBIを生成する" do
        ast = parser.parse_string(source_code)
        result = generator.generate(ast)

        expect(result).to include("module OuterModule")
        expect(result).to include("  class InnerClass")
        expect(result).to include("    def inner_method(); end")
        expect(result).to include("  end")
        expect(result).to include("end")
      end
    end

    context "特異メソッド定義のASTの場合" do
      let(:source_code) do
        <<~RUBY
          class TestClass
            def self.class_method
              "class method"
            end
          end
        RUBY
      end

      it "特異メソッドを含むRBIを生成する" do
        ast = parser.parse_string(source_code)
        result = generator.generate(ast)

        expect(result).to include("class TestClass")
        expect(result).to include("def self.class_method(); end")
      end
    end
  end
end
