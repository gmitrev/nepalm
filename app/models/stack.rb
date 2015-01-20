class Stack < ActiveRecord::Base
  belongs_to :project

  def summary
    if(read_attribute(:summary).present?)
      read_attribute(:summary)
    else
      'No summary available'
    end
  end
end
