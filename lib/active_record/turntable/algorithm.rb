module ActiveRecord::Turntable
  module Algorithm
<<<<<<< HEAD
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Base
      autoload :RangeAlgorithm
      autoload :RangeBsearchAlgorithm
    end
=======
    autoload :Base, "active_record/turntable/algorithm/base"
    autoload :RangeAlgorithm, "active_record/turntable/algorithm/range_algorithm"
    autoload :RangeBsearchAlgorithm, "active_record/turntable/algorithm/range_bsearch_algorithm"
    autoload :ModuloAlgorithm, "active_record/turntable/algorithm/modulo_algorithm"
>>>>>>> tiepadrino
  end
end
