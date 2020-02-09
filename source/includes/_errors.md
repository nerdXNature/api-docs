# Errors

> Example Error

```json
{
  "error": "example error message"
}
```

<aside class="notice">
Due to the sheer number of possible errors, it is not possible for us to document them all. We encourage you to play around with the API to get a feel for the errors.
</aside>

This section discusses Error Handling in the CanvasCBL API.

All errors are in JSON. See the example on the right.

## Session Error

> Session error text

```json
{
  "error": "no session string (pass it in via the session_string cookie)"
}
```

This means that **you have not passed in an API Key**.

## Validation Errors

> Validation Error Structure

```json
{
  "error": "<invalid/missing> <param name> as <param type, like url or query> param"
}
```

> Trying to submit `abcdef` as an outcome ID

```json
{
  "error": "invalid outcomeID as query param"
}
```

Validation errors pop up all the time, and they all take on the same form.

See the example on the right.

## OAuth2 Errors

OAuth2 Errors are self-evident:

- `missing requested scope`
- `invalid access token`
- `invalid refresh_token`
- ...

If you encounter an error you feel should be here, please help us out and document it!
These docs are open-source at [github.com/canvascbl/api-docs](https://github.com/canvascbl/api-docs).

## Grades Errors

> Example Grades Error With an Action

```json
{
  "error": "after refreshing the token, it is invalid",
  "action": "redirect_to_oauth"
}
```

Grades errors sometimes include an action.

| Action | What you should do |
| ------ | ------------------ |
| `redirect_to_oauth` | Tell the user to log into CanvasCBL at [canvascbl.com](https://canvascbl.com), then try again. |
| `retry_once` | Just try again in a sec. |

If no action is included, it's probably due to an extraordinary circumstance.

Currently, all possible grades errors are to the right.

```go
const (
    gradesErrorNoTokens              = "no stored tokens for this user"
	gradesErrorRevokedToken          = "the token/refresh token has been revoked or no longer works"
	gradesErrorRefreshedTokenError   = "after refreshing the token, it is invalid"
	gradesErrorUnknownCanvasError    = "there was an unknown error from canvas"
	gradesErrorInvalidInclude        = "invalid include"
	gradesErrorUnauthorizedScope     = "your oauth2 grant doesn't have one or more requested scopes"
	gradesErrorInvalidAccessToken    = "invalid access token"
)
```

## Errors From Canvas

Errors from Canvas will use the non-standard HTTP Status Code `450`.
There are various reasons we chose to do this, but mostly, it's because almost every error from Canvas is
user-error, for example when you enter an invalid Outcome ID.
