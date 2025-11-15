# PaperTrail-Actor

Track changes in your Rails application with precision. PaperTrail-Actor extends [PaperTrail](https://github.com/paper-trail-gem/paper_trail) to store full ActiveRecord objects (not just IDs) as the actor responsible for changes.

**Problem it solves:** When both `Admin` and `User` models can modify records, storing only an ID makes it impossible to know which model type made the change. PaperTrail-Actor stores GlobalIDs to uniquely identify actors across different model types.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Basic Setup](#basic-setup)
  - [Supported Object Types](#supported-object-types)
  - [Controller Integration](#controller-integration)
  - [Migrating Existing Data](#migrating-existing-data)
- [How It Works](#how-it-works)

## Features

- **Store any ActiveRecord object** as the actor who made changes
- **Retrieve the full object** with a simple `#actor` method
- **Backward compatible** with existing PaperTrail versions
- **Flexible** - works with strings, unpersisted records, and non-ActiveRecord objects

## Requirements

- Ruby 2.7+
- Rails 6.0+
- PaperTrail 11.0+

## Installation

1. Add to your Gemfile:
  ```ruby
  gem "paper_trail-actor"
  ```
2. Install the gem:
  ```sh
  bundle install
  ```

## Usage

### Basic Setup

Set any ActiveRecord object as the actor responsible for changes:

```ruby
admin = Admin.find(1)
PaperTrail.request.whodunnit = admin

# Now all changes will be attributed to this admin
# See Supported Object Types section below for detailed examples
```

### Supported Object Types

The gem handles various object types gracefully:

**Persisted ActiveRecord objects:**
```ruby
admin = Admin.find(1)
product = Product.find(42)

PaperTrail.request.whodunnit = admin
PaperTrail.request.whodunnit # => "gid://app/Admin/1"
PaperTrail.request.actor     # => #<Admin id: 1>

# Make changes - PaperTrail will track the actor
product.update(name: "Ice cream")
product.versions.last.whodunnit # => "gid://app/Admin/1"
product.versions.last.actor     # => #<Admin id: 1>
```

**Strings:**
```ruby
PaperTrail.request.whodunnit = "Alex the admin"
PaperTrail.request.whodunnit # => "Alex the admin"
PaperTrail.request.actor     # => "Alex the admin"
```

**New/unpersisted ActiveRecord objects:**
```ruby
PaperTrail.request.whodunnit = Admin.new(name: "New Admin")
# Cannot get a globalid for an unpersisted object. So we use the `#to_s` for the object.
PaperTrail.request.whodunnit # => "#<Admin:0x00007f8e8c0a0b80>"
PaperTrail.request.actor     # => "#<Admin:0x00007f8e8c0a0b80>"
```

**Non-ActiveRecord objects:**
```ruby
class BackgroundJob
  def to_s
    "BackgroundJob-#{object_id}"
  end
end

PaperTrail.request.whodunnit = BackgroundJob.new
PaperTrail.request.whodunnit # => "BackgroundJob-12345"
PaperTrail.request.actor     # => "BackgroundJob-12345"
```

### Controller Integration

Set the actor automatically in your controllers using PaperTrail's built-in callback:

```ruby
class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit
end
```

If your controller has a `#current_user` method, PaperTrail-Actor will automatically use it and attribute all changes within the request cycle to that user.

```ruby
# In your CRUD actions
def update
  # Nothing else required here to attribute the user as the actor.
  @product.update(product_params)
  @product.versions.last.actor # => #<User id: 42> (full User object)
end
```

**Before PaperTrail-Actor:**
```ruby
# whodunnit was just a string like "42"
version.whodunnit # => "42"
# You couldn't tell if this was User 42 or Admin 42
```

**After PaperTrail-Actor:**
```ruby
# whodunnit stores the full GlobalID
version.whodunnit # => "gid://app/User/42"
version.actor     # => #<User id: 42>
# Now you know exactly who to attribute the change to
```

Override `#user_for_paper_trail` to customize the actor selection logic:

```ruby
class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit

  private

  def user_for_paper_trail
    logged_in? ? current_admin : "Public user"
  end
end
```

### Migrating Existing Data

**When to migrate:** Install PaperTrail-Actor on an existing app with PaperTrail data.

**How to migrate:** Convert existing string IDs to GlobalIDs:

```ruby
# Find a version with a plain ID
version = product.versions.first
# => #<PaperTrail::Version id: 1, whodunnit: "123">

# Convert to GlobalID
admin = Admin.find_by(id: version.whodunnit)
if admin.present?
  version.update!(whodunnit: admin)
  version.whodunnit # => "gid://app/Admin/123"
  version.actor     # => #<Admin id: 123>
end
```

## How It Works

PaperTrail-Actor serializes ActiveRecord objects using [GlobalID](https://github.com/rails/globalid) and stores them in PaperTrail's `whodunnit` column. This enables:

- **Type-safe actor identification**: `gid://app/Admin/1` vs `gid://app/User/1`
- **Automatic deserialization**: Call `#actor` to get back the original ActiveRecord object
- **Graceful fallback**: Non-ActiveRecord objects are stored as strings

For example, if you have both `Admin` and `User` models that can make changes, this gem ensures you can clearly identify who made the change instead of using only an ID without knowing the model type.
