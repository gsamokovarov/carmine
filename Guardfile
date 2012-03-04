guard :rspec, :cli => '--format documentation --require "spec_helper" --color' do
  watch(%r{^lib/(.+)\.rb$})  { 'spec' }
  watch(%r{^spec/(.+)\.rb$}) { 'spec' }
end
