require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must no be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My book title",
                          description: "xxx",
                          image_url: "xxx.png",
                          price: -1)
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "book book book",
                description: "xxx",
                price: 1,
                image_url: image_url)
  end
  test "image extension must be png|jpeg|gif" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.JPG http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.doc fred.gif/more fred.gif.more}
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "aaa",
                          price: "1",
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  test "product title should be longer than 10 chars" do
    product = products(:short_title)
    assert product.invalid?
    assert_equal ["is too short (minimum is 10 characters)"], product.errors[:title]
  end
end
