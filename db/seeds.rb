# Create Categories
CATEGORIES = ['Ruby On Rails', 'GraphQL', 'QuickBooks'].freeze
CATEGORIES.each do |category_name|
  category = Category.find_or_initialize_by(name: category_name)
  category.save
end
