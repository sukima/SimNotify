class Test::Unit::TestCase
  def self.should_have_json_element(element)
    # DEPRECATED. Use should_have_json_elements
    should "have #{element} element" do
      assert_not_nil @response
      assert @response.respond_to? :body
      assert_match /"#{element}":/, @response.body
    end
  end

  def self.construct_json_object(json_obj)
    if json_obj.kind_of? String
      _json = ActiveSupport::JSON.decode(json_obj)
    elsif json_obj.kind_of? ActiveSupport::JSON
      _json = json_obj
    else
      _json = nil
    end
    _json
  end

  def self.should_have_json_elements(elements, json_obj, should_not=false)
    context "JSON object" do
      _json = construct_json_object(json_obj)
      elements.each do |e|
        if should_not
          should "not have #{e} element" do
            assert !_json.respond_to?(e.to_sym), "JSON object does respond_to? #{e}"
          end
        else
          should "have #{e} element" do
            assert _json.respond_to?(e.to_sym), "JSON object does not respond_to? #{e}"
          end
        end
      end
    end
  end

  def self.should_not_have_json_elements(elements, json_obj)
    should_not_have_json_elements(elements, json_obj, true)
  end

  def self.should_have_json_array(json_obj)
    context "JSON object" do
      _json = construct_json_object(json_obj)
      should "be a JSON array" do
        assert_not_nil _json, "JSON object is nil"
        assert _json.kind_of? Array, "JSON object is not an Array"
      end
    end
  end
end
