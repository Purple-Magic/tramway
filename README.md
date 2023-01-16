# ![tramway-ico](https://raw.githubusercontent.com/kalashnikovisme/kalashnikovisme/master/%D1%82%D1%80%D1%8D%D0%BC%D0%B2%D1%8D%D0%B9%D0%B1%D0%B5%D0%B7%D1%84%D0%BE%D0%BD%D0%B0-min.png) Tramway [![Tests](https://github.com/Purple-Magic/tramway/actions/workflows/tests.yml/badge.svg)](https://github.com/Purple-Magic/tramway/actions/workflows/tests.yml) [![Rubocop](https://github.com/Purple-Magic/tramway/actions/workflows/rubocop.yml/badge.svg)](https://github.com/Purple-Magic/tramway/actions/workflows/rubocop.yml) [![Gem Version](https://badge.fury.io/rb/tramway.svg)](https://badge.fury.io/rb/tramway)

# Installation

*Gemfile*
```ruby
gem 'tramway'
gem 'audited'
gem 'clipboard-rails'
gem 'bcrypt'
gem 'haml-rails'
gem 'bootstrap'
gem 'jquery-rails'
gem 'copyright_mafa'
gem 'trap'
gem 'kaminari'
gem 'bootstrap-kaminari-views', github: 'kalashnikovisme/bootstrap-kaminari-views', branch: :master
gem 'state_machine_buttons'
gem 'ckeditor', '4.2.4'
gem 'ransack'
gem 'smart_buttons'
gem 'carrierwave'
gem 'validates'
```

*config/initializers/tramway.rb*
```ruby
# Initialize application with name
Tramway.initialize_application name: :your_application_name

# Initialize application name with model_class. Model class must be a singlethon
Tramway.initialize_application model_class: MyApplication
```

```shell
rails g tramway:install
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

# ![tramway-ico](https://raw.githubusercontent.com/kalashnikovisme/kalashnikovisme/master/%D1%82%D1%80%D1%8D%D0%BC%D0%B2%D1%8D%D0%B9%D0%B1%D0%B5%D0%B7%D1%84%D0%BE%D0%BD%D0%B0-min.png) Tramway::Admin

Create admin panel for your application FAST!

## Usage
How to use my plugin.

#### 1. Add this gems to Gemfile

#### 2. You should remove gem `turbolinks` from your application and from app/assets/javascripts/application.js

#### 3. Update your routes

*config/routes.rb*

```ruby
Rails.application.routes.draw do
  mount Tramway::Auth::Engine, at: '/auth'
  mount Tramway::Admin::Engine, at: '/admin'
end
```

#### 4. Then make `tramway-core` installation. [How-to](https://github.com/Purple-Magic/tramway-core/blob/develop/README.md#installation)


#### 5. And then execute:

```bash
$ rails g tramway:user:install
$ rails db:migrate
```

#### 6. Create your first admin user

```bash
$ rails c
$> Tramway::User::User.create! email: 'your@email.com', password: '123456789', role: :admin
```

#### 7. Add models to your admin

*app/config/initializers/tramway.rb*

```ruby
# set available models for your admin
::Tramway::Admin.set_available_models YourModel, AnotherYourModel, project: #{project_name_which_you_used_in_application_name}
# set singleton models for your admin
::Tramway::Admin.set_singleton_models YourSingletonModel, AnotherYourSingletonModel, project: #{project_name_which_you_used_in_application_name}
::Tramway::Auth.root_path = '/admin' # you need it to redirect in the admin panel after admin signed_in
```

#### 8. Configurate navbar

*config/initializers/tramway.rb*
```ruby
Tramway::Admin.navbar_structure(
  YourModel, # this line will create first-level link in your navbar, which will send you to the YourModel management
  {
    my_dropdown: [ # this line contains dropdown link name
      AnotherYourModel # this line will create 2nd-level link in your navbar, which will send you to the YourModel management,
      :divider # this line adds bootstrap divider to the dropdown list
    ]
  },
  project: :your_application_name
)
```
#### 9. Create decorators and forms for all available_models.
You can run generator that will create all necessary files
```bash
$ rails g tramway:admin:install
```
Or generate decorator and form for only one model
```bash
$ rails g tramway:admin:model Coworking
```
If you're using several user roles in your admin dashboard, then you can specify scope for the form(default scope is `admin`)
```bash
$ rails g tramway:admin:install --user-role=partner
```

Or you can create forms and decorators manually as it written below:

#### 9a. Create decorator for models [manual option]

*app/decorators/your_model_decorator.rb*
```ruby
class YourModelDecorator < Tramway::Core::ApplicationDecorator
  decorate_associations :messages, :posts

  class << self
    def collections
      [ :all, :scope1, :scope2 ]
    end

    def list_attributes
      [ :begin_date, :end_date ]
    end

    def show_attributes
      [ :begin_date, :end_date ]
    end

    def show_associations
      [ :messages ]
    end

    def list_filters
      {
        filter_name: {
          type: :select,
          select_collection: filter_collection,
          query: lambda do |list, value|
            list.where some_attribute: value
          end
        },
        date_filter_name: {
          type: :dates,
          query: lambda do |list, begin_date, end_date|
            list.where 'created_at > ? AND created_at < ?', begin_date, end_date
          end
        }
      }
    end
  end

  delegate_attributes :title
