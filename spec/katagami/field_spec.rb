require "spec_helper"

describe Katagami::Field do
  class TestFormBase < ActiveRecord::Base
    validates :string_field, presence: true, on: :hoge?

    private

    def hoge?
      true
    end
  end

  class TestNestedForm
    include Katagami

    field :nested_field, String
  end

  describe ".field_for" do
    let(:test_form) do
      tf = Class.new
      tf.class_eval do
        include Katagami
      end
      tf
    end

    it do
      test_form.class_eval do
        fields_for TestFormBase
      end
      expect(test_form.field_names).to contain_exactly(:integer_field, :string_field, :text_field)
      expect(test_form.new.integer_field).to eq(nil)
      expect(test_form.new.string_field).to eq(nil)
      expect(test_form.new.text_field).to eq(nil)
    end
  end

  describe ".field" do
    let(:test_form) do
      tf = Class.new
      tf.class_eval do
        include Katagami
      end
      tf
    end

    context "for Model" do
      context "with valid fields" do
        it do
          test_form.class_eval do
            field :integer_field, for: TestFormBase, default: 1
            field :string_field,  for: TestFormBase, default: "default_string"
            field :text_field,    for: TestFormBase, default: "default_text"
          end
          expect(test_form.field_names).to contain_exactly(:integer_field, :string_field, :text_field)
          expect(test_form.new.integer_field).to eq(1)
          expect(test_form.new.string_field).to eq("default_string")
          expect(test_form.new.text_field).to eq("default_text")
        end
      end

      context "with invalid field" do
        it do
          expect do
            test_form.class_eval do
              field :invalid_field, for: TestFormBase
            end
          end.to raise_error(ArgumentError, "Unknown attribute[invalid_field] for [TestFormBase].")
        end
      end
    end

    context "with single field for specific Class" do
      it do
        test_form.class_eval do
          field :single_field, String
        end
        expect(test_form.field_names).to contain_exactly(:single_field)
        expect(test_form.new.single_field).to eq(nil)
      end

      context "with parameters" do
        it do
          test_form.class_eval do
            field :single_field_with_default, String, default: "default"
          end
          expect(test_form.field_names).to contain_exactly(:single_field_with_default)
          expect(test_form.new.single_field_with_default).to eq("default")
        end
      end
    end

    context "with multiple fields for specific Class" do
      it do
        test_form.class_eval do
          field :multiple_field1, :multiple_field2, String
        end
        expect(test_form.field_names).to contain_exactly(:multiple_field1, :multiple_field2)
        expect(test_form.new.multiple_field1).to eq(nil)
        expect(test_form.new.multiple_field2).to eq(nil)
      end

      context "with parameters" do
        it do
          test_form.class_eval do
            field :multiple_field_with_default1, :multiple_field_with_default2, String, default: "default"
          end
          expect(test_form.field_names).to contain_exactly(:multiple_field_with_default1, :multiple_field_with_default2)
          expect(test_form.new.multiple_field_with_default1).to eq("default")
          expect(test_form.new.multiple_field_with_default2).to eq("default")
        end
      end
    end

    context "for nested form" do
      it do
        test_form.class_eval do
          field :nested, TestNestedForm
        end
        expect(test_form.field_names).to contain_exactly({ nested: [:nested_field] })
        expect(test_form.new.nested).to eq(nil)
      end

      context "with parameter" do
        it do
          test_form.class_eval do
            field :nested, TestNestedForm, default: {}
          end
          expect(test_form.field_names).to contain_exactly({ nested: [:nested_field] })
          expect(test_form.new.nested).to be_instance_of(TestNestedForm)
        end
      end
    end
  end
end
