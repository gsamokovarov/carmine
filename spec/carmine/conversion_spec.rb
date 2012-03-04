describe Carmine::Conversion do
  it 'converts the Hash query values to JSON' do
    query = Carmine::Conversion.to_params :options => { :cssclass => :color }
    query.should eq("options=%7B%22cssclass%22%3A%22color%22%7D")
  end

  it 'converts the Array query values to JSON' do
    query = Carmine::Conversion.to_params :styles => [:monokai]
    query.should eq("styles=%5B%22monokai%22%5D")
  end

  it 'should url encode the strings and symbols' do
    query = Carmine::Conversion.to_params :styles => " "
    query.should eq("styles=%20")
  end
end