end
```

**NOTES:**
* `collections` method must return array of scopes of `YourModel`. Every collection will be a tab in a list of your model in admin panel
* `list_filters` method returns hash of filters where:
  * select_collection - collection which will be in the select of filter. It must be compatible with [options_for_select](https://apidock.com/rails/ActionView/Helpers/FormOptionsHelper/options_for_select) method
  * query - some Active Record query which be used as a filter of records
* `list_attributes` method returns array of attributes which will be shown in index page. If empty only `name` will be shown
* `show_attributes` method returns array of attributes which will be shown in show page. If empty all attributes of the model will be shown
* `show_associations` method returns array of decorated associations which will be show in show page. If empty no associations will be shown

Filters naming:

*Select filters*

```yaml
en:
  tramway:
    admin:
      filters:
        model_name:
          filter_name: Your Filter
```

*Date filters*

```yaml
en:
  tramway:
    admin:
      filters:
        model_name:
          date_filter_name:
            begin_date: Your Begin date filter
            end_date Your end date filter
```

#### 9b. Create `Admin::YourModelForm` [manual option]

*app/forms/admin/your_model_form.rb
```ruby
class Admin::YourModelForm < Tramway::Core::ApplicationForm
  properties :title, :description, :text, :date, :logo

  association :associated
  association :another_polymorphic_associated

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        logo: :file,
        description: :ckeditor,
        date: :date_picker,
        text: :text,
        associated: :association,
        another_polymorphic_association: :polymorphic_association,
        birth_date: {
          type: :default,
          input_options: {
            hint: 'It should be more than 18'
          }
        }
    end
  end
end
```

**NOTE**
If you want fill inputs of this form, just send query params

```
params = {
  your_model: {
    logo: '/file/url',
    description: 'some text',
    text: 'some another text',
    associated_id: 5,
    another_polymorphic_associated: 56,
    another_polymorphic_associated_type: 'AnotherModel'
  }
}
```

#### 10. Add inheritance to YourModel

*app/models/your_model.rb*
```ruby
class YourModel < Tramway::Core::ApplicationRecord
end
```

### 11. You can add search to your index page

Tramway use gem [PgSearch](https://github.com/Casecommons/pg_search`) as search engine

Just add `search` method to `YourModel` like this

```ruby
search_by *attributes, **associations # `attributes` and `associations` should be the same syntax as in PgSearch
```

Example:

```ruby
class YourModel < Tramway::Core::ApplicationRecord
  search_by :my_attribute, :another_attribute, my_association: [ :my_association_attribute, :another_my_association_attribute ]
```

#### 12. Run server `rails s`
#### 13. Launch `localhost:3000/admin`

