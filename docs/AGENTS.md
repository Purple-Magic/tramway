## Start of Tramway AGENTS.md

# AGENTS.md: Tramway Code Generation Standards

This document guides AI-assisted code generation for Rails applications built with **Tramway**. It is designed for founders, designers, PMs, and engineers who rely on AI tools (ChatGPT/Copilot/etc.) to build maintainable Rails code that fits Tramway’s conventions without a senior engineer reworking everything.

**Core Principle:** Generated code should feel like curated documentation—simple, explicit, and aligned with Tramway’s defaults. Prefer composable ViewComponents, Tailwind-friendly markup, and Rails-native patterns over bespoke architectures.

---

## Project Overview

Tramway extends Rails with:
- **CRUD** actions that can be configured in `config/initializers/tramway.rb`.
- **Generators** that wire Tailwind, ViewComponent, and pagination defaults (`bin/rails g tramway:install`).
- **ViewComponents** for reusable UI pieces.
- **Tailwind safelist** utilities to keep dynamic classes in the build.

Generated code should:
- Lean on Rails conventions and Tramway generators instead of hand-rolled setup.
- Use domain language (e.g., `Participant`, `Dashboard`) over generic terms.
- Keep logic in the right layer: models for data/validations, controllers for HTTP, components for repeatable UI, views for simple rendering.
- Be readable without comments; short methods, guard clauses, and clear naming.

---

## Quick Start Workflow (Preferred)

1) **Install Tramway defaults**

```bash
bin/rails g tramway:install
```

- The install generator appends missing gems, copies Tailwind safelist config, ensures `app/assets/tailwind/application.css` imports Tailwind, and writes an `AGENTS.md` guide in the project root.

---

## Technology Stack & Gems

Tramway expects and installs:
- `rails` (7+), `kaminari`, `view_component`, `haml-rails`, `dry-initializer`, `tailwindcss-rails`.
- Prefer Haml for views unless a component template uses ERB.
- Keep JavaScript minimal; use Stimulus if needed, avoid SPAs.

Do **not** introduce alternative architectures (contexts/operation gems) unless explicitly requested.

---

## File Structure & Organization

Follow Rails defaults. When extracting logic, namespace under the owning model or component:

```
app/
  components/               # ViewComponent classes and templates
    participants/
      card_component.rb
      card_component.html.erb
  controllers/
    participants_controller.rb
  decorators/               # Tramway Decorator pattern
    participant_decorator.rb
  forms/                    # Tramway Form pattern
    participant_form.rb
  models/
    participant.rb
  views/
    participants/
      show.html.haml
config/
  initializers/
      tramway.rb              # Tramway configuration
  tailwind.config.js        # Safelist managed by tramway:install
```

---

## Rules

### Rule 1
If CRUD is requested or some default actions like (index, show, create, update, destroy) are requestsed, use Tramway Entities by default unless custom behavior is needed. Configure in `config/initializers/tramway.rb`. Do not create controllers, views, or routes manually for CRUD actions if Tramway Entities can handle it.

When `namespace` is mentioned in the request, configure it in the entity definition.

Example of CRUD configuration for model `Participant`:

*config/initializers/tramway.rb*:
```ruby
Tramway.configure do |config|
  config.entities = [
    {
      name: :participant,
      pages: [
        { action: :index },
        { action: :show },
        { action: :create },
        { action: :update },
        { action: :destroy }
      ]
    }
  ]
end
```

### Rule 2
Normalize input with `normalizes` (from Tramway) for attributes like email, phone, etc. Don't use `normalizes` in model unless it requested explicitly.

### Rule 3
Use Tramway Navbar for navigation

### Rule 4
Use Tramway Flash for user notifications.

### Rule 5
Use Tramway Table for tabular data display.

### Rule 6
Use Tramway Button for buttons.

### Rule 7
Use `tramway_form_for` instead `form_with`, `form_for`

### Rule 8
Inherit all components from Tramway::BaseComponent

### Rule 9
If page `create` or `update` is configured for an entity, use Tramway Form pattern for forms. Visible fields are configured via `form_fields` method.

Use form_fields in your form class to customize which form helpers get rendered and which options are passed to them. Each field must map to a form helper method name. When you need to pass options, use a hash where :type is the helper method name and the remaining keys are passed as named arguments.

Example:

*app/forms/user_form.rb*:
```ruby
class UserForm < Tramway::BaseForm
  properties :email, :about_me

  fields email: :email,
    about_me: {
      type: :text_area,
      rows: 5
    }
end
```

### Rule 10
Do not use `strong_parameters` in controllers. Use Tramway Form pattern for parameter whitelisting.

## Controller Patterns

- Keep actions short and explicit with guard clauses.
- Delegate heavy lifting to models, jobs, or components.
- Render components for complex UI rather than partials with logic.

Example:
```ruby
class ParticipantsController < ApplicationController
  def index
    @participants = tramway_decorate Participant.all.page(params[:page])
  end

  def new
    @participant_form = tramway_form Participant.new
  end

  def create
    @participant_form = tramway_form Participant.new

    if @participant_form.submit params[:participant]
      redirect_to participants_path, notice: 'Participant created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @participant = tramway_decorate Participant.find(params[:id])
  end

  def edit
    @participant_form = tramway_form Participant.find(params[:id])
  end

  def update
    @participant_form = tramway_form Participant.find(params[:id])

    if @participant_form.submit params[:participant]
      redirect_to participant_path(@participant_form), notice: 'Participant updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    participant = Participant.find(params[:id])
    participant.destroy

    redirect_to participants_path, notice: 'Participant deleted successfully.'
  end
end
```

---

## Tailwind Practices

- Keep `config/tailwind.config.js` managed by the generator. If you add dynamic classes, update the `safelist` via the generator template rather than rewriting the config.
- Add imports to `app/assets/tailwind/application.css`; avoid inline `<style>` blocks.

---

## Configuration

- Use `anyway_config` (installed by Tramway) for configuration, not direct `ENV` reads.

---

## Checklist (Before Shipping)

- [ ] Used Tramway generators instead of manual setup where available.
- [ ] Controller actions are concise with guard clauses.
- [ ] Reusable UI is a ViewComponent using Tailwind utilities and accessible semantics.
- [ ] Tailwind safelist covers dynamic classes.

## End of Tramway AGENTS.md
