require "spec_helper"

describe Katagami::Field::FieldOptionParser do
  let(:fop) { Katagami::Field::FieldOptionParser.new(args) }

  context "with field" do
    let(:args) { [:field1] }

    it { expect(fop.options).to eq({}) }
    it { expect(fop.type).to be_nil }
    it { expect(fop.fields).to contain_exactly(:field1) }

    context "and type" do
      let(:args) { [:field1, String] }

      it { expect(fop.options).to eq({}) }
      it { expect(fop.type).to eq(String) }
      it { expect(fop.fields).to contain_exactly(:field1) }

      context "and options" do
        let(:args) { [:field1, String, { option1: "option1" }] }

        it { expect(fop.options).to eq(option1: "option1") }
        it { expect(fop.type).to eq(String) }
        it { expect(fop.fields).to contain_exactly(:field1) }
      end
    end

    context "and options" do
      let(:args) { [:field1, { option1: "option1" }] }

      it { expect(fop.options).to eq(option1: "option1") }
      it { expect(fop.type).to be_nil }
      it { expect(fop.fields).to contain_exactly(:field1) }
    end
  end

  context "with only fields" do
    let(:args) { [:field1, :field2] }

    it { expect(fop.options).to eq({}) }
    it { expect(fop.type).to be_nil }
    it { expect(fop.fields).to contain_exactly(:field1, :field2) }

    context "and type" do
      let(:args) { [:field1, :field2, String] }

      it { expect(fop.options).to eq({}) }
      it { expect(fop.type).to eq(String) }
      it { expect(fop.fields).to contain_exactly(:field1, :field2) }

      context "and options" do
        let(:args) { [:field1, :field2, String, { option1: "option1" }] }

        it { expect(fop.options).to eq(option1: "option1") }
        it { expect(fop.type).to eq(String) }
        it { expect(fop.fields).to contain_exactly(:field1, :field2) }
      end
    end

    context "and options" do
      let(:args) { [:field1, :field2, { option1: "option1" }] }

      it { expect(fop.options).to eq(option1: "option1") }
      it { expect(fop.type).to be_nil }
      it { expect(fop.fields).to contain_exactly(:field1, :field2) }
    end
  end
end
