# frozen_string_literal: true

RSpec.describe RBI::Trace do
  # バージョンが定義されていることをテスト
  it "バージョンが定義されている" do
    expect(RBI::Trace::VERSION).not_to be_nil
    expect(RBI::Trace::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end

  # エラークラスが定義されていることをテスト
  describe "エラークラス" do
    it "Error クラスが定義されている" do
      expect(RBI::Trace::Error).to be < StandardError
    end

    it "ParseError クラスが定義されている" do
      expect(RBI::Trace::ParseError).to be < RBI::Trace::Error
    end

    it "GenerationError クラスが定義されている" do
      expect(RBI::Trace::GenerationError).to be < RBI::Trace::Error
    end
  end

  # セットアップメソッドのテスト
  describe ".setup" do
    it "セットアップメソッドが呼び出せる" do
      expect { described_class.setup }.not_to raise_error
    end
  end
end
