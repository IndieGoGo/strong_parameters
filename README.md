# Indiegogo Modified Strong Parameters

This is a modified version of the [Strong Parameters]
gem. It differs from the original gem in these ways:

* This one is not all or nothing. You include ActionController::StrongParameters
  explicitly in
  specific controllers. This allows you to have some controllers
  with strong parameters and others without.

* Likewise, with standard strong parameters, the logging vs raise vs
  do nothing setting for unpermitted parameters effects all controllers.
  This version allows you to log some controllers while raising in others.
  To log, include ActionController::LoggingParameters.

[Strong Parameters]: https://github.com/rails/strong_parameters
