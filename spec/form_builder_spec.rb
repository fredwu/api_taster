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
        :content => :file,
        :user => {
          :name => 'Fred',
          :comment => {
            :title => [1, 2, 3]
          }
        },
        :items => [
          { :name => 'flower', :price => '4.95' },
          { :name => 'pot', :price => '2.45' },
          { :nested_items => [
            { :name => 'apple' },
            { :name => 'orange'},
            { :nested_numbers => [3, 4, 5] }
          ]}
        ]
      })
    end

    it "inserts data into the buffer" do
      builder.instance_variable_get(:@_buffer).length.should > 0
    end

    it "outputs html" do
      builder.html.should match('world')
    end

    context "data types" do
      it "does strings" do
        builder.html.should match('value="world"')
      end

      it "does files" do
        builder.html.should match('<input type="file" name="content" ></input>')
      end

      it "does numbers" do
        builder.html.should match('value="1"')
      end

      it "does arrays" do
        builder.html.should match(/name="user\[comment\]\[title\]\[\]" value="1"/)
      end

      it "does nested arrays" do
        builder.html.should match(/name="items\[\]\[nested_items\]\[\]\[nested_numbers\]\[\]" value="5"/)
        builder.html.should match(/name="items\[\]\[nested_items\]\[\]\[name\]" value="apple"/)
      end
    end
  end
end
