
describe User, :type => :model do

  it "should be of type active record" do
    expect(User.include?(Aws::Record)).to be true
  end

  it "can create empty object" do
    expect(User.new).to_not be nil
  end

  it "has function has_secure_password" do
    expect(User.respond_to?(:has_secure_password)).to eq(true)
  end

  it "takes and returns valid values" do
    user = User.new
    user.id = "Random"
    user.password = "Welcome"
    expect(user.id).to eq("Random")
    expect(user.password).to eq("Welcome")
  end

end