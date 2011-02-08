class Test::Unit::TestCase
  def self.should_have_translation(str, translation=nil)
    should "have translation" do
      assert_no_match(/^translation missing:/i, str)
      unless translation.nil?
        if translation.kind_of? String
          assert_equal(translation, str)
        elsif translation.kind_of? Regex
          assert_match(translation, str)
        elsif translation.kind_of? Symbol
          assert_equal(I18n.translate(translation), str)
        end # else falls through
      end
    end
  end
end