### CRUDs for models

By default users with role `admin` have access to all models used as arguments in method `::Tramway::Admin.set_available_models`. If you want specify models by roles, use them as keys

```ruby
::Tramway::Admin.set_available_models ::Tramway::Event::Event, ::Tramway::Event::ParticipantFormField,
  ::Tramway::Event::Participant, ::Tramway::Landing::Block, ::Tramway::User::User,
  ::Tramway::Profiles::SocialNetwork, project: #{project_name_which_you_used_in_application_name}, role: :admin

::Tramway::Admin.set_available_models ::Tramway::Event::Event, ::Tramway::Event::ParticipantFormField,
  ::Tramway::Event::Participant, project: #{project_name_which_you_used_in_application_name}, role: :another_role
```

You can set functions which are available by default some CRUD functions for any role:

```ruby
# this line gives access only index page to YourModel for partner role
::Tramway::Admin.set_available_models YourModel => [ :index ], role: :partner
```

You can set conditions for functions which are available for any role:

```ruby
# this line gives access to destroy only record with name `Elon Musk`

::Tramway::Admin.set_available_models YourModel => [
  destroy => lambda do |record|
    record.name == 'Elon Musk'
  end
 ], role: :partner
```

Here docs about changing roles of `Tramway::User::User` model [Readme](https://github.com/ulmic/tramway-dev/tree/develop/tramway#if-you-want-to-edit-roles-to-the-tramwayuseruser-class)

## Associations management

### has_many

We have models Game and Packs.

*app/models/game.rb*
```ruby
class Game < Tramway::Core::ApplicationRecord
  has_many :packs
end
```

*app/models/pack.rb*
```ruby
class Pack < Tramway::Core::ApplicationRecord
  belongs_to :game
end
```

**You want to manage packs in the Game show admin page**

#### 1. Add association to PackDecorator

*app/decorators/pack_decorator.rb*
```ruby
class GameDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :packs, as: :game # we recommend you to add association name in Pack model. You need it if association name of Game in Pack is not `game`
end
```

### has_and_belongs_to_many

We have models Game and Packs.

*app/models/game.rb*
```ruby
class Game < Tramway::Core::ApplicationRecord
  has_and_belongs_to_many :packs
end
```

*app/models/pack.rb*
```ruby
class Pack < Tramway::Core::ApplicationRecord
  has_and_belongs_to_many :games
end
```

**You want to manage games in the Pack show admin page**

#### 1. Add association to PackDecorator

*app/decorators/pack_decorator.rb*
```ruby
class PackDecorator < Tramway::Core::ApplicationDecorator
  decorate_association :games
end
```

#### 2. Create `Admin::Packs::AddGameForm` and `Admin::Packs::RemoveGameForm`

*app/forms/admin/packs/add_game_form.rb*
```ruby
class Admin::Packs::AddGameForm < Tramway::Core::ApplicationForm
  properties :game_ids
  association :games

  def initialize(object)
    super(object).tap do
      form_properties games: :association
    end
  end

  def submit(params)
    params[:game_ids].each do |id|
      model.games << Game.find(id) if id.present?
    end
    model.save!
  end
end
```

*app/forms/admin/packs/remove_game_form.rb*
```ruby
class Admin::Packs::RemoveGameForm < Tramway::Core::ApplicationForm
  properties :id

  def submit(params)
    model.games -= [Game.find(params)] if id.present?
    model.save!
  end
end

```

#### 3. Add this forms to initializer

*config/initializers/tramway/admin/forms.rb*
```ruby
Tramway::Admin.forms = 'packs/add_game', 'packs/remove_game'
```

## Date Picker locale

DatePicker provides `ru`, `en` locales. To set needed locale, just add

```javascript
window.current_locale = window.i18n_locale('en');
```
to the `app/assets/javascripts/admin/application.js` file

**OR**

```coffeescript
window.current_locale = window.i18n_locale 'en'
```
to the `app/assets/javascripts/admin/application.js.coffee` file

### Decorator Helper methods

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

It takes locales from `I18n.t("state_machines.#{model_name}.#{state_machine_name}.states.#{state_value}")`

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

#### file_view
Returns file name and button to download it

*app/decorators/\*_decorator.rb*
```ruby
def file_download
  file_view object.file
end
```

## Notifications

You can add notification to your admin panel to the navbar.

To add notification to application, you need just set queries in initializers.

*config/initializers/tramway.rb*
```ruby
::Tramway::Admin.set_notificable_queries :"#{your_title}"  => -> { your_query }

# Example from tramway-event gem (you also can push context variables here)

::Tramway::Admin.set_notificable_queries new_participants: -> (current_user) do
  ::Tramway::Event::Participant.where(participation_state: :requested).send "#{current_user}_scope", current_user.id
end
```

**NOTE:** Proc with `current_user` argument is expecting. If you don't need `current_user`, just name do something like that:

```ruby
::Tramway::Admin.set_notificable_queries new_participants: -> (_current_user) do
  # some code which does not need current_user
end
```

## Admin Main Page management

Start page of admin panel contains only `application.name` by default. To manage it just set `Tramway::Admin.welcome_page_actions` with some lambda and set `@content` variable with HTML.

Example:

*config/initializers/tramway/admin.rb*
```ruby
::Tramway::Admin.welcome_page_actions = lambda do
  @content = '<a href="http://it-way.pro">IT Way</a>'
end
```

## Navbar management

### Navbar structure

You can manage your navbar easy

*config/initializers/tramway.rb*
```ruby
Tramway::Admin.navbar_structure(
  YourModel, # this line will create first-level link in your navbar, which will send you to the YourModel management
  {
    my_dropdown: [ # this line contains dropdown link name
      AnotherYourModel # this line will create 2nd-level link in your navbar, which will send you to the YourModel management,
      :divider # this line adds bootstrap divider to the dropdown list
    ]
  },
  project: :your_application_name
)
```

**NOTE:** navbar structure is the same for all roles, but users will see only available models for them

### Dropdown localization

To set human-read name for dropdown link you can use i18n:

*config/locales/admin.yml*

```yaml
en:
  admin:
    navbar:
      links:
        my_dropdown: Very important dropdown
```

## Additional buttons to the show view

You can additional buttons to the header of show view of your model. Just add its configuration to the decorator

*app/decorators/your_model_decorator.rb*
```ruby
class YourModelDecorator < Tramway::Core::ApplicationDecorator
  def additional_buttons
    {
      show: [ # means that this buttons will be shown on show view only
        {
          url: ::Tramway::Export::Engine.routes.url_helpers.export_path(object.id, model: object.class, collection: :tasks),
          inner: lambda do # inner HTML you want to see in the button
            fa_icon 'file-excel'
          end,
          color: :success, # bootstrap button color
          method: :get # HTTP method. get method is a default. Available: :post, :patch: delete
        }
      ]
    }
  end
end
```

## Errors

* **Model or Form is not available** - `params[:model]` or `params[:form]` is empty **OR** current user does not have access to model or form in `params[:model]` or `params[:form]`

## Change admin user base model

*config/initializers/tramway.rb*
```ruby
::Tramway::Admin.auth_config = { user_model: User, auth_attributes: %i[email username] }
```

## Good features

### Get actions log in admin panel

Tramway uses [audited](https://github.com/collectiveidea/audited) to log actions of models. That's why all we need it's creating view for model `Audited::Audit`

#### 1. Add Audited::Audit model to available models

*config/initializers/tramway.rb*
```ruby
Tramway::Admin.set_available_models(
  Audited::Audit,
  project: :your_project_name
)
```

#### 2. Add this model to navbar

```ruby
Tramway::Admin.set_navbar_structure(
  Audited::Audit,
  project: :your_project_name
)
```

#### 3. Generate decorator for Audited::Audit

```
rails g tramway:admin:model Audited::Audit
```

## Development

### Tests

```
make test
```

### Rubocop

```
make rubocop
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
