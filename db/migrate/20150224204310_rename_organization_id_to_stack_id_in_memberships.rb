class RenameOrganizationIdToStackIdInMemberships < ActiveRecord::Migration
  def change
    rename_column :memberships, :organization_id, :stack_id
  end
end
