# Indiegogo Modified Strong Parameters

This is a modified version of the [Strong Parameters]
gem. This version is intended to facilitate adoption of StrongParameters
on large rails apps where it may be difficult to know all of the valid
attributes for a particular controller and action.

When you implement strong parameters as described below, unpermitted
params are signaled via airbrake _and_not_ filtered. This allows your
app to continue running without UnpermittedParameters exceptions.

With standard strong parameters, the handling of unpermitted params is
established for the entire app and can be either do nothing, log, or
raise.

This version allows you to be notified via [Airbrake]
in some controllers and models while raising in others.

To enable Airbrake notifications rather than exceptions in a
particular controller just `include
ActionController::AirbrakeUnpermittedParameters` after including
`ActionController::StrongParameters`, like so:

```ruby
  class NewBooksController < ActionController::Base
    include ActionController::StrongParameters
    include ActionController::AirbrakeUnpermittedParameters

    def create
      params.permit(:book => [:pages])
      head :ok
    end
  end
```

To enable Airbrake notifications rather than exceptions in a
particular model just `include ActiveModel::AirbrakeForbiddenAttributes` after including
`ActiveModel::ForbiddenAttributesProtection`, like so:

```ruby
  class NewBook < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    include ActiveModel::AirbrakeForbiddenAttributes
  end
```

However, if you did not protect the controller the model is accessed in with `include ActionController::StrongParameters`,
then the model protection will not work, that is, it won't raise exception or log to Airbrake.

[Strong Parameters]: https://github.com/rails/strong_parameters
[Airbrake]: https://airbrake.io/
