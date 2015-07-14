class InitializeTotalFileSizeInProjects < ActiveRecord::Migration
  def change
    Project.all.each do |p|
      total_file_size = p.stacks.flat_map(&:comments).flat_map(&:attachments).flat_map(&:asset).compact.map(&:file_file_size).reduce(:+)

      p.update_column(:total_file_size, total_file_size)
    end
  end
end
