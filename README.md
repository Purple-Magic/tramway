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

#### Button

##### tailwind_button_to

Tramway provides `tailwind_button_to` method, that uses `button_to` or `link_to`

```haml
= tailwind_button_to href: "/users/sign_in" do
  Sign In
```

OR

```haml
= tailwind_button_to 'Sign In', href: "/users/sign_in"
```

will render [this](https://play.tailwindcss.com/RT3Vvauu78)

```haml
= tailwind_button_to action: "/users/sign_out", method: :delete do
  Sign Out
```

OR

```
= tailwind_button_to 'Sign Out', action: "/users/sign_out", method: :delete
```

will render [this](https://play.tailwindcss.com/pJ8450tV21)

#### tailwind_link_to

Tramway provides `tailwind_link_to` that is the alias of `tailwind_button_to`

## Contributing

Install [lefthook](https://github.com/evilmartians/lefthook)

```
bundle
lefthook install
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
