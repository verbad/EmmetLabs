dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

class SecureController < ApplicationController
  def index
    head :ok
  end

  def show
    head :ok
  end

  def edit
    head :ok
  end

  def can_index?
    false
  end

  def can_edit?
    true
  end
end

class ControllerWithDefaultSecurity < ApplicationController
  def index
    head :ok
  end

  def show
    head :ok
  end

  def can_access?
    false
  end

  def can_show?
    true
  end

end

describe SecureController do
  it "should allow indexing only if can_index? is true" do
    proc { get :index }.should raise_error(SecurityTransgression)
  end

  it "can edit, because the security says you can" do
    proc { get :edit }.should_not raise_error(SecurityTransgression)
  end

  it "should allow showing since can_show? is undefined" do
    proc { get :show }.should_not raise_error(SecurityTransgression)
  end
end

describe ControllerWithDefaultSecurity do

  it "disallows index based on default security" do
    proc { get :index }.should raise_error(SecurityTransgression)
  end

  it "allows show because show overrides default" do
    proc { get :show }.should_not raise_error(SecurityTransgression)
  end

end