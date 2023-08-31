# Tramway
Unite Ruby on Rails brilliance. Streamline development with Tramway.

* [Installation](https://github.com/Purple-Magic/tramway#installation)
* [Usage](https://github.com/Purple-Magic/tramway#usage)
  * [Tramway Entities](https://github.com/Purple-Magic/tramway#tramway-entities)
  * [Tramway Decorators](https://github.com/Purple-Magic/tramway#tramway-decorators)
  * [Tramway Form](https://github.com/Purple-Magic/tramway#tramway-form)
  * [Tramway Navbar](https://github.com/Purple-Magic/tramway#tramway-navbar)

## Installation
Add this line to your application's Gemfile:

```ruby
gem "tramway"
gem "view_component"
```

## Usage

### Tramway Entities

Tramway is an entity-based framework. **Entity** is the class on whose objects actions be applied: _index, show, create, update, and destroy_. Tramway will support numerous classes as entities. For now, Entity could be only **ActiveRecord::Base** class.

#### Define entity for Tramway

*config/initializers/tramway.rb*
```ruby
Tramway.configure do |config|
  config.entities = [ :user, :podcast, :episode ] # entities based on models User, Podcast and Episode are defined
end
```

By default, links to the Tramway Entities index page are rendered in [Tramway Navbar](https://github.com/Purple-Magic/tramway#tramway-navbar).

#### Define entities with options

Tramway Entity supports several options that are used in different features.

**route**

*config/initializers/tramway.rb*
```ruby
Tramway.configure do |config|
  config.entities = [
    { name: :user, route: { namespace: :admin } },                                 # `admin_users_path` link in the Tramway Navbar
    { name: :podcast, route: { route_method: :shows } },                           # `shows_path` link in the Tramway Navbar
    { name: :episodes, route: { namespace: :podcasts, route_method: :episodes } }, # `podcasts_episodes_path` link in the Tramway Navbar
  ]
end
```

### Tramway Decorators

Tramway provides convenient decorators for your objects. **NOTE:** This is not the decorator pattern in its usual representation.

*app/controllers/users_controller.rb*
```ruby
def index
  # this line of code decorates the users collection with the default UserDecorator
  @users = tramway_decorate User.all 
end
```

*app/decorators/user_decorator.rb*
```ruby
class UserDecorator < Tramway::BaseDecorator
  # delegates attributes to decorated object
  delegate_attributes :email, :first_name, :last_name

  # you can provide your own methods with access to decorated object attributes with the method `object`
  def created_at
    I18n.l object.created_at
  end

  # you can provide representations with ViewComponent to avoid implementing views with Rails Helpers
  def posts_table
    render TableComponent.new(object.posts)
  end
end
```

#### Decorate single object

You can use the same method to decorate a single object either

```ruby
def show
  @user = tramway_decorate User.find params[:id]
end
```

#### Decorate with a specific decorator

You can implement a specific decorator and ask Tramway to decorate with it

```ruby
def show
  @user = tramway_decorate User.find(params[:id]), decorator: Users::ShowDecorator
end
```

### Tramway Form

Tramway provides **convenient** form objects for Rails applications. List properties you want to change and the rules in Form classes. No controllers overloading.

*app/forms/user_form.rb
```ruby
class UserForm < Tramway::BaseForm
  properties :email, :password, :first_name, :last_name, :phone

  def password=(value)
    object.password = value if value.present?
  end
end
```

**Controllers without Tramway Form**

*app/controllers/users_controller.rb*
```ruby
class UsersController < ApplicationController
  def create
    @user = User.new
    if @user.save user_params
      render :show
    else
      render :new
    end
  end

  def update
    @user = User.find params[:id]
    if @user.save user_params
      render :show
    else
      render :edit
    end
  end
  
  private

  def user_params
    params[:user].permit(:email, :password, :first_name, :last_name, :phone)
  end
end
```

**Controllers with Tramway Form**

*app/controllers/users_controller.rb*
```ruby
class UsersController < ApplicationController
  def create
    @user = tramway_form User.new
    if @user.submit params[:user]
      render :show
    else
      render :new
    end
  end

  def update
    @user = tramway_form User.find params[:id]
    if @user.submit params[:user]
      render :show
    else
      render :edit
    end
  end
end
```

#### Implement Form objects for any case

*app/forms/user_updating_email_form.rb
```ruby
class UserUpdatingEmailForm < Tramway::BaseForm
  properties :email
end
```

*app/controllers/updating_emails_controller.rb*
```ruby
def update
  @user = UserUpdatingEmailForm.new User.find params[:id]
  if @user.submit params[:user]
    # success
  else
    # failure
  end
end
```

#### Create form namespaces

*app/forms/admin/user_form.rb*
```ruby
class Admin::UserForm < Tramway::BaseForm
  properties :email, :password, :first_name, :last_name, :etc
end
```

*app/controllers/admin/users_controller.rb*
```ruby
class Admin::UsersController < Admin::ApplicationController
  def create
    @user = tramway_form User.new, namespace: :admin
    if @user.submit params[:user]
      render :show
    else
      render :new
    end
  end

  def update
    @user = tramway_form User.find(params[:id]), namespace: :admin
    if @user.submit params[:user]
      render :show
    else
      render :edit
    end
  end
end
```

### Tramway Navbar

Tramway provides DSL for rendering Tailwind Navgiation bar.

```ruby
tramway_navbar title: 'Purple Magic', background: { color: :red, intensity: 500 } do |nav|
  nav.left do
    nav.item 'Users', '/users'
    nav.item 'Podcasts', '/podcasts'
  end

  nav.right do
    nav.item 'Sign out', '/users/sessions', method: :delete, confirm: 'Wanna quit?'
  end
end
```

will render [this](https://play.tailwindcss.com/UZPTCudFw5)

#### tramway_navbar

This helper provides several options. Here is YAML view of `tramway_navbar` options structure

```yaml
title: String that will be added to the left side of the navbar
title_link: Link on Tramway Navbar title. Default: '/'
background:
  color: Css-color. Supports all named CSS colors and HEX colors
  intensity: Color intensity. Range: **100..950**. Used by Tailwind. Not supported in case of using HEX color in the background.color
```

**NOTE:** `tramway_navbar` method called without arguments and block of code will render only [Tramway Entities](https://github.com/Purple-Magic/tramway#tramway-entities) links on the left.

#### nav.left and nav.right

Tramway navbar provides `left` and `right` methods that puts items to left and right part of navbar.

#### nav.item

Item in navigation is rendered `li a` inside navbar `ul` tag on the left or right sides. `nav.item` uses the same approach as `link_to` method with syntax sugar.

```ruby
tramway_navbar title: 'Purple Magic' do |nav|
  nav.left do
    nav.item 'Users', '/users'

    # NOTE you can achieve the same with

    nav.item '/users' do
      'Users'
    end

    # NOTE nav.item supports turbo-method and turbo-confirm attributes

    nav.item 'Delete user', '/users/destroy', method: :delete, confirm: 'Are you sure?'
    
    # will render this
    # <li>
    #   <a data-turbo-method="delete" data-turbo-confirm="Are you sure?" href="/users/sign_out" class="text-white hover:bg-red-300 px-4 py-2 rounded">
    #     Sign out
    #   </a>
    # </li>
  end
end
```

### Tailwind components

Tramway uses [Tailwind](https://tailwindcss.com/) by default. All UI helpers are implemented with [ViewComponent](https://github.com/viewcomponent/view_component).

## Contributing

Install [lefthook](https://github.com/evilmartians/lefthook)

```
bundle
lefthook install
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
