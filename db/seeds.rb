# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Blog.create(id: 1, name: "My Example Blog", subdomain: "example")
Blog.create(id: 2, name: "Awesome Blog", subdomain: "awesome")


Post.delete_all
Post.create(id: 1, blog_id: 1, title: "An Example of a Post", body: "This is a perfect example of a blog post.  Feel free to reference this example in your other applications.  Note that the author of this blog post does not accept responsibility for the contents of this blog post.")
Post.create(id: 2, blog_id: 1, title: "Another Example of a Post", body: "This is yet another example of a blog post.  This one is less perfect than the first one.")
Post.create(id: 3, blog_id: 2, title: "An Utterly Awesome Post", body: "This is a super awesome example of a really good blog post.  You should...like...totally copy this!")
Post.create(id: 4, blog_id: 2, title: "Yet Another Utterly Post", body: "This is yet ANOTHER example of a super awesome blog post.  You should totally copy this one as well!")