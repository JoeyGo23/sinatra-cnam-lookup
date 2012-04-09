require 'spec_helper'

describe "Checker" do
  describe "looks up a non-existant telephone number" do
    it "does not return a result and does not pass validation" do
      check = Checker.new("test", "2121235512")
      check.pass?.should be_false
      check.results.should be_nil
    end
  end
  describe "looks up an existant telephone number" do
    describe "that matches the supplied name" do
      it "returns a result and passes validation" do
        check = Checker.new("Columbi Of Dist", "2024561111")
        check.results.should_not be_nil
        check.pass?.should be_true
      end
    end
     describe "that does not match the supplied name" do
      it "returns a result and fails validation" do
        check = Checker.new("john smith", "2024561111")
        check.results.should_not be_nil
        check.pass?.should be_false
      end
    end
  end
end
