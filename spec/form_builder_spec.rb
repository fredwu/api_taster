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
          :integer => 1
        }
      })
    end

    it "inserts data into the buffer" do
      builder.instance_variable_get(:@_buffer).length.should > 0
    end

    it "outputs html" do
      builder.html.should match('bar')
    end
  end
end
