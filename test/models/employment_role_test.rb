# == Schema Information
#
# Table name: employment_roles
#
#  id                          :integer          not null, primary key
#  name                        :string           not null
#  billable                    :boolean          not null
#  level                       :boolean          not null
#  employment_role_category_id :integer
#

require 'test_helper'

class EmploymentRoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end