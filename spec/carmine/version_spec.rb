describe Carmine::Version do
  [:Major, :Minor, :Patch].each do |const|
    it "should have #{const} part constant" do
      Carmine::Version.constants.should include(const)
    end
  end
end
