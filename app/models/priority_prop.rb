class PriorityProp < Prop
  has_one :node, :as => :prop
  
  validates_presence_of :node, :on => :update # less stringent when the Prop is new in order to prevent circular dependencies
  
  validate :in_range
  
  
  #is_badgeable
  
  
  def self::rand_new
    new :priority => Kernel.rand(5) + 1
  end
  
  def self::filler_new
    new :priority => 1
  end
  
  
protected
  
  def in_range
    errors.add(:priority, "was {{value}}; must be in the range of 1 to 5") unless (1..5).include? priority
  end
  
end
