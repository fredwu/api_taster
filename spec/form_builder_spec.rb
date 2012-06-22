require 'spec_helper'

module ApiTaster
  describe FormBuilder do
    context "empty params" do
      it "has empty buffer" do
        builder = FormBuilder.new({})
        builder.instance_variable_get(:@_buffer).length.should == 0
      end
    end

    let(:builder) do
      FormBuilder.new({
        :hello => 'world',
        :nested => {
          :foo => 'bar',
          :integer => 1,
          :array => [1, 2, 3]
        }
      })
    end

    it "inserts data into the buffer" do
      builder.instance_variable_get(:@_buffer).length.should > 0
    end

    it "outputs html" do
      builder.html.should match('bar')
    end

    context "data types" do
      it "does strings" do
        builder.html.should match('value="world"')
      end

      it "does numbers" do
        builder.html.should match('value="1"')
      end

      it "does arrays" do
        builder.html.should match(/name="\[nested\]\[array\]\[\]" value="2"/)
      end
    end
  end
end
