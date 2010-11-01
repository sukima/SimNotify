class Test::Unit::TestCase
  def self.should_have_json_element(element)
    should "have #{element}" do
      assert_not_nil @response
      assert @response.respond_to? :body
      assert_match /"#{element}":/, @response.body
    end
  end
end
