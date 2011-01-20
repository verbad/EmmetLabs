class EmailAddress < ActiveRecord::Base
  acts_as_paranoid unless Object.const_defined?(:DISABLE_ACTS_AS_PARANOID)
  
  attr_protected :verified

  belongs_to :user
  has_many :verification_tokens, :as => :tokenable, :class_name => 'EmailAddressVerificationToken', :dependent => :destroy

  validates_format_of :address,
                      :with => RFC::EmailAddress,
                      :message => "The email address you provided is not valid".customize
  validate_on_update :only_verified_can_be_primary
  validate :verified_addresses_must_be_unique

  named_scope :verified, :conditions => {:verified => true}

  before_create :build_verification_token
  after_update :normalize_primary

  def self.verifies_none?
    @verification_mode == :none
  end

  def self.verifies_all?
    @verification_mode == :all
  end

  def self.verifies_first?
    @verification_mode == :first
  end

  def self.requires_verification_for(mode)
    @verification_mode = mode
  end
  requires_verification_for :all
  
  def to_s
    address
  end
  
  def destroyable_by?(destroyer)
    user == destroyer && !primary?
  end

  def updatable_by?(updator)
    user == updator
  end

  def initialize(*args, &block)
    super
    self.verified ||= !address_requires_verification?
  end
  
  private
  
  def build_verification_token
    verification_tokens.build unless verified?
  end

  def normalize_primary
    if primary?
      user.email_addresses.find(:all, :conditions => ['id != ? AND `primary` = ?', self.id, true]).each do |e|
        e.primary = false
        e.save
      end
    end
  end

  def only_verified_can_be_primary
    if !verified && primary? && user.email_addresses.find_by_verified(true)
      errors.add(:primary, "An unvalidated email address cannot be made primary".customize)
    end
  end

  def verified_addresses_must_be_unique
    if !other_verified_duplicate_addresses.empty?
      errors.add(:address, "The email address you provided is already taken".customize)
    end
  end

  def other_verified_duplicate_addresses
    EmailAddress.find(:all, :conditions => ['address = ? AND verified = 1', address]).reject { |e| e == self }
  end

  def address_requires_verification?
    self.class.verifies_all? || (self.class.verifies_first? && !other_verified_address_exists?)
  end

  def other_verified_address_exists?
    user && user.email_addresses.find_by_verified(true)
  end
end