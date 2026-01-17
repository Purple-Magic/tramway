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
    name: :text,
    about_me: {
      type: :text_area,
      rows: 5
    }
end
```

### Rule 10
Do not use `strong_parameters` in controllers. Use Tramway Form pattern for parameter whitelisting.

### Rule 11
Create tests for show models pages inside `spec/features/#{pluralized model_name}/show_spec.rb` using RSpec and Capybara if it needed.

Here is an example for `Task` model:

```ruby
describe 'Tasks Show Page', type: :feature do
  let!(:task) do
    create(:task)
  end

  it 'displays the task' do
    visit task_path(task)

    expect(page).to have_current_path(task_path(task))
    expect(page).to have_content(task.name)
    expect(page).to have_content('Pending')
  end
end
```

### Rule 12
Create tests for index models pages inside `spec/features/#{pluralized model_name}/index_spec.rb` using RSpec and Capybara if it needed.

Here is an example for `Project` model:

```ruby
describe 'Projects Index Page', type: :feature do
  let!(:projects) { create_list(:project, 3) }

  describe 'visiting the index page' do
    before do
      visit projects_path
    end

    it 'displays all projects' do
      expect(page).to have_current_path(projects_path)

      projects.each do |project|
        expect(page).to have_content(project.name)
      end
    end
  end
end
```

### Rule 13
Create tests for create models pages inside `spec/features/#{pluralized model_name}/create_spec.rb` using RSpec and Capybara if it needed.

Here is an example for `Project` model:

```ruby
describe 'Projects Create', type: :feature do
  let!(:project_attributes) do
    attributes_for(:project)
  end
  
  let(:project) { Project.last }

  it 'creates a new project' do
    visit new_project_path

    expect(page).to have_current_path(new_project_path)

    fill_in 'project[name]', with: project_attributes[:name]
    fill_in 'project[description]', with: project_attributes[:description]
    select project_attributes[:project_type], from: 'project[project_type]'

    click_on 'Save'

    expect(project).to have_attributes(
      name: project_attributes[:name],
      description: project_attributes[:description],
    )
  end
end
```

### Rule 14
Create tests for update models pages inside `spec/features/#{pluralized model_name}/update_spec.rb` using RSpec and Capybara if it needed.

Here is an example for `Project` model:

```ruby
describe 'Projects Update', type: :feature do
  let!(:project) do
    create('project', user: current_user)
  end

  let!(:project_attributes) do
    attributes_for(:project)
  end

  it 'updates the project' do
    visit edit_project_path(project)

    expect(page).to have_current_path(edit_project_path(project))

    fill_in 'project[name]', with: project_attributes[:name]
    fill_in 'project[description]', with: project_attributes[:description]

    click_on 'Save'

    expect(page).to have_content('Project was successfully updated.')
    expect(page).to have_content(project_attributes[:name])
    expect(page).to have_content(project_attributes[:description])

    project.reload

    expect(project).to have_attributes(
      name: project_attributes[:name],
      description: project_attributes[:description]
    )
  end
end
```

### Rule 15
Create tests for destroy models pages inside `spec/features/#{pluralized model_name}/destroy_spec.rb` using RSpec and Capybara if it needed.

Here is an example for `Project` model:

```ruby
describe 'Project Destroy', type: :feature do
  let!(:project) do
    create('project')
  end

  it 'destroys the project' do
    visit project_path(project)

    expect(page).to have_current_path(project_path(project))

    click_on 'Delete'

    expect(page).to have_content('Project was successfully destroyed.')

    expect { Project.find(project.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
```

### Rule 16
If you created any tests for Tramway Entities pages, make sure to add this to `spec/rails_helper.rb`.

*spec/rails_helper.rb*:
```ruby
RSpec.configure do |config|
  config.include Tramway::Helpers::RoutesHelper, type: :feature
end
```

### Rule 17
If application has authentication in the web then use `application_controller` config in `config/initializers/tramway.rb` to setup authentication method for Tramway Entities.

*config/initializers/tramway.rb*:
```ruby
Tramway.configure do |config|
  config.application_controller = 'ApplicationController'
end
```

### Rule 18
If you use `index` page for Tramway Entity, make sure to create `index_attributes` method in the entity decorator.

Example for `Participant` model:

*app/decorators/participant_decorator.rb*:
```ruby
class ParticipantDecorator < Tramway::BaseDecorator
  def self.index_attributes
    [
      :id,
      :name,
      :email,
      :created_at
    ]
  end
end
```

### Rule 19
In specs ALWAYS use factories (FactoryBot gem) to create models and attributes hash. In case there is no factory for the model, create one inside `spec/factories/#{pluralized model_name}.rb`.

### Rule 20
In case you need enumerize for model attribute, make sure to use `enumerize` gem for that. DO NOT use `boolean` or `integer` types for enumerations.

### Rule 21
In case you need something that looks like enumerize but it's a process state, use `aasm` gem for that.

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
