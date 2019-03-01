require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(first_name: "Taylor", last_name: "Swift", email: "taylor@swift.com", password: "taylor123") }

  it "is not valid without a non-admin first name" do
    subject.role = "customer"
    subject.first_name = nil
    expect(subject).to_not be_valid
  end

  it "is valid without an admin first name" do
    subject.role = "admin"
    subject.first_name = nil
    expect(subject).to be_valid
  end

  it "is not valid without a valid last name" do
    subject.last_name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a valid email" do
    subject.email = "taylor"
    expect(subject).to_not be_valid
  end

  it "is not valid without a 6 character minimum password" do
    subject.password = "12345"
    expect(subject).to_not be_valid
  end

  it "is valid with a valid role" do
    subject.role = "customer"
    expect(subject).to be_valid
  end

  it "is not valid without a valid role" do
    subject.role = "staff"
    expect(subject).to_not be_valid
  end
end
