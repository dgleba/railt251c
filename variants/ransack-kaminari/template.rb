apply 'variants/ransack-kaminari/Gemfile.rb'
apply 'variants/ransack-kaminari/app/template.rb'
apply 'variants/ransack-kaminari/config/template.rb'
apply 'variants/ransack-kaminari/lib/template.rb'
apply 'variants/ransack-kaminari/spec/template.rb'

generate 'kaminari:config'


# set records per page..
gsub_file 'config/initializers/kaminari_config.rb',
          '# config.default_per_page = 25',
          'config.default_per_page = 10'
