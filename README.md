# PaperTrail-Actor

Originally forked from the now unmaintained [paper_trail-globalid](https://github.com/ankit1910/paper_trail-globalid).

This gem is an extension to the [PaperTrail](https://github.com/paper-trail-gem/paper_trail) gem.

- Allows setting an `ActiveRecord` object for the whodunnit field on the PaperTrail request object and version objects.
- Adds the method `#actor` to the PaperTrail request object which returns the `ActiveRecord` object that will be responsible for subsequent changes.
- Adds the method `#actor` to PaperTrail version objects which returns the `ActiveRecord` object that was responsible for change.

## Installation

1. Add PaperTrail-Actor to your `Gemfile`.
  ```ruby
  gem "paper_trail-actor"
  ```
2. And then execute:
  ```sh
  bundle install
  ```

## Basic Usage

This gem works by storing the [globalid](https://github.com/rails/globalid) to the whodunnit field of PaperTrail version tables.
- It is designed not to hinder or break existing PaperTrail functionalities.
- PaperTrail versions with and without a globalid can live side by side (e.g. versions created before installing this gem.)

```ruby
product = Product.find(42)
admin = Admin.find(1)                                       # <Admin:0x007fa2df9a5590>

PaperTrail.request.whodunnit = admin
PaperTrail.request.whodunnit                                # "gid://app/Admin/1"
PaperTrail.request.actor                                    # <Admin:0x007fa2df9a5590> returns the actual object

product.update(name: "Ice cream")
product.versions.last.whodunnit                             # "gid://app/Admin/1"
product.versions.last.actor                                 # <Admin:0x007fa2df9a5590> returns the actual object
```

### Setting whodunnit to something other than an ActiveRecord object

You can continue to set whodunnit to something other than an `ActiveRecord` object.
- It follows standard PaperTrail functionality and adds the raw value to the whodunnit field.
- The `#actor` method will return the raw value.

```ruby
PaperTrail.request.whodunnit = "Alex the admin"
PaperTrail.request.whodunnit                                # "Alex the admin"
PaperTrail.request.actor                                    # "Alex the admin"

product.update(name: "99 Flake")
product.versions.last.whodunnit                             # "Alex the admin"
product.versions.last.actor                                 # "Alex the admin"
```

### Updating whodunnit on existing PaperTrail versions

You can retrospectivly update PaperTrail versions to have a new actor.

```ruby
most_recent_product_version = product.versions.last
admin_name = most_recent_product_version.actor              # "Alex the admin"
alex_the_admin = Admin.find_by(name: admin_name)            # Do check for `nil` before updating the whodunit field
most_recent_product_version.whodunnit = alex_the_admin
most_recent_product_version.save
most_recent_product_version.actor                           # <Admin:0x00000120fbb7d0>
```

### Setting whodunnit with a controller callback

Similar to how you can configure the PaperTrail gem, as described in [Setting Whodunnit with a Controller Callback](https://github.com/paper-trail-gem/paper_trail/?tab=readme-ov-file#setting-whodunnit-with-a-controller-callback), you can now set this to an ActiveRecord object. This allows storing the global ID and retrieving the actor using the `#actor` methods.

Here’s an example in your `ApplicationController`:

```ruby
class ApplicationController < ActionController::Base
  def user_for_paper_trail
    logged_in? ? current_user : "Public user"
  end
end
```
