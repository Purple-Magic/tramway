## What's changed basically?

*Here are changes in a named list*

*Example*
Now we have 2 more helpers
* `tailwind_button_to`
* `tailwind_link_to`

## What's changed for tramway drivers?

*Here is the description of how it was before and after*

*Example*

### Before

```haml
= render(Tailwinds::Navbar::ButtonComponent.new(href: "/users/sign_in")) do
  Sign In
```

### After

```haml
= tailwind_button_to 'Sign In', href: "/users/sign_in"
```

*You should make updates in the docs in a single commit if it's possible. Link it here*

Find more info [here](https://github.com/Purple-Magic/tramway/blob/tailwind_helpers/README.md#button)

