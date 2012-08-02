require 'spec_helper'

module ApiTaster
  describe ApplicationHelper do
    it "#markdown" do
      helper.markdown('__bold__').should == "<p><strong>bold</strong></p>\n"
    end
  end
end
