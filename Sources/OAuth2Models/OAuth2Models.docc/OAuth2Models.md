# ``OAuth2Models``

`Codable` models for handling OAuth2 requests.

## Overview

OAuth2Models defines a set of Request, Response and Error models as specified in [RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749).

The models enforce certain aspects, like enforcing an appropriate `grantType` value,
as well as a special ``GrantRequest`` type for multiplexing between the various
different requests, if the server should support multiple types.

## Topics

### Initiating a request

- ``AuthCodeAccessTokenRequest``
- ``AuthRequest``
- ``ClientCredentialsAccessTokenRequest``
- ``PasswordAccessTokenRequest``
- ``RefreshTokenRequest``
- ``GrantRequest``

### Responding to a request

- ``AccessTokenError``
- ``AccessTokenResponse``
- ``AuthCodeAuthResponse``
- ``ErrorResponse``

### Miscellaneous

- ``CharacterSetValidationError``
- ``ErrorDescription``
- ``ErrorURL``
- ``Scope``
- ``TokenExpiration``
