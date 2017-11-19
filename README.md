Rails subdomain app

rails g model Blog name subdomain
rails g model Post title body:text blog:references
rake db:migrate

toggle line below to comment in controller(aşağıdaki satırı yorum satırı yapın)
```ruby
before_action :set_blog, only: [:edit, :update, :destroy] 
```

add line below to blog.rb
```ruby
has_many :posts
```
add lines below to config.rb 
```ruby
match '/', to: 'blogs#index', constraints: { subdomain: 'www' }, via: [:get, :post, :put, :patch, :delete]
match '/', to: 'blogs#show', constraints: { subdomain: /.+/ }, via: [:get, :post, :put, :patch, :delete]

root to: "blogs#index"
```


add lines below to application_controller.rb (aşağıdaki satırları ekleyin)
```ruby
before_action :get_blog

private
  def get_blog

    blogs = Blog.where(subdomain: request.subdomain)

    if blogs.count > 0
      @blog = blogs.first
    elsif request.subdomain != 'www'
      redirect_to root_url(subdomain: 'www')
    end
  end
```
add line below to show func in blogs_controller.rb(aşağıdaki satırları ekleyin)

 -add lines below to application_controller.rb

change line in index.html.erb like below (aşağıdaki satırları değiştirin)
```
- <td><%= link_to 'Show', root_url(subdomain: blog.subdomain) %></td>
```
add lines below to blog's show.html.erb above buttons (aşağıdaki satırları ekleyin)
```
<h1><%= @blog.name %></h1>
	<hr />
	<% @posts.each do |post| %>

	<h3><%= post.title %></h3>
	<p><%= truncate post.body, length: 160 %></p>
	<%= link_to "Read More", post %>
<% end %>
	```

add lines below to seeds.rb (aşağıdaki satırları ekleyin)
```ruby
Blog.delete_all
Blog.create(id: 1, name: "My Example Blog", subdomain: "ornek")
Blog.create(id: 2, name: "Awesome Blog", subdomain: "awesome")


Post.delete_all
Post.create(id: 1, blog_id: 1, title: "An Example of a Post", body: "This is a perfect example of a blog post.  Feel free to reference this example in your other applications.  Note that the author of this blog post does not accept responsibility for the contents of this blog post.")
Post.create(id: 2, blog_id: 1, title: "Another Example of a Post", body: "This is yet another example of a blog post.  This one is less perfect than the first one.")
Post.create(id: 3, blog_id: 2, title: "An Utterly Awesome Post", body: "This is a super awesome example of a really good blog post.  You should...like...totally copy this!")
Post.create(id: 4, blog_id: 2, title: "Yet Another Utterly Post", body: "This is yet ANOTHER example of a super awesome blog post.  You should totally copy this one as well!")
```


rails db:seed

-- Start server and go to http://www.vcap.me:3000 adrress


multi tenancy:

Add gem 'apartment' (gemi ekleyin)

execute line below (Aşağıdaki satırı gerçekleyi)
```
bundle exec rails generate apartment:install
```

This will create a config/initializers/apartment.rb initializer file (yandaki dosya oluşacak)

add line below to aparment.rb (aşağıdaki satırı dosyaya ekleyin)

require 'apartment/elevators/subdomain' and edit two lines below in the same file
```ruby
config.excluded_models = %w{ Blog }
config.tenant_names = lambda { Blog.pluck :subdomain }
```

Your post model will seem like this (post modeli aşağıdaki gibi olmalı)
```ruby
class Blog < ApplicationRecord
  after_create :create_tenant
  has_many :posts

  private
  
  def create_tenant
    Apartment::Tenant.create(subdomain)
    end

end
```

in application.rb add lines below (aşağıdaki satırı dosyaya ekleyin)

first require 'apartment/elevators/subdomain' (ilk olarak bunu ekleyin)

then inside class Application < Rails::Application block (yandaki sınıfın içine bunları ekleyin)
```ruby
config.middleware.use Apartment::Elevators::Subdomain
Apartment::Elevators::Subdomain.excluded_subdomains = ['www']

and you are done :)
```
