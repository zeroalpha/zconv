require 'test_helper'


class ZconvTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Zconv::VERSION
  end

  def test_it_does_something_useful
    skip
  end
end

class DatasetTest < Minitest::Test
  def setup
    super
    @dataset = ::Zconv::Dataset.new ::TestData::SOURCE[:fb80]
  end

  def test_it_lives
    assert_instance_of Zconv::Dataset, @dataset
  end

  def test_convert
    assert_equal @dataset.convert, ::TestData::TARGET[:fb80], "You had ONE JOB"
  end
end
