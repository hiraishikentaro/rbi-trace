# frozen_string_literal: true

RSpec.describe RBI::Trace::Parser do
  let(:parser) { described_class.new }

  describe "#initialize" do
    it "パーサーが初期化される" do
      expect(parser).to be_an_instance_of(described_class)
    end
  end

  describe "#parse_string" do
    context "有効なRubyコードの場合" do
      let(:source_code) do
        <<~RUBY
          class TestClass
            def test_method
              puts "Hello, World!"
            end
          end
        RUBY
      end

      it "ASTを正常に生成する" do
        ast = parser.parse_string(source_code)
        expect(ast).to be_a(Parser::AST::Node)
        expect(ast.type).to eq(:class)
      end
    end

    context "無効なRubyコードの場合" do
      let(:invalid_source) { "class TestClass\n  def\nend" }

      it "ParseErrorを発生させる" do
        expect { parser.parse_string(invalid_source) }.to raise_error(RBI::Trace::ParseError)
      end
    end

    context "空の文字列の場合" do
      it "nilを返す" do
        ast = parser.parse_string("")
        expect(ast).to be_nil
      end
    end
  end

  describe "#parse_file" do
    let(:temp_file) { Tempfile.new(["test", ".rb"]) }

    after do
      temp_file.close
      temp_file.unlink
    end

    context "存在するファイルの場合" do
      before do
        temp_file.write(<<~RUBY)
          module TestModule
            class TestClass
              def initialize
                @value = 42
              end
            end
          end
        RUBY
        temp_file.rewind
      end

      it "ファイルを正常に解析する" do
        ast = parser.parse_file(temp_file.path)
        expect(ast).to be_a(Parser::AST::Node)
        expect(ast.type).to eq(:module)
      end
    end

    context "存在しないファイルの場合" do
      it "ParseErrorを発生させる" do
        expect { parser.parse_file("nonexistent_file.rb") }.to raise_error(RBI::Trace::ParseError, /ファイルが見つかりません/)
      end
    end

    context "構文エラーのあるファイルの場合" do
      before do
        temp_file.write("class TestClass\n  def\nend")
        temp_file.rewind
      end

      it "ParseErrorを発生させる" do
        expect { parser.parse_file(temp_file.path) }.to raise_error(RBI::Trace::ParseError, /構文エラー/)
      end
    end
  end
end
