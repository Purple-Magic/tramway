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

Tramway provides `Tailwinds::Navbar::ButtonComponent`, that uses `button_to` or `link_to`

```haml
= render(Tailwinds::Navbar::ButtonComponent.new(href: "/users/sign_in")) do
  Sign In
```

will render [this](https://play.tailwindcss.com/RT3Vvauu78)

```haml
= render(Tailwinds::Navbar::ButtonComponent.new(action: "/users/sign_out", method: :delete)) do
  Sign Out
```

will render [this](https://play.tailwindcss.com/pJ8450tV21)

## Contributing

Install [lefthook](https://github.com/evilmartians/lefthook)

```
bundle
lefthook install
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
