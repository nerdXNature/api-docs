# Glossary

The glossary contains definitions for terms that may not be clear throughout the documentation.

## Developer Key

> Client ID

```text
d262d1d3-d969-4d48-ac1e-cfceec88b5c9
```

> Client Secret

```text
d262d1d3-d969-4d48-ac1e-cfceec88b5c9
```

A Client ID/Client Secret combo. These are granted, upon request and review, by CanvasCBL alone.

They may never be shared or posted publicly.

## OAuth2 Credential

Another term for a [Developer Key](#developer-key).

## OAuth2 Grant

An OAuth2 Grant is a Access/Refresh Token combo. They are linked to a Redirect URI, a number of scopes, and a [Developer Key](#developer-key).

You can see an example grant response in the [Token request documentation](#token).

## OAuth2 Redirect URI

> Example Redirect URI

```text
https://dcraft.com/oauth2/response
```

Where users will be sent after accepting/denying your OAuth2 Request.

## Access Token

Short-lived tokens that **grant access to resources**. Currently, they last an hour.

They can be regenerated with a [Refresh Token](#refresh-token).

## Refresh Token

Long-lived tokens that can be used, along with some other information, to get new [Access Tokens](#access-token).