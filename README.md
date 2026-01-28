# Tramway
Unite Ruby on Rails brilliance. Streamline development with Tramway.

Tramway ships with full CRUD (index, show, create, update, destroy) out of the box, and it includes a great AGENTS.md guide
that helps you generate good, Tramway-native code with all the framework features.

[![RubyGems Version](https://img.shields.io/gem/v/tramway.svg)](https://rubygems.org/gems/tramway)
[![Tests](https://github.com/Purple-Magic/tramway/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/Purple-Magic/tramway/actions/workflows/test.yml)
[![Lint](https://github.com/Purple-Magic/tramway/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/Purple-Magic/tramway/actions/workflows/lint.yml)
[![RubyGems Downloads (total)](https://img.shields.io/gem/dt/tramway.svg)](https://rubygems.org/gems/tramway)

* [Installation](https://github.com/Purple-Magic/tramway#installation)
* [Getting Started](https://github.com/Purple-Magic/tramway?tab=readme-ov-file#getting-started)
* [Usage](https://github.com/Purple-Magic/tramway#usage)
  * [Tramway Entities](https://github.com/Purple-Magic/tramway#tramway-entities)
  * [Tramway Decorators](https://github.com/Purple-Magic/tramway#tramway-decorators)
  * [Tramway Form](https://github.com/Purple-Magic/tramway#tramway-form)
  * [Tramway Navbar](https://github.com/Purple-Magic/tramway#tramway-navbar)
  * [Tramway Flash](https://github.com/Purple-Magic/tramway#tramway-flash)
  * [Tramway Table Component](https://github.com/Purple-Magic/tramway#tramway-table-component)
  * [Tailwind-styled forms](https://github.com/Purple-Magic/tramway#tailwind-styled-forms)
    * [Stimulus-based inputs](https://github.com/Purple-Magic/tramway#stimulus-based-inputs)
  * [Tailwind-styled pagination](https://github.com/Purple-Magic/tramway?tab=readme-ov-file#tailwind-styled-pagination-for-kaminari)
* [Articles](https://github.com/Purple-Magic/tramway#usage)

## Compatibility

Tramway is actively verified against the following Ruby and Rails versions.

| Ruby \ Rails | 7.1* | 7.2 | 8.0 | 8.1 |
| ------------- | ---- | --- | --- | --- |
| 3.2           | ✅   | ✅  | ✅  | ✅  |
| 3.3           | ✅   | ✅  | ✅  | ✅  |
| 3.4           | ✅   | ✅  | ✅  | ✅  |
| 4.0           | ✅   | ✅  | ✅  | ✅  |

\* Rails 7.1 receives only residual support because it no longer receives updates from the Rails core team. See the [announcement](https://rubyonrails.org/2025/10/29/new-rails-releases-and-end-of-support-announcement) for details.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "tramway"
```

Then install Tramway and its dependencies:

```shell
bundle install
bin/rails g tramway:install
```

The install generator adds the required gems (`haml-rails`, `kaminari`, `view_component`, and `dry-initializer`) to your
application's Gemfile—if they are not present—and appends the Tailwind safelist configuration Tramway ships with.

## Getting Started

**Step 1**

*config/initializers/tramway.rb*
```ruby
Tramway.configure do |config|
  config.entities = [
    {
      name: :user,
      pages: [
        { action: :index },
        { action: :show },
        { action: :create },
        { action: :update },
        { action: :destroy }
      ],
    }
  ]
end
```

**Step 2**

*config/routes.rb*

```ruby
Rails.application.routes.draw do
  mount Tramway::Engine, at: '/'
end
```

**Step 3**

```ruby
class UserDecorator < Tramway::BaseDecorator
  delegate_attributes :email, :created_at

  def self.index_attributes
    [:id, :email, :created_at]
  end
end
```

**Step 4**

If you ran `bin/rails g tramway:install`, the Tailwind safelist was already appended to `config/tailwind.config.js`.
Otherwise, copy this [file](https://github.com/Purple-Magic/tramway/blob/main/config/tailwind.config.js) to
`config/tailwind.config.js`.


**Step 5**

Run tailwincss-rails compiler


```bash
bin/rails tailwindcss:build
```

**Step 6**

Run your server

```bash
bundle exec rails s
```

**Step 7**

Open [http://localhost:3000/users](http://localhost:3000/users)

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
    {
      name: :user,
      namespace: :admin
    }, # `/admin/users` link in the Tramway Navbar
    {
      name: :episodes,
      route: {
        route_method: :episodes
      }
    }, # `/podcasts/episodes` link in the Tramway Navbar
  ]
end
```

**scope**

By default, Tramway lists all records for an entity on the index page. You can narrow the records displayed by providing a
`scope`. When set, Tramway will call the named scope on the entity before rendering the index view.

*config/initializers/tramway.rb*
```ruby
Tramway.configure do |config|
  config.entities = [
    {
      name: :campaign,
      namespace: :admin,
      pages: [
        {
          action: :index,
          scope: :active
        }
      ]
    }
  ]
end
```

In this example, the `Campaign` entity will display only records returned by the `active` scope on its index page, while all
other pages continue to show every record unless another scope is specified.

**show page**

To render a show page for an entity, declare a `:show` action inside the `pages` array in
`config/initializers/tramway.rb`. Tramway will generate the route and render a table using the attributes returned by the
decorator's 'show_attributes` method.

```ruby
Tramway.configure do |config|
  config.entities = [
    {
      name: :campaign,
      pages: [
        { action: :index },
        { action: :show }
      ]
    }
  ]
end
```

```ruby
class CampaignDecorator < Tramway::BaseDecorator
  def show_attributes
    %i[name status starts_at]
  end
end
```

With this configuration in place, visiting the show page displays a two-column table where the left column contains the
localized attribute names and the right column renders their values.

**create page**

To render a create page for an entity, declare a `:create` action inside the `pages` array in
`config/initializers/tramway.rb`. Tramway will generate the route and render the form fields based on your form object.
See the [form_fields method](#form_fields-method) for details on configuring fields.

```ruby
Tramway.configure do |config|
  config.entities = [
    {
      name: :campaign,
      pages: [
        { action: :index },
        { action: :create }
      ]
    }
  ]
end
```

**update page**

To render an update page, declare an `:update` action inside the `pages` array in `config/initializers/tramway.rb`.
Tramway will generate the edit route and reuse the same form partial as create. See the
[form_fields method](#form_fields-method) for details on configuring fields.

```ruby
Tramway.configure do |config|
  config.entities = [
    {
      name: :campaign,
      pages: [
        { action: :index },
        { action: :update }
      ]
    }
  ]
end
```

**fields method**

Use `form_fields` in your form class to customize which form helpers get rendered and which options are passed to them.
Each field must map to a form helper method name. When you need to pass options, use a hash where `:type` is the helper
method name and the remaining keys are passed as named arguments.

```ruby
class UserForm < Tramway::BaseForm
  properties :email, :about_me, :user_type

  fields email: :email,
    name: :text,
    about_me: {
      type: :text_area,
      rows: 5
    },
    user_type: {
      type: :select,
      collection: ['regular', 'user']
    }
end
```

The configuration above renders:

```erb
<%= tramway_form_for .... do |f| %>
  <%= f.email_field :email %>
  <%= f.text_field :name %>
  <%= f.text_area :about_me, rows: 5 %>
```

**destroy page**

To render a destroy action, declare a `:destroy` action inside the `pages` array in `config/initializers/tramway.rb`.
Tramway will generate the destroy route and render the delete action button.

```ruby
Tramway.configure do |config|
  config.entities = [
    {
      name: :campaign,
      pages: [
        { action: :index },
        { action: :destroy }
      ]
    }
  ]
end
```

**route_helper**

To get routes Tramway generated just Tramway::Engine.

```ruby
Tramway::Engine.routes.url_helpers.users_path => '/admin/users'
Tramway::Engine.routes.url_helpers.podcasts_episodes_path => '/podcasts/episodes'
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

  association :posts

  # you can provide your own methods with access to decorated object attributes with the method `object`
  def created_at
    I18n.l object.created_at
  end

  # you can provide representations with ViewComponent to avoid implementing views with Rails Helpers
  def posts_table
    component 'table', object.posts
  end
end
```

#### Add header content to index pages

You can inject custom content above an entity's index table by defining an
`index_header_content` lambda on its decorator. The lambda receives the
collection of decorated records and can render any component you need.

*config/initializers/tramway.rb*
```ruby
Tramway.configure do |config|
  config.entities = [
    {
      name: :project,
      pages: [
        { action: :index }
      ]
    }
  ]
end
```

*app/decorators/project_decorator.rb*
```ruby
class ProjectDecorator < Tramway::BaseDecorator
  class << self
    def index_header_content
      lambda do |_collection|
        component "projects/index_header"
      end
    end
  end
end
```

*app/components/projects/index_header_component.html.haml*
```haml
.mb-2
  = tramway_button path: Rails.application.routes.url_helpers.new_project_path,
    text: 'Create',
    type: :hope
```

*app/components/projects/index_header_component.rb*
```ruby
class Projects::IndexHeaderComponent < Tramway::BaseComponent
end
```

With this configuration in place, the index page will render the `Create`
button component above the table of projects.

#### Add header content to show pages

To inject custom content above a record's details, define an
object-level `show_header_content` method on its decorator. The method
can return any rendered content and has full access to the decorated
object's helpers and attributes.

#### Use `view_context` in show and index pages

Some helpers—such as `button_to` with non-`GET` methods—need access to the
live request context to include CSRF tokens. Pass the Rails `view_context`
into your decorated objects so their render calls execute inside the
current request.

```ruby
def show
  @project = tramway_decorate(Project.find(params[:id])).with(view_context:)
end
```

For index pages, decorate each record with the current context before
rendering headers or per-row components:

```ruby
def index
  @projects = tramway_decorate(Project.all).map { |project| project.with(view_context:) }
end
```

Passing the context this way ensures `show_header_content` and
`index_header_content` blocks can safely call helpers that require the
session-bound authenticity token.

#### Decorate a single object

You can use the same method to decorate a single object either

```ruby
def show
  @user = tramway_decorate User.find params[:id]
end
```

All objects returned from `tramway_decorate` respond to
`with(view_context:)`, so you can attach the current Rails `view_context`
when you need decorator-rendered content to use helpers that rely on the
active request (such as CSRF tokens).

#### Decorate a collection of objects

```ruby
def index
  @users = tramway_decorate User.all
end
```

```ruby
def index
  @posts = tramway_decorate user.posts
end
```

#### Decorate with a specific decorator

You can implement a specific decorator and ask Tramway to decorate with it

```ruby
def show
  @user = tramway_decorate User.find(params[:id]), decorator: Users::ShowDecorator
end
```

#### Decorate associations

**Decorate single association**

```ruby
class UserDecorator < Tramway::BaseDecorator
  association :posts
end

user = tramway_decorate User.first
user.posts # => decorated collection of posts with PostDecorator
```

**Decorate multiple associations**

```ruby
class UserDecorator < Tramway::BaseDecorator
  associations :posts, :users
end
```

#### Decorate nil

Tramway Decorator does not decorate nil objects

```ruby
user = nil
UserDecorator.decorate user # => nil
```

#### Update and Destroy

Read [behave_as_ar](https://github.com/Purple-Magic/tramway#behave_as_ar) section

### Tramway Form

Tramway provides **convenient** form objects for Rails applications. List properties you want to change and the rules in Form classes. No controllers overloading.

*app/forms/user_form.rb
```ruby
class UserForm < Tramway::BaseForm
  properties :email, :password, :first_name, :last_name, :phone

  normalizes :email, with: ->(value) { value.strip.downcase }
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

We also provide `submit!` as `save!` method that returns an exception in case of failed saving.

#### Implement Form objects for any case

*app/forms/user_updating_email_form.rb*
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

### Normalizes

Tramway Form supports `normalizes` method. It's almost the same [as in Rails](https://edgeapi.rubyonrails.org/classes/ActiveRecord/Normalization.html)

```ruby
class UserForm < Tramway::BaseForme
  properties :email, :first_name, :last_name
  
  normalizes :email, with: ->(value) { value.strip.downcase }
  normalizes :first_name, :last_name, with: ->(value) { value.strip }
end
```

`normalizes` method arguments:
* `*properties` - collection of properties that will be normalized
* `with:` - a proc with a normalization
* `apply_on_nil` - by default is `false`. When `true` Tramway Form applies normalization on `nil` values

### Form inheritance

Tramway Form supports inheritance of `properties`, `normalizations`, and `fields`.

**Example**

```ruby
class UserForm < TramwayForm
  properties :email, :password

  normalizes :email, with: ->(value) { value.strip.downcase }

  fields email: :email,
    password: :password
end

class AdminForm < UserForm
  properties :permissions
end

AdminForm.properties # returns [:email, :password, :permissions]
AdminForm.normalizations # contains the normalization of :email
AdminForm.fields # { email: :email, password: :password }
```

### Make flexible and extendable forms

Tramway Form properties are not mapped to a model. You're able to make extended forms.

*app/forms/user_form.rb*
```ruby
class UserForm < Tramway::BaseForm
  properties :email, :full_name

  # EXTENDED FIELD: full name
  def full_name=(value)
    object.first_name = value.split(' ').first
    object.last_name = value.split(' ').last
  end
end
```

### Assign values

Tramway Form provides `assign` method that allows to assign values without saving

```ruby
class UsersController < ApplicationController
  def update
    @user = tramway_form User.new
    @user.assign params[:user] # assigns values to the form object
    @user.reload # restores previous values
  end
end
```

### Update and Destroy

Read [behave_as_ar](https://github.com/Purple-Magic/tramway#behave_as_ar) section

### Tramway Navbar

#### Running tramway_navbar without arguments

When you call `tramway_navbar` without passing any arguments, it renders a navbar that lists buttons linking to all entities configured with a page index in `config/initializers/tramway.rb`.

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

# ERB example

```erb
<%= tramway_navbar title: 'Purple Magic', background: { color: :red, intensity: 500 } do |nav| %>
  <% nav.left do %>
    <%= nav.item 'Users', '/users' %>
    <%= nav.item 'Podcasts', '/podcasts' %>
  <% end %>

  <% nav.right do %>
    <%= nav.item 'Sign out', '/users/sessions', method: :delete, confirm: 'Wanna quit?' %>
  <% end %>
<% end %>
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
with_entities: Show Tramway Entities index page links to navbar. Default: true
```

**NOTE:** `tramway_navbar` method called without arguments and block of code will render only [Tramway Entities](https://github.com/Purple-Magic/tramway#tramway-entities) links on the left.

In case you want to hide entity links you can pass `with_entities: false`.

```erb
<% if current_user.present? %>
  <%= tramway_navbar title: 'WaiWai' do |nav| %>
    <% nav.left do %>
      <%= nav.item 'Board', admin_board_path %>
    <% end %>
  <% end %>
<% else %>
  <%= tramway_navbar title: 'WaiWai', with_entities: false %>
<% end %>
```

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

### Tramway Flash

`tramway_flash` renders the Tailwind-styled flash component that Tramway uses in its layouts. Pass the flash text and type, and
the helper will resolve the proper Tailwind color (for example `:success` -> green, `:warning` -> orange). You can also provide
custom HTML options directly (e.g., `class:`, `data:`) and they will be merged into the flash container.

```haml
-# Haml example
= tramway_flash text: flash[:notice], type: :hope
= tramway_flash text: 'Double check your data', type: :greed, class: 'mt-2', data: { turbo: 'false' }
```

```erb
<%# ERB example %>
<%= tramway_flash text: flash[:alert], type: :rage %>
<%= tramway_flash text: 'Saved!', type: :will, data: { controller: 'dismissible' } %>
```

Use the `type` argument is compatible to [Lantern Color Palette](https://github.com/TrinityMonsters/tramway/blob/main/README.md#lantern-color-palette) or provide a `color:` keyword to set
the Tailwind color family explicitly.

### Tramway Table Component

Tramway provides a responsive, tailwind-styled table with light and dark themes. Use the `tramway_table`, `tramway_row`, and
`tramway_cell` helpers to build tables with readable ERB templates while still leveraging the underlying ViewComponent
implementations.

```erb
<%= tramway_table do %>
  <%= tramway_header headers: ['Column 1', 'Column 2'] %>

  <%= tramway_row do %>
    <%= tramway_cell do %>
      Something
    <% end %>
    <%= tramway_cell do %>
      Another
    <% end %>
  <% end %>
<% end %>
```

`tramway_table` accepts the same optional `options` hash as `Tailwinds::TableComponent`. The hash is forwarded as HTML
attributes, so you can pass things like `id`, `data` attributes, or additional classes. If you do not supply your own width
utility (e.g. a class that starts with `w-`), the component automatically appends `w-full` to keep the table responsive. This
allows you to extend the default styling without losing the sensible defaults provided by the component.

Use the optional `href:` argument on `tramway_row` to turn an entire row into a link. Linked rows gain pointer and hover styles
(`cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700`) to indicate interactivity.

```erb
<%= tramway_table class: 'max-w-3xl border border-gray-200', data: { controller: 'table' } do %>
  <%= tramway_header', headers: ['Name', 'Email'] %>

  <%= tramway_row href: user_path(user) do %>
    <%= tramway_cell do %>
      <%= user.name %>
    <% end %>
    <%= tramway_cell do %>
      <%= user.email %>
    <% end %>
  <% end %>
<% end %>
```

When you render a header you can either pass the `headers:` array, as in the examples above, or render custom header content in
the block. `Tailwinds::Table::HeaderComponent` uses the length of the `headers` array to build the grid if the array is present.
If you omit the array and provide custom content, pass the `columns:` argument so the component knows how many grid columns to
generate.

```erb
<%= component 'tailwinds/table/header', columns: 4 do %>
  <%= tramway_cell do %>
    Custom header cell
  <% end %>
  <%= tramway_cell do %>
    Another header cell
  <% end %>
  <!-- ... -->
<% end %>
```

With this approach you control the header layout while still benefiting from the default Tailwind grid classes that the header
component applies.

### Tramway Buttons and Containers

Tramway ships with helpers for common UI patterns built on top of Tailwind components.

`tramway_button` helper is designed for developers who don't want to think about what type of button must be used now. It can render 3 types of buttons: `a` (links), `button`, `form` with button.

You can set a type to render explicitly:

```ruby
tramway_button tag: :a, text: 'Link' #=> <a class=BUTTON_CLASSES>Link</a>
tramway_button tag: :button, text: 'Link' #=> <button class=BUTTON_CLASSES>Link</button>
tramway_button tag: :form, text: 'Link' #=> <form><button class=BUTTON_CLASSES>Link</button></form>
```

OR `tramway_button` choose the most appropriate button type by the arguments received.

#### `tramway_button` options

**path**

Example 1: rendering link
```erb
<%= tramway_button path: '/projects', text: 'Projects' %>

#=> <a href='/projects' class="...">Projects</a>
```

Example 2: rendering form
```erb
<%= tramway_button path: '/projects/1', text: 'Destroy', method: :delete %>

#> <form action="/projects/1"  method="post">
#>   ....
#>   <button class: "..." type="submit">
#>     Delete
#>   </button>
```

Example 3: rendering button
```
<%= tramway_button path: '/projects/1', text: 'Edit', tag: :button %>

#> <button onclick="window.location.href='/projects/1' class="...">Edit</button>
```

  All additional keyword arguments are forwarded to the underlying component as HTML attributes.

  You can also pass HTML attributes for the generated `<form>` separately via `form_options:` while keeping button-specific
  attributes in `options:`:

  ```erb
  <%= tramway_button path: user_path(user), text: 'Create',
    form_options: { data: { turbo: false } },
    options: { data: { controller: 'submit-once' } } %>
  ```

  The `type` option maps semantic intent to [Lantern Color Palette](https://github.com/TrinityMonsters/tramway/blob/main/README.md#lantern-color-palette).

* `tramway_badge` renders a Tailwind-styled badge with the provided `text`. Pass a semantic `type` (for example, `:success` or
  `:danger`) to use the built-in color mappings, or supply a custom Tailwind color family with `color:`. When you opt into a
  custom color, ensure the corresponding background utilities are available in your Tailwind safelist.

  ```erb
  <%= tramway_badge text: 'Active', type: :success %>
  ```

* `tramway_back_button` renders a standardized "Back" link.

  ```erb
  <%= tramway_back_button %>
  ```

* `tramway_container` wraps content in a responsive, narrow layout container. Pass an `id` if you need to target the container
  with JavaScript or CSS.

  ```erb
  <%= tramway_container id: 'user-settings' do %>
    <h2 class="text-xl font-semibold">Settings</h2>
    <p class="mt-2 text-gray-600">Update your preferences below.</p>
  <% end %>
  ```

### Tailwind-styled forms

Tramway uses [Tailwind](https://tailwindcss.com/) by default. All UI helpers are implemented with [ViewComponent](https://github.com/viewcomponent/view_component).

#### tramway_form_for

Tramway provides `tramway_form_for` helper that renders Tailwind-styled forms by default.

```erb
<%= tramway_form_for @user do |f| %>
  <%= f.text_field :text %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.select :role, [:admin, :user] %>
  <%= f.date_field :birth_date %>
  <%= f.datetime_field :confirmed_at %>
  <%= f.multiselect :permissions, [['Create User', 'create_user'], ['Update user', 'update_user']] %>
  <%= f.file_field :file %>
  <%= f.submit 'Create User' %>
<% end %>
```

will render [this](https://play.tailwindcss.com/xho3LfjKkK)

Use `size:` to control the form sizing (`:small`, `:medium`, or `:large`). The default is `:medium`, and all fields rendered
within the form will use the same size value.

```erb
<%= tramway_form_for @user, size: :large do |f| %>
  <%= f.text_field :text %>
  <%= f.submit 'Create User' %>
<% end %>
```

Available form helpers:
* text_field
* email_field
* password_field
* file_field
* select
* date_field
* datetime_field
* multiselect ([Stimulus-based](https://github.com/Purple-Magic/tramway#stimulus-based-inputs))
* submit

**Examples**

1. Sign In Form for `devise` authentication

*app/views/devise/sessions/new.html.erb*
```erb
<%= tramway_form_for(resource, as: resource_name, url: session_path(resource_name), html: { class: 'bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4') } do |f| %>
  <%= component 'forms/errors', record: resource %>

  <%= f.text_field :email, placeholder: 'Your email' %>
  <%= f.password_field :password, placeholder: 'Your password' %>

  <%= f.submit 'Sign In' %>
<% end %>
```

2. Sign In Form for Rails authorization

*app/views/sessions/new.html.erb*
```erb
<%= form_with url: login_path, scope: :session, local: true, builder: Tailwinds::Form::Builder do |form| %>
  <%= form.email_field :email %>
  <%= form.password_field :password %>
  <%= form.submit 'Log in' %>
<% end %>
```

#### Stimulus-based inputs

`tramway_form_for` provides Tailwind-styled Stimulus-based custom inputs.

##### Multiselect

In case you want to use tailwind-styled multiselect this way

```erb
<%= tramway_form_for @user do |f| %>
  <%= f.multiselect :permissions, [['Create User', 'create_user'], ['Update user', 'update_user']] %>
  <%# ... %>
<% end %>
```

you should add Tramway Multiselect Stimulus controller to your application.

Example for [importmap-rails](https://github.com/rails/importmap-rails) config

*config/importmap.rb*
```ruby
pin '@tramway/multiselect', to: 'tramway/multiselect_controller.js'
```

*app/javascript/controllers/index.js*
```js
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { Multiselect } from "@tramway/multiselect" // importing Multiselect controller class
eagerLoadControllersFrom("controllers", application)

application.register('multiselect', Multiselect) // register Multiselect controller class as `multiselect` stimulus controller
```

In case you need to use Stimulus `change` action with Tramway Multiselect

```erb
<%= tramway_form_for @user do |f| %>
  <%= f.multiselect :role, data: { action: 'change->user-form#updateForm' } %>
<% end %>
```

### Tailwind-styled pagination for Kaminari

Tramway uses [Tailwind](https://tailwindcss.com/) by default. It has tailwind-styled pagination for [kaminari](https://github.com/kaminari/kaminari).

#### How to use

*Gemfile*
```ruby
gem 'tramway'
gem 'kaminari'
```

*config/initializers/tramway.rb*
```ruby
Tramway.configure do |config|
  config.pagination = { enabled: true } # enabled is false by default
end
```

*app/views/users/index.html.erb*
```erb
<%= paginate @users %> <%# it will render tailwind-styled pagination buttons by default %>
```

Pagination buttons looks like [this](https://play.tailwindcss.com/mqgDS5l9oY)

### `behave_as_ar`

**Tramway Decorator** and **Tramway Form** support `behave_as_ar` method. It allows to use `update` and `destroy` methods with decorated and form objects.

### `object` method

**Tramway Decorator** and **Tramway Form** have public `object` method. It allows to access ActiveRecord object itself.

```ruby
user_1 = tramway_decorate User.first
user_1.object #=> returns pure user object

user_2 = tramway_form User.first
user_2.object #=> returns pure user object
```

## Configuration

### Custom layout

In case you wanna use a custom layout:

1. Create a controller
2. Set the layout there
3. Set this controller as `application_controller` in Tramway initializer
4. Reload your server

**Example**

*app/controllers/admin/application_controller.rb*
```ruby
class Admin::ApplicationController < ApplicationController
  layout 'admin/application'
end
```

*config/initializers/tramway.rb*
```ruby
Tramway.configure do |config|
  config.application_controller = 'Admin::ApplicationController'
end
```

## Lantern Color Palette

  | Type | Color |
  | ---- | ----- |
  | `default`, `life` | Gray |
  | `primary`, `hope` | Blue |
  | `secondary` | Zinc |
  | `success`, `will` | Green |
  | `warning`, `greed` | Orange |
  | `danger`, `rage` | Red |
  | `love` | Violet |
  | `compassion` | Indigo |
  | `fear` | Yellow |

## Articles
* [Tramway on Rails](https://kalashnikovisme.medium.com/tramway-on-rails-32158c35ed68)
* [Tramway is the way to deal with little things for Rails developers](https://medium.com/@kalashnikovisme/tramway-is-the-way-to-deal-with-little-things-for-rails-developers-4f502172a18c)
* [Delegating ActiveRecord methods to decorators in Rails](https://kalashnikovisme.medium.com/delegating-activerecord-methods-to-decorators-in-rails-4e4ec1c6b3a6)
* [Behave as ActiveRecord. Why do we want objects to be AR lookalikes?](https://kalashnikovisme.medium.com/behave-as-activerecord-why-do-we-want-objects-to-be-ar-lookalikes-d494d692e1d3)
* [Decorating associations in Rails with Tramway](https://kalashnikovisme.medium.com/decorating-associations-in-rails-with-tramway-b46a28392f9e)
* [Easy-to-use Tailwind-styled multi-select built with Stimulus](https://medium.com/@kalashnikovisme/easy-to-use-tailwind-styled-multi-select-built-with-stimulus-b3daa9e307aa)
* [Lantern Color Palette](https://kalashnikovisme.medium.com/lantern-buttons-in-rails-ff61688fd8e3?postPublishedType=repub)

## Contributing

Install [lefthook](https://github.com/evilmartians/lefthook)

```
make install
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
