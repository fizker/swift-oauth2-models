# Choosing a Request type

Choosing the correct Request type is essential.


## Overview

OAuth2 supports a range of different types of grant requests. It is important to
choose the correct type for the situation.

Note that for any of the requests, it is possible to get an ``ErrorResponse`` back.


### Username + password

The ``PasswordAccessTokenRequest`` requires a username and password. It is specially
designed for this usecase.

The ``ClientCredentialsAccessTokenRequest`` also works, if the server supports it.
In this case, submit the request authentication using the HTTP Basic authentication scheme.

On success of either type, the server will respond with a ``AccessTokenResponse``.


### Pre-agreed auth token

If the app have a pre-agreed auth token, such as a certificate or
[JSON Web Tokens](https://datatracker.ietf.org/doc/html/rfc7519), use
``ClientCredentialsAccessTokenRequest``.

The authentication can be negotiated with the server in any way that the server wants.
The HTTP `Authorization` header is often the preferred mechanism.

On success, the server will respond with a ``AccessTokenResponse``.


### Requesting auth from user

In most OAuth2 situations, the user is asked to grant the app permission. This is done using the ``AuthRequest``.
It supports either the `Implicit Grant` or the `Authorization Code Grant` types.

For the `Authorization Code Grant`, set the ``AuthRequest/responseType-swift.property``
property to ``AuthRequest/ResponseType-swift.enum/code``. After the user have authorized,
a request will be made with an ``AuthCodeAuthResponse`` containing the code from the server.
The app then have to exchange this code by sending an ``AuthCodeAccessTokenRequest``.
On success, the server will respond with an ``AccessTokenResponse`` with the token.

For the `Implicit Grant` type, after the user have authorized the app, an ``AccessTokenResponse``
will be sent immediately.


### Refreshing an access token

To refresh an access token, the ``RefreshTokenRequest`` type is used. On success,
the server will respond with an ``AccessTokenResponse``.
