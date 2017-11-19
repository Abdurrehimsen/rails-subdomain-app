class Post < ApplicationRecord
  belongs_to :blog, optional:true
end
