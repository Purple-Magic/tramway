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

#### tailwind_link_to

Tramway provides `tailwind_link_to` method, that uses `link_to`

```haml
= tailwind_link_to "/users/sign_in" do
  Sign In
```

OR

```haml
= tailwind_link_to 'Sign In', "/users/sign_in"
```

will render [this](https://play.tailwindcss.com/RT3Vvauu78)

```haml
= tailwind_link_to "/users/sign_out", method: :delete, confirm: 'Wanna quit?' do
  Sign Out
```

OR

```
= tailwind_link_to 'Sign Out', "/users/sign_out", method: :delete, confirm: 'Wanna quit?'
```

will render [this](https://play.tailwindcss.com/7qPmG4ltEU))

## Contributing

Install [lefthook](https://github.com/evilmartians/lefthook)

```
bundle
lefthook install
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
