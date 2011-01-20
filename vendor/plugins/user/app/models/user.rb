require 'digest/sha1'
require 'forwardable'

USER_UNIQUE_NAME_FORMAT = /^[A-Za-z0-9_\-\+]+$/ unless Object.const_defined?(:USER_UNIQUE_NAME_FORMAT)

class User < ActiveRecord::Base
  extend Forwardable
  include SecurityProxy, UserAuthentication

  has_one :profile, :dependent => :destroy
  has_many :logins, :dependent => :destroy
  has_many :password_reset_tokens, :as => :tokenable, :conditions => {:used => false}, :dependent => :destroy
  has_many :email_addresses, :dependent => :destroy
  has_one :primary_email_address, :class_name => 'EmailAddress', :conditions => {:primary => true}
  belongs_to :terms_of_service
  has_many :auto_logins, :as => :tokenable

  validate :unique_name_is_valid
  validates_uniqueness_of :unique_name,
                          :message => "Unique name has already been taken.".customize

  validates_acceptance_of :accept_terms_of_service, :on => :create, :allow_nil => false,
                          :message => "Terms of service must be accepted.".customize, :if => lambda {|user| user.needs_to_accept_tos?}
  validate :primary_email_address_is_valid
  validates_associated :profile

  before_validation_on_create :assign_unique_name
  before_save :increment_tos
  after_update :save_primary_email_address
  before_create :ensure_profile_is_initialized

  delegate :first_name=, :last_name=, :first_name, :last_name, :to => :profile
  def_delegator :primary_email_address, :address, :email_address
  def_delegator :primary_email_address, :address=, :email_address=

  attr_protected :super_admin, :encrypted_password, :salt

  acts_as_paranoid unless Object.const_defined?(:DISABLE_ACTS_AS_PARANOID)

  def self.find_by_email_address(email_address)
    email_address = EmailAddress.find_by_address(email_address)
    email_address && email_address.user
  end

  def self.find_by_param(param)
    find_by_unique_name(param)
  end

  def to_param
    self[:unique_name]
  end

  def primary_email_address_with_lazy_initialization
    primary_email_address_without_lazy_initialization || build_primary_email_address(:primary => true)
  end
  alias_method_chain :primary_email_address, :lazy_initialization

  def profile_with_lazy_initialization
    profile_without_lazy_initialization || build_profile
  end
  alias_method_chain :profile, :lazy_initialization

  def to_s
    unique_name_is_unspecified? ? 'unspecified unique_name'.customize : unique_name
  end

  def last_login
    activity = logins.find(:first, :order => "created_at DESC")
    activity.nil? ? nil : activity.created_at
  end

  def account_verified?
    primary_email_address.verified?
  end

  def verify_account!
    primary_email_address.verified = true
    primary_email_address.save
  end

  def full_name
    names = [first_name, last_name].reject { |i| i.blank? }
    names.empty?? unique_name : names.join(' ')
  end

  def needs_to_accept_tos?
    !TermsOfService.latest?(terms_of_service)
  end

  def creatable_by?(creator)
    return false if super_admin_changed? && !creator.prior_super_admin?
    true
  end

  def updatable_by?(updator)
    return true if updator.prior_super_admin?
    return false if super_admin_changed? && !updator.prior_super_admin?
    self == updator
  end

  def destroyable_by?(destroyer)
    updatable_by?(destroyer)
  end

  def unique_name=(new_unique_name)
    self[:unique_name] = new_unique_name
    self.unique_name_is_unspecified = false
  end

  def unique_name
    return "" if unique_name_is_unspecified?
    self[:unique_name]
  end

  def super_admin=(new_super_admin_flag)
    # This allows a non-superadmin to set this to true transiently,
    # it will only trigger a SecurityTransgressionError when the
    # record is saved.
    @prior_super_admin ||= super_admin
    self[:super_admin] = new_super_admin_flag
  end

  def prior_super_admin?
    return super_admin if @prior_super_admin.nil?
    @prior_super_admin
  end

  private
  def assign_unique_name
    if self[:unique_name].blank?
      self.unique_name = Guid.new.to_s
      self.unique_name_is_unspecified = true
    end
  end

  def increment_tos
    self.terms_of_service = TermsOfService.latest if needs_to_accept_tos?
  end

  def save_primary_email_address
    primary_email_address.save if primary_email_address.address_changed?
  end

  def primary_email_address_is_valid
    unless primary_email_address.valid?
      primary_email_address.errors.each do |attr, message|
        errors.add(attr, message)
      end
    end
  end

  def ensure_profile_is_initialized
    profile
  end

  def unique_name_is_valid
    unless self[:unique_name] =~ ::USER_UNIQUE_NAME_FORMAT
      errors.add(:unique_name, "Unique name must be composed of letters, digits, underscores, or hyphens.".customize)
    end
  end
end

