# ![tramway-ico](https://raw.githubusercontent.com/kalashnikovisme/kalashnikovisme/master/%D1%82%D1%80%D1%8D%D0%BC%D0%B2%D1%8D%D0%B9%D0%B1%D0%B5%D0%B7%D1%84%D0%BE%D0%BD%D0%B0-min.png) Tramway::Core [![Tests](https://github.com/Purple-Magic/tramway/actions/workflows/tests.yml/badge.svg)](https://github.com/Purple-Magic/tramway/actions/workflows/tests.yml) [![Rubocop](https://github.com/Purple-Magic/tramway/actions/workflows/rubocop.yml/badge.svg)](https://github.com/Purple-Magic/tramway/actions/workflows/rubocop.yml) [![Gem Version](https://badge.fury.io/rb/tramway.svg)](https://badge.fury.io/rb/tramway)

*If you need translation of this Readme, please message us kalashnikov@ulmic.ru. We'll translate for you and post to this page*

tramway - это ядро проекта [tramway](https://github.com/purple-magic/tramway)

Этот гем предоставляет базовые классы и реализации для других шаблонов Tramway. Как правило, каждый шаблон Tramway должен иметь в зависимостях последнюю версию гема `tramway`.

# Installation

*Gemfile*
```ruby
gem 'tramway'
gem 'audited'
gem 'clipboard-rails'
```

```shell
rails g tramway:install
```

*config/initializers/tramway.rb*
```ruby
# Initialize application with name
Tramway::Core.initialize_application name: :your_application_name

# Initialize application name with model_class. Model class must be a singlethon
Tramway::Core.initialize_application model_class: ::Tramway::Conference::Unity # example was taken from tramway-conference gem
```

*config/initializers/assets.rb*
```ruby
Rails.application.config.assets.precompile += %w( *.jpg *.png *.js )
```

#### Every Tramway application need initialized @application object (or if you create Tramway plugin, it should be @application_engine object).

You don't need to initialize this object yourself, just configurate application with Tramway. You have **2** options of this:

## Option 1. If you want to change @application object just in the code base.

```shell
rails g tramway:install
```

*config/initializers/tramway.rb*

```ruby
Tramway::Core.initialize_application name: :your_application_name
```

## Option 2. If you want to change @application object from admin panel. How to create model that will be an Application Model for the Tramway

#### 1. Generate model that you to use. We create Organization, for example

```shell
rails g tramway:application
rails db:migrate
```

#### 2. Add model_class to Initializer

```ruby
Tramway::Core.initialize_application model_class: Organization
```

#### 3. Create 1 instance of Organization model

```ruby
rails c
Organization.create! public_name: 'Tramway', name: :organization, tagline: 'Tramway is not buggy, LOL!', main_image: 'https://raw.githubusercontent.com/ulmic/tramway-dev/develop/logo.png'
```

#### 4. Add model to singleton to the `tramway-admin` admin panel to be able to change its data

```ruby
Tramway::Admin.set_singleton_models Organization, project: :organization # now you should use organization.name here
```

#### 5. Then continue configuration of your model in admin panel with tramway-admin gem [instruction, starting from point 8](https://github.com/ulmic/tramway-dev/tree/develop/tramway-admin#8-configurate-navbar)

#### 6. Now you are able to change your application main info in admin panel

## How-to

### add favicon to your application

*config/initializers/tramway.rb*
```ruby
::Tramway::Core.initialize_application attribute1: value, another_attribute: another_value, favicon: `/icon.ico` # icon should be in public folder
```

# Usage

## Tramway::Core::ApplicationRecord

### uploader

Tramway use [carrierwave](https://github.com/carrierwaveuploader/carrierwave) for file uploading by default. To mount uploader you should use `uploader` method

Interface: `uploader(attribute_name, uploader_name, **options)`

* attribute_name - ActiveRecord attribute to mount uploader
* uploader_name - **short** uploader name. You need to connect uploaders which are compatible with Tramway. Available uploaders:
  * :photo - you can see it [here](https://github.com/Purple-Magic/tramway/blob/develop/app/uploaders/photo_uploader.rb)
  * :file - you can see it [here](https://github.com/Purple-Magic/tramway/blob/develop/app/uploaders/file_uploader.rb)
  * :ico - you can see [here](https://github.com/Purple-Magic/tramway/blob/develop/app/uploaders/ico_uploader.rb)
* options - you are available to set options for uploaders exactly for this model. Available options:
  * versions - **only for :photo**. Set needed versions for file to be cropped. If empty - 0 zero versions will be used. All versions you can see [here](https://github.com/Purple-Magic/tramway/blob/develop/app/uploaders/photo_uploader.rb)
  * extensions - whitelist of file extensions. If empty will be used default whitelist from the uploaders (links above)

Example:

```ruby
class User < Tramway::Core::ApplicationRecord
  uploader :avatar, :photo, version: [ :small, :medium ], extensions: [ :jpg, :jpeg ]
end
```

## Tramway::Core::ApplicationDecorator
### Associations

Your can decorate association models. Supporting all types of association

*app/decorators/your_model_decorator.rb*
```ruby
class YourModelDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :some_model
  decorate_association :another_model, decorator: SpecificDecoratorForThisCase
  decorate_association :another_one_model, as: :repeat_here_as_parameter_from_model
  decorate_association :something_else_model, state_machines: [ :here_array_of_state_machines_you_want_to_see_in_YourModel_show_page ] # support from tramway-admin gem
end
```

You can decorate a lot of models in one line

*app/decorators/your_model_decorator.rb*
```ruby
class YourModelDecorator < Tramway::Core::ApplicationDecorator
  decorate_associations :some_model, :another_model, :another_one_model, :something_else_model
end
```

Also, you can configurate what associations you want to see in YourModel page in admin panel *support only for [tramway-admin](https://rubygems.org/gems/tramway-admin) gem*

*app/decorators/your_model_decorator.rb*
```ruby
class YourModelDecorator < Tramway::Core::ApplicationDecorator
  class << self
    def show_associations
      [ :some_model, :another_model, :another_one_model ]
    end
  end
end
```

### Delegating attributes

*app/decorators/your_model_decorator.rb*
```ruby
class YourModelDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :title, :something_else, :another_atttribute
end
```

### Helper methods

#### date_view
Returns a date in the format depending on localization

*app/decorators/\*_decorator.rb*
```ruby
def created_at
  date_view object.created_at
end
```
#### datetime_view
Returns a date and time in the format depending on localization

*app/decorators/*_decorator.rb*
```ruby
def created_at
  datetime_view object.created_at
end
```
#### state_machine_view
Returns the state of an object according to a state machine

*app/decorators/*_decorator.rb*
```ruby
def state
  state_machine_view object, :state
end
```
#### image_view
Returns an image in a particular format depending on the parameters of the original image file

*app/decorators/\*_decorator.rb*
```ruby
def avatar
  image_view object.avatar
end
```
#### enumerize_view
Returns object enumerations as text

*app/decorators/\*_decorator.rb*
```ruby
def field_type
  enumerize_view object.field_type
end
```

## Other helpers

### CopyToClipboardHelper

[app/helpers/tramway/copy_to_clipboard_helper.rb] (https://github.com/ulmic/tramway-dev/blob/develop/tramway/app/helpers/tramway/copy_to_clipboard_helper.rb)

#### Install

```ruby
include ::Tramway::Core::CopyToClipboardHelper
```

#### How to use it

It will show you in the view in bootstrap styles with font-awesome `copy` icon.

Something like this:

![copy_to_clipboard_button](https://raw.githubusercontent.com/ulmic/tramway-dev/develop/tramway/docs/copy_to_clipboard_button.png)

```ruby
copy_to_clipboard "some_id" # some_id is HTML id of element. Content of this element will be copied to the clipboard after pressing the button
```

# Development

To start developing you should:

#### 1. install gems

```shell
bundle install
```

Also need to install [ImageMagick](https://imagemagick.org) for [rmagick](https://github.com/rmagick/rmagick). You can read the manual for your OS [here](https://github.com/rmagick/rmagick#prerequisites)

#### 2. Create a test database

```shell
cd spec/dummy
rails db:create db:migrate RAILS_ENV=test
cd ../../
```

#### 3. Run tests

```shell
rspec
```

All tests should be green =)

## In Russian

# Базовые классы

* ApplicationDecorator - Базовый класс декоратора. В него по умолчанию включены `ActionView::Helpers` и `ActionView::Context` и `FontAwesome5` (версия гема FontAwesome, которая поддерживает 5 версию шрифта). `FontAwesome` считается в `Tramway` основным шрифтом для иконок.
* ApplicationForm - наследованный от Reform::Form класс форм.
* ApplicationRecord  - базовый класс для AR моделей
* ApplicationUploader - базовый класс для Carrierwave аплоадеров.
* FileUploader - базовый класс для загрузки файлов
* PhotoUploader - базовый класс для загрузки фотографий
* Вьюха `_messages` - предоставляет отображение ошибок в форме. Совместима с AR и Reform

# Локализация

* dates - правила локализации даты
* helpers - часто используемые в формах слова
* models - часто используемые в моделях слова
* state_machines - локализация состояний

## Contribution

### Contributors

* [Pavel Kalashnikov](https://github.com/kalashnikovisme)
* [moshinaan](https://github.com/moshinaan)

### Run tests

```shell
make test
```

### Deployment workflow

#### If you don't have access to push gem to rubygems then

Just create PR to develop branch

#### If you have access to push gem to rubygems then

* Create PR to develop branch
* After merging PR you should create new release via git-flow this way

```shell
git release start (version which you upgraded in lib/tramway/version.rb file)
git release finish (version which you upgraded in lib/tramway/version.rb file)
git push origin develop
git push origin master
```

* Then push new version of the gem

```shell
rm -rf *.gem && gem build $(basename "$PWD").gemspec && gem push *.gem
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
