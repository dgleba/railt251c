RAILS_REQUIREMENT = '~> 4.2.6'.freeze

def apply_template!
  # assert_minimum_rails_version
  add_template_repository_to_source_path


  # remove_file 'README.rdoc'
  # template 'README.md.tt', force: true
  # template 'DEPLOYMENT.md.tt', force: true

  template 'Gemfile.tt', force: true
    
  template 'example.env.tt', 'example.env'
  template 'ruby-version.tt', '.ruby-version'
  # template 'erdconfig.tt', '.erdconfig'
  # copy_file 'rubocop.yml', '.rubocop.yml'
  #copy_file '.capistrano/metrics'
  copy_file 'gitignore', '.gitignore', force: true
  # copy_file 'Procfile'



  #dgleba
  # copy_file 'db/seeds.rb', 'db/seeds.rb', force: true

  apply 'app/template.rb'
  apply 'config/template.rb'
  apply 'bin/template.rb'
  apply 'lib/template.rb'
  #apply 'vendor/template.rb'
  

  run 'bundle install --quiet'

  apply 'variants/template.rb'

  #copy sorcery config file..

  
  # run a final bundle update to have the latest and greatest version of all
  # before we initial commit
  run 'bundle update --quiet'
  
  
  # run 'rails generate scaffold User email:string crypted_password:string salt:string --no-migration --skip'

  # apply 'dg/tpcustomer.rb'
  # $repo1 = 'https://raw.githubusercontent.com/dgleba/rails-template-dg1/master/'
  # rake 'rails:template LOCATION=#{$repo1}dg/tpcustomer.rb'
     
 
  #migrate and seed and other things..
  run 'bin/setup'
  generate_spring_binstubs
  
  # setup git
  git :init
  git add: '.'
  git commit: "-aqm 'Initial commit'"
  git checkout: '-b develop'
end

require 'fileutils'
require 'shellwords'

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    source_paths.unshift(tempdir = Dir.mktmpdir('rails-template'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/dgleba/rails-template-dg1.git',
      tempdir
    ].map(&:shellescape).join(' ')
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

def gemfile_requirement(name)
  @original_gemfile ||= IO.read('Gemfile')
  req = @original_gemfile[/gem\s+['"]#{name}['"]\s*(,[><~= \t\d\.\w'"]*).*$/, 1]
  req && req.gsub("'", %(")).strip.sub(/^,\s*"/, ', "').gsub('"', "'")
end

# Mimic the convention used by capistrano in order to generate
# accurate deployment documentation.
def lower_case_app_name
  app_name.gsub(/[^a-zA-Z0-9_]/, '_').downcase
end

def ask_with_default(question, color, default)
  question = (question.split('?') << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

apply_template!
