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

Tramway use [Tailwind](https://tailwindcss.com/) by default. All UI helpers implemented with [ViewComponent](https://github.com/viewcomponent/view_component).

### Navbar

Tramway provides DSL for rendering Tailwind Navgiation bar.

```ruby
tramway_navbar title: 'Purple Magic' do |nav|
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
