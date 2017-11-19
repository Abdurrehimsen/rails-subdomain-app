class Blog < ApplicationRecord
	after_create :create_tenant
	has_many :posts

	private
	
	def create_tenant
	 	Apartment::Tenant.create(subdomain)
    end

end
