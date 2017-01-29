class TestValue < Sequel::Model
  def self.create!(data)
    new(data).save(raise_on_failure: true)
  end
end
