# PaperTrail-Actor

*Originally forked from the now unmaintained [PaperTrailGlobalid](https://github.com/ankit1910/paper_trail-globalid).*

This gem is an extension for [PaperTrail](https://github.com/paper-trail-gem/paper_trail) that allows you to set an `ActiveRecord` object as the "whodunnit" field. This enhancement provides more granular tracking of who made changes, making it easier to trace modifications in your application.

## Features

- **Set an ActiveRecord Object for Whodunnit:** Use an `ActiveRecord` object to track who made changes.
- **Return the ActiveRecord Object:** The method `#actor` can be used to get the object responsible for changes.
- **Coexistence with Existing Versions:** Works seamlessly alongside existing PaperTrail versions, regardless of when they were created.

## How it works

This gem works by storing the [globalid](https://github.com/rails/globalid) to the whodunnit field of PaperTrail version tables. This allows you to add different object types to the whodunnit field, know exactly which object is responsible, and retrive that object with ease.

For example, if you have both `Admin` objects and `User` objects that are capable of making changes, this gem ensures that you can clearly identify who made the change instead of using purely an ID and not knowing if it was for an `Admin` or a `User`

## Installation

1. Add `paper_trail-actor` to your Gemfile:
  ```ruby
  gem "paper_trail-actor"
  ```
2. Run the following command:
  ```sh
  bundle install
  ```

## Usage

### Basic Setup

To use this gem, you first need to set a user (or any `ActiveRecord` object) to the `whodunnit` field.

```ruby
product = Product.find(42)
admin = Admin.find(1)

PaperTrail.request.whodunnit = admin
PaperTrail.request.whodunnit # "gid://app/Admin/1"
PaperTrail.request.actor # Returns the `Admin` object with id 1
```

When you update the product, PaperTrail will remember who made the change:

```ruby
product.update(name: "Ice cream")
product.versions.last.whodunnit # "gid://app/Admin/1"
product.versions.last.actor # Returns the `Admin` object with id 1
```

### Flexible Whodunnit

The gem is designed to be flexible. You can set `whodunnit` with various types of objects:

- **Strings:**
  ```ruby
  PaperTrail.request.whodunnit = "Alex the admin" # "Alex the admin"
  ```

- **New/unpersisted ActiveRecord Objects:**
  ```ruby
  PaperTrail.request.whodunnit = Admin.new # Sets the string representation of the admin
  ```

- **Non-ActiveRecord Objects:**
  ```ruby
  class Job
    def to_s
      "A job in the system"
    end
  end

  PaperTrail.request.whodunnit = Job.new  # "A job in the system"
  ```

When you update the product, PaperTrail will store the string for who made the change:

```ruby
product.update(name: "Ice cream")
product.versions.last.whodunnit # "A job in the system"
product.versions.last.actor # "A job in the system"
```

### Updating Existing Versions

If you have existing PaperTrail versions and need to update them, you can do so by:

```ruby
first_product_version = product.versions.first
admin_id = first_product_version.actor # For example, "1"
admin = Admin.find_by(id: admin_id)

if admin.present?
  first_product_version.whodunnit = admin
  first_product_version.save
end
```

### Setting whodunnit with a controller callback

You can set the user for PaperTrail in the same way that the [PaperTrail documentation states](https://github.com/paper-trail-gem/paper_trail#setting-whodunnit-with-a-controller-callback). However, setting this to an ActiveRecord object now records the globalid and allows the object to be retrived with `#actor`.

Here’s an example:

```ruby
class ApplicationController < ActionController::Base
  def user_for_paper_trail
    logged_in? ? current_user : "Public user"
  end
end
```

## Contributing

1. Please add tests for PRs that are created.
2. Run the tests `bundle exec rake spec` to ensure that they all pass.
3. Lint the code `bundle exec rake standard:fix` to ensure that convention is maintained.
