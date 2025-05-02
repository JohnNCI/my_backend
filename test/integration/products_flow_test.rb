require 'test_helper'

class ProductsFlowTest < ActionDispatch::IntegrationTest
  test "full product lifecycle" do
    # --- List Products (GET) ---
    get products_path
    assert_response :success
    products_list = JSON.parse(response.body)
    assert products_list.is_a?(Array)

    # --- Create a Product (POST) ---
    post products_path, params: {
      product: { 
        name: "Test Product", 
        description: "A product created via integration test", 
        price: 9.99, 
        available: true 
      }
    }
    assert_response :created
    product = JSON.parse(response.body)
    product_id = product["id"]
    assert_not_nil product_id

    # --- Retrieve the Created Product (GET) ---
    get product_path(product_id)
    assert_response :success
    fetched_product = JSON.parse(response.body)
    assert_equal "Test Product", fetched_product["name"]

    # --- Update the Product (PATCH) ---
    patch product_path(product_id), params: {
      product: { name: "Updated Product Name" }
    }
    assert_response :success
    updated_product = JSON.parse(response.body)
    assert_equal "Updated Product Name", updated_product["name"]

    # --- Delete the Product (DELETE) ---
    delete product_path(product_id)
    assert_response :no_content

    # Verify it is deleted by attempting to retrieve it
    get product_path(product_id)
    assert_response :not_found
  end
end
