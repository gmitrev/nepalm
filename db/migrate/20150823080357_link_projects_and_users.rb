class LinkProjectsAndUsers < ActiveRecord::Migration
  def change
    Project.all.each do |pr|
      users = pr.stacks.flat_map(&:users).uniq

      users.each do |u|
        pr.project_users.create(user: u)
      end
    end
  end
end
