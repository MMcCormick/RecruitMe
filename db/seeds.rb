# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create codenames
fruits = [
    'apple','peach','strawberry','nectarine','grape','blueberry','cherry','pear','plum','raspberry','orange',
    'honeydew','melon','cantaloupe','papaya','watermelon','grapefruit','kiwi','mango','pineapple'
]
veggies = [
    'celery','pepper','spinach','lettuce','cucumber','potato','kale','carrot','squash','broccoli','onion','tomato',
    'cauliflower','mushroom','eggplant','asparagus','cabbage','avocado','corn'
]
nouns = fruits + veggies
File.open("#{Rails.root}/db/adjectives.txt").each_line do |adjective|
  next unless adjective.strip.length > 0

  nouns.each do |noun|
    codename = "#{adjective.capitalize.delete("\n")} #{noun.capitalize}"
    puts codename
    unless Codename.where(:name => codename).first
      Codename.create(:name => codename)
    end
  end
end