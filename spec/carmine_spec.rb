describe Carmine do
  before do
    Carmine.base_uri ENV['base_uri'] if ENV['base_uri']
  end

  describe '::Error' do
    it 'should extract /\(.*?\)/' do
      response = Struct.new(:body).new('Skipped and (showed)')

      Carmine::Error.new(response).to_s.should == 'showed'
    end

    it 'should extract /\(.*?\)/ only if present' do
      response = Struct.new(:body).new('Still fine')

      Carmine::Error.new(response).to_s.should == 'Still fine'
    end
  end

  describe '#initialize' do
    it 'should accept options used as defaults' do
      carmine = Carmine.new :lexer => :ruby, :formatter => :latex

      carmine.defaults[:lexer].should     eq(:ruby)
      carmine.defaults[:formatter].should eq(:latex)
    end
  end

  %w{ :: # }.each do |access|
    describe "#{access}colorize" do
      let(:carmine) { access == '::' ? Carmine : Carmine.new }

      it 'should colorize code :lexer and :formatter' do
        carmine.colorize('puts "Hello World!"', :lexer => :ruby, :formatter => :html).should ==
          %Q{<div class="highlight"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n}
      end

      it 'should convert arrays and hashes to JSON' do
        carmine.colorize('puts "Hello World!"', :lexer => :ruby, :options => { :cssclass => :color }).should ==
          %Q{<div class="color"><pre><span class="nb">puts</span> <span class="s2">&quot;Hello World!&quot;</span>\n</pre></div>\n}
      end

      it 'should throw Carmine::Error on server side errors' do
        colorization = proc do
          carmine.colorize 'pass', :lexer => :python, :formatter => :invalid
        end

        expect { colorization.call }.to raise_error(Carmine::Error)
      end

      it 'should raise ArgumentError on missing code' do
        expect { carmine.colorize }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#defaults' do
    it 'should get or set instance wide default options' do
      carmine = Carmine.new
      carmine.defaults = { :lexer => :ruby, :formatter => :latex }

      carmine.defaults[:lexer].should     eq(:ruby)
      carmine.defaults[:formatter].should eq(:latex)
    end
  end

  describe '::version' do
    it 'should consist of Major, Minor and Patch joined by a dot' do
      [Carmine::Version::Major, Carmine::Version::Minor, Carmine::Version::Patch].join('.').should \
        eq(Carmine.version)
    end
  end
end
