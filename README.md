# Tramway
Unite Ruby on Rails brilliance. Streamline development with Tramway.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "tramway"
gem "view_component"
```

## Usage

### Tailwind components

Tramway uses [Tailwind](https://tailwindcss.com/) by default. All UI helpers are implemented with [ViewComponent](https://github.com/viewcomponent/view_component).

### Decorators

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


### Navbar

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

## Contributing

Install [lefthook](https://github.com/evilmartians/lefthook)

```
bundle
lefthook install
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
