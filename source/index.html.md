---
title: CanvasCBL API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - javascript

toc_footers:
  - <a href='https://docs.google.com/forms/d/1mQx-QK94kjOMi1-R0CcEHvOtm-NsnbD7EyDHo667RWc/edit'>Request a Developer Key</a>
  - <p>—</p>
  - <a href='https://canvascbl.com/'>CanvasCBL</a>

includes:
  - errors
  - glossary

search: true
---

# Introduction

Welcome to the CanvasCBL API! You can use the CanvasCBL API to get CBL Grades, along with information about outcomes, courses, users and more.

CanvasCBL has no official bindings at this time-- so you'll need to use your HTTP client of choice (hopefully, in your language of choice!) to make requests.

Currently, we offer API examples in JavaScript using [axios](https://github.com/axios/axios) and with cURL for testing.

## Contributing

See something wrong? Please help fix it!

The repository that builds these docs is open-source at [https://github.com/canvascbl/api-docs](https://github.com/canvascbl/api-docs).

## Base URL

> Our base URL (a 404!)

```shell
curl <%= api_base_url %>/

# 404 page not found
```

```javascript
const baseUrlRequest = await axios('<%= api_base_url %>/')

// 404 page not found
```

Our base URL is `<%= api_base_url %>/`. That's the starting point for all requests. Note that HTTP requests will be forwarded to HTTPS, but you've already sent the access token in plain text over the internet. Please use HTTPS!

## Times

> Seconds since epoch

```text
1580589676
```

> RFC3339

```text
2020-02-01T21:35:03Z
```

All times come back in UTC, whether they are in seconds since epoch or [RFC3339](https://www.ietf.org/rfc/rfc3339.txt). All integer times will be in seconds since epoch, and all string timestamps will be in RFC3339.

To make this easier, you can use a JavaScript library like [moment.js](https://momentjs.com/) in production, or a website like [epochconverter.com](https://epochconverter.com) during development.

# Authentication

The CanvasCBLs API uses OAuth2, a standard protocol for API authentication. To get the required Developer Key (your Client ID and Client Secret), follow the link below the table of contents on the left.

The access token should go in the HTTP `Authorization` header like this:

`Authorization: Bearer ilovecanvascbl`

Make sure you include the "Bearer " (note that space) in the header-- otherwise it may not work.

<aside class="notice">
Replace <code>ilovecanvascbl</code> with your access token.
</aside>

## Scopes

The following OAuth2 scopes are available, although your credentials may not have access to all scopes.

|Name                 |Description                                                                           |
|---------------------|--------------------------------------------------------------------------------------|
|user_profile         |Information about the user on Canvas, like their email, name and profile picture.     |
|observees            |Names and profile pictures of the user's observees (if applicable).                   |
|courses              |Detailed information about each course that currently has a grade.                    |
|alignments           |Outcome alignments for a specific class.                                              |
|assignments          |Detailed information about all assignments for every class you have access to.        |
|outcomes             |Details about any individual outcome you have access to.                              |
|grades               |Name of each class and its grade.                                                     |
|previous_grades      |Grades from the last time the user used CanvasCBL. Only applies to CanvasCBL+ users.  |
|average_course_grade |The average grade for any course the user is enrolled in.                             |
|average_outcome_score|The average score for any outcome in any course the user is enrolled in.              |
|outcome_results      |Specific scores on assignments.                                                       |
|detailed_grades      |Grades, along with each outcome score and whether the last alignment was dropped.     |

## Request

The OAuth2 request is a URL that the user **should be sent to in their browser**.

### Endpoint

`GET /api/oauth2/auth`

### Query String

| Param | Example Value | Description |
| ----- | ------------- | ----------- |
| `response_type` | `code` | **Required.** Must be `code`. |
| `client_id` | `d262d1d3-d969-4d48-ac1e-cfceec88b5c9` | **Required.** Your Client ID. |
| `scope` | `user_profile observees grades` | **Required.** Space-separated list of [scopes](#scopes) you would like access to. |
| `redirect_uri` | `https://dcraft.com/oauth2/response` | **Required.** The URI where the user will be redirected after the authorization. Must match the Redirect URI on your OAuth2 Credentials. |
| `purpose` | `dCraft` | Helps the user identify what this token is for. |

### Description

Prepare this URL, then send the user to it. **Do not use anything (ex. URL shorteners like bit.ly) that hide the identity of this URL.**

> Example URL (send the user to this)

```text
<%= api_base_url %>/api/oauth2/auth?response_type=code&client_id=d262d1d3-d969-4d48-ac1e-cfceec88b5c9&scope=user_profile%20observees%20grades&redirect_uri=https%3A%2F%2Fdcraft.com%2Foauth2%2Fresponse&purpose=dCraft
```

The user will now be forwarded to an opaque URL for authorization. If they accept or deny your request, they will be redirected to the specified redirect URI.

### After User Input

> Success

```text
https://dcraft.com/oauth2/response?code=3f17a378-b84a-4f42-a492-76f205364b81
```

> Error

```text
https://dcraft.com/oauth2/response?error=access_denied
```

After the user accepts or denies your request, they will be sent to your redirect URI with the following query params.
Note that there is no guarantee control will return to your application as they may close the tab, etc.

Success:

| Param | Example Value | Description |
| ----- | ------------- | ----------- |
| `code` | `3f17a378-b84a-4f42-a492-76f205364b81` | The code you'll need for your [token](#token) request. |

Error:

| Param | Example Value | Description
| ----- | ------------- | ----------- |
| `error` | `access_denied` | What the error was. |


## Token

> With a code

```shell
curl -X POST \
  "<%= api_base_url %>/api/oauth2/token?\
grant_type=authorization_code\
&client_id=d262d1d3-d969-4d48-ac1e-cfceec88b5c9\
&client_secret=d314d3d41e051cb569c55fe6c34d3dac\
&redirect_uri=https%3A%2F%2Fdcraft.com%2Foauth2%2Fresponse\
&code=3f17a378-b84a-4f42-a492-76f205364b81"
```

```javascript
const code = '3f17a378-b84a-4f42-a492-76f205364b81';

const tokenRequest = await axios({
  method: 'post',
  url: '<%= api_base_url %>/api/oauth2/token',
  params: {
    grant_type: 'authorization_code',
    client_id: 'd262d1d3-d969-4d48-ac1e-cfceec88b5c9',
    client_secret: '314d3d41e051cb569c55fe6c34d3dac',
    redirect_uri: 'https://dcraft.com/oauth2/response',
    code: code 
  }
});
```

> Code response

```json
{
  "access_token": "582caaaa-d89e-47f9-92a1-660d15be050a",
  "refresh_token": "4d1dbae6-0fff-4873-8930-845231fd26bc",
  "user": {
    "id": 1
  },
  "expires_at": "2020-02-01T21:35:03Z" // one hour later
}
```

> With a refresh token

```shell
curl -X POST \
  "<%= api_base_url %>/api/oauth2/token?\
grant_type=refresh_token\
&client_id=d262d1d3-d969-4d48-ac1e-cfceec88b5c9\
&client_secret=d314d3d41e051cb569c55fe6c34d3dac\
&redirect_uri=https%3A%2F%2Fdcraft.com%2Foauth2%2Fresponse\
&refresh_token=4d1dbae6-0fff-4873-8930-845231fd26bc"
```

```javascript
const refreshToken = '3f17a378-b84a-4f42-a492-76f205364b81';

const refreshTokenRequest = await axios({
  method: 'post',
  url: '<%= api_base_url %>/api/oauth2/token',
  params: {
    grant_type: 'refresh_token',
    client_id: 'd262d1d3-d969-4d48-ac1e-cfceec88b5c9',
    client_secret: '314d3d41e051cb569c55fe6c34d3dac',
    redirect_uri: 'https://dcraft.com/oauth2/response',
    refresh_token: refreshToken 
  }
});
```

> Refresh token response

```json
{
  "access_token": "f690f300-6fbb-4e17-a04a-bd032658ad13",
  "user": {
    "id": 1
  },
  "expires_at": "2020-02-01T21:38:36Z"
}
```

You can the token endpoint either to refresh an expired access token (access tokens last an hour) or to get a new access and refresh token from a code.

### Endpoint

`POST /api/oauth2/token`

### Query String

| Param | Required For | Values or Example Value | Description |
| ----- | ------------ | ----------------------- | ----------- |
| `grant_type` | Always | `authorization_code` or `refresh_token` | Represents what you want to do. `authorization_code` should be used when you have a `code` and `refresh_token` should be used when you have a refresh token and an expired access token. |
| `client_id` | Always | `d262d1d3-d969-4d48-ac1e-cfceec88b5c9` | Your Client ID. |
| `client_secret` | Always | `d314d3d41e051cb569c55fe6c34d3dac` | Your Client Secret. |
| `redirect_uri` | Always | `https://dcraft.com/oauth2/response` | The Redirect URI used when [first requesting the token](#request). |
| `code` | `grant_type` = `authorization_code` | The code from your Redirect URI ([?](#after-user-input)). |
| `refresh_token` | `grant_type` = `refresh_token` | The refresh token of the access token you'd like to refresh. |

### Description

This endpoint is the final step in the OAuth2 process, and is also how you 'refresh' an expired access token.

Developer Keys (your Client ID and Client Secret) can have an unlimited number of OAuth2 Grants, but **each grant may only have one valid access token at a time**.
This means that, if you want to use the CanvasCBL API concurrently (a completely supported behavior!) you need to be sure that each of your requests don't try to refresh the token at the same time.
If you do that, you're establishing a [race condition](https://en.wikipedia.org/wiki/Race_condition)-- don't do this!

<aside class="warning">
This request must be performed from a server where the user can never see the full URL as it includes your Client Secret.
</aside>

### Storing Grants

**You may store grants in your database.** However, you must (hopefully obviously) secure them as best as possible.
If a valid access token is leaked, an attacker may use that token to retrieve information without your knowledge.

It is not recommended to store your client secret in your database. Use an environment variable for that.

You get a unique ID for every user in the response from this endpoint. Use that to store access and refresh tokens for a user.

## Logout

> Invalidate that token!

```shell
curl \
  -X DELETE \
  -H "Authorization: Bearer ilovecanvascbl" \
  <%= api_base_url %>/api/oauth2/token
```

```javascript
await axios({
	"method": "delete",
	"url": "<%= api_base_url %>/api/oauth2/token",
	"headers": {
		"Authorization": "Bearer ilovecanvascbl"
	}
})
```

Logout lets you revoke an access token.

### Endpoint

`DELETE /api/oauth2/token`

### Description

Logout invalidates the grant used to call it. It returns a `204 NO CONTENT`.

When issuing this request, it's recommended to delete the grant associated with the used access token from your database.

<aside class="notice">
Once you have revoked a grant, you can not use this grant's refresh token to get a new access token. If you need access again, you must go through the OAuth2 flow again.
</aside>

# Grades

The most powerful part of the CanvasCBL API, by far.

## Get Grades

> Simple grades alone

```shell
curl \
  -X GET \
  -H "Authorization: ilovecanvascbl" \
  "<%= api_base_url %>/api/v1/grades"
```

```javascript
const gradesRequest = await axios({
	method: "GET",
	url: "<%= api_base_url %>/api/v1/grades",
	headers: {
		"Authorization": "Bearer ilovecanvascbl"
	}
});

// if you just care about the 'first' user's grades, you can do something like this:
const grades =
  // get a k/v array from our object
  Object.entries(gradesRequest.data.simple_grades).
  // reduce it into a single object
  reduce((acc, g) => {
    // g[0] = class name
    // g[1] = { userID: grade }
    // Object.values(g[1]) = [grade]
    acc[g[0]] = Object.values(g[1])[0];
    return acc;
    
    // we have this empty object here as our starting value for reduce
    // learn more: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce
  }, {});
/*
{ 'Calculus - S2 - Smith': 'A',
  'Biology - S2 - Martinez': 'B',
  'English 3 - S2 - Lee': 'A-',
  'World History - S2 - Brown': 'A' }
*/

// if you want something iterable (and just the first user's grade), try something like this:
const iterableGrades =
  // get a k/v array from our object
  Object.entries(gradesRequest.data.simple_grades).
  // use map to transform each item
  map(g => {
    // g[0] = class name
    // g[1] = { userID: grade }
    // Object.values(g[1]) = [grade]
    return [g[0], Object.values(g[1])[0]]
  });
/*
[ [ 'Calculus - S2 - Smith', 'A' ],
  [ 'Biology - S2 - Martinez', 'B' ],
  [ 'English 3 - S2 - Lee', 'A-' ],
  [ 'World History - S2 - Brown', 'A' ] ]
*/
```

> Simple grades (no includes[]) response

```json
{
  "simple_grades": {
    "Calculus - S2 - Smith": {
      // 1 (keys) is the graded user's Canvas ID
      // multiple entries will appear if the user is an Observer and has multiple Observees
      // in that case, you do NOT need the Observees include or scope.
      "1": "A"
    },
    "Biology - S2 - Martinez": {
      "1": "B"
    },
    "English 3 - S2 - Lee": {
      "1": "A-"
    },
    "World History - S2 - Brown": {
      "1": "A"
    }
  }
}
```

> Two includes, just as a template (scopes required: `user_profile`, `observees`)

```shell
curl \
  -X GET \
  -H "Authorization: ilovecanvascbl" \
  "<%= api_base_url %>/api/v1/grades?\
includes[]=user_profile\
&includes[]=observees"
```

```javascript
const gradesRequest = await axios({
	method: "GET",
  url: "<%= api_base_url %>/api/v1/grades",
  params: {
    includes: [
      'user_profile',
      'observees'
    ]
  }
	headers: {
		"Authorization": "Bearer ilovecanvascbl"
	}
});
```

> See the response [here](static/grades_responses/profile_observees.json).

> Kitchen Sink (simple grades, scopes: `user_profile`, `outcome_results`, `observees`, `courses`)

```shell
curl \
  -X GET \
  -H "Authorization: ilovecanvascbl" \
  "<%= api_base_url %>/api/v1/grades?\
includes[]=user_profile\
&includes[]=outcome_results\
&includes[]=observees\
&includes[]=courses"
```

```javascript
const kitchenSinkRequest = await axios({
	method: "GET",
  url: "<%= api_base_url %>/api/v1/grades",
  params: {
    includes: [
      'user_profile',
      'outcome_results',
      'observees',
      'courses'
    ]
  }
	headers: {
		"Authorization": "Bearer ilovecanvascbl"
	}
});
```

> See the response [here](static/grades_responses/everything_simple_grades.json).

> Kitchen Sink (detailed grades, scopes: `detailed_grades`, `user_profile`, `outcome_results`, `observees`, `courses`)

```shell
curl \
  -X GET \
  -H "Authorization: ilovecanvascbl" \
  "<%= api_base_url %>/api/v1/grades?\
includes[]=user_profile\
&includes[]=outcome_results\
&includes[]=observees\
&includes[]=courses\
&includes[]=detailed_grades"
```

```javascript
const kitchenSinkRequest = await axios({
	method: "GET",
  url: "<%= api_base_url %>/api/v1/grades",
  params: {
    includes: [
      'user_profile',
      'outcome_results',
      'observees',
      'courses',
      'detailed_grades'
    ]
  }
	headers: {
		"Authorization": "Bearer ilovecanvascbl"
	}
});
```

> See the response [here](static/grades_responses/everything.json).

### Endpoint

`GET /api/v1/grades`

### Scopes/Includes

Grades is a flexible endpoint that can return anything from just a user's class names and their grades to their profile, outcome results, outcome averages, full course and more.

You tell the grades endpoint what you want by using the `includes[]` query parameter.

If you do not include any `includes[]` parameters, only *simple grades* will be returned. *Simple grades* just requres the `grades` scope.
However, if you ask for `detailed_grades`, you will not get *simple grades*. It's one or the other.

While the `includes[]` parameter is intended to mirror [OAuth2 Scopes](#scopes), they may differ in the future, so the following table is here for convience.

| Includes Name | Required Scope |
| ------------- | -------------- |
| `detailed_grades` | `detailed_grades` |
| `user_profile` | `user_profile` |
| `outcome_results` | `outcome_results` |
| `observees` | `observees` |
| `courses` | `courses` |

### Description

Grades is, by far, the most powerful endpoint that the CanvasCBL API offers.

When using it, though, there are a few things to note:

- It is a slow endpoint. It relies on many responses from Canvas, which can take a while. 
If you want to set a reasonable timeout for this request, we recommend about 15 seconds. It's normally around 1-5 seconds.
- It is an expensive endpoint. There is a lot of computation on both sides which is required to make this work.
- We recommend that you re-fetch grades on every reload of your app.
- The user's Canvas ID may not appear in grades-- that generally means that the user is an Observer. For information about their Observees, you'll want to request `observees`.
- **You may not store anything but profiles.** Storing any information from this endpoint, (as you should know!-- except user_profile data) is a violation of the 
CanvasCBL Developer Key Agreement and will cause a revocation of your developer key.

If you're curious what the full response is from this endpoint (with all includes and scopes),
you can click [here for everything (simple grades)](static/grades_responses/everything_simple_grades.json) and [here for everything (detailed grades)](static/grades_responses/everything.json).

### Canvas API Bindings

Some of the `includes[]` options return responses that **essentially** mirror Canvas's API.
Not all fields will be there, notably large ones like descriptions. You can see what is and isn't included in the [Kitchen Sink response](static/grades_responses/everything.json).

Here's a reference to those:

| Includes Name | Canvas API Doc |
| ------------- | -------------- |
| `user_info` | [`GET /api/v1/users/:user_id/profile`](https://canvas.instructure.com/doc/api/users.html#method.profile.settings) |
| `outcome_results` | [`GET /api/v1/courses/:course_id/outcome_results`](https://canvas.instructure.com/doc/api/outcome_results.html#method.outcome_results.index) |
| `observees` | [`GET /api/v1/users/:user_id/observees`](https://canvas.instructure.com/doc/api/user_observees.html#method.user_observees.index) |
| `courses` | [`GET /api/v1/courses`](https://canvas.instructure.com/doc/api/courses.html#method.courses.index) |

# Courses

These APIs allow you to get auxiliary information about courses. Note that we do not have an API to get a course itself-- do this via [Get Grades](#get-grades), with the `courses` include.

## Get Assignments

> Get assignments for course ID `1`

```shell
curl \
  -X GET \
  -H "Authorization: ilovecanvascbl" \
  "<%= api_base_url %>/api/v1/courses/1/assignments"
```

```javascript
const kitchenSinkRequest = await axios({
	method: "GET",
  url: "<%= api_base_url %>/api/v1/courses/1/assignments",
	headers: {
		"Authorization": "Bearer ilovecanvascbl"
	}
});
```

> Response: Assignments for course ID `1`

```json
[
  {
    "allowed_attempts": -1,
    "anonymize_students": false,
    "anonymous_grading": false,
    "anonymous_instructor_annotations": false,
    "anonymous_peer_reviews": false,
    "anonymous_submissions": false,
    "assignment_group_id": 326,
    "automatic_peer_reviews": false,
    "can_duplicate": true,
    "course_id": 1,
    "created_at": "2019-08-26T15:04:16Z",
    "due_at": "2019-08-24T05:59:59Z",
    "due_date_required": false,
    "final_grader_id": null,
    "free_form_criterion_comments": false,
    "grade_group_students_individually": false,
    "grader_comments_visible_to_graders": true,
    "grader_count": 0,
    "grader_names_visible_to_final_grader": true,
    "graders_anonymous_to_graders": false,
    "grading_standard_id": null,
    "grading_type": "not_graded",
    "group_category_id": null,
    "has_submitted_submissions": false,
    "html_url": "https://canvas.instructure.com/courses/1/assignments/1",
    "id": 1,
    "in_closed_grading_period": false,
    "intra_group_peer_reviews": false,
    "is_quiz_assignment": false,
    "lock_at": "",
    "lock_explanation": "",
    "lock_info": {
      "asset_string": "",
      "can_view": false,
      "lock_at": ""
    },
    "locked_for_user": false,
    "max_name_length": 255,
    "moderated_grading": false,
    "muted": true,
    "name": "Assignment Name",
    "omit_from_final_grade": false,
    "only_visible_to_overrides": false,
    "original_assignment_id": null,
    "original_assignment_name": null,
    "original_course_id": null,
    "original_quiz_id": null,
    "peer_reviews": false,
    "points_possible": 0,
    "position": 1,
    "post_manually": false,
    "post_to_sis": false,
    "published": true,
    "quiz_id": 0,
    "rubric": null,
    "rubric_settings": {
      "free_form_criterion_comments": false,
      "hide_points": false,
      "hide_score_total": false,
      "id": 0,
      "points_possible": 0,
      "title": ""
    },
    "secure_params": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJsdGlfYXNzaWdubWVudF9pZCI6Iijil4_vvL5v77y-4pePKSJ9.81MdexcyaAsnMEpSWstOvbkpFhKpl9sO0wLbuh01DL4",
    "submission_types": [
      "not_graded"
    ],
    "submissions_download_url": "https://canvas.instructure.com/courses/1/assignments/1/submissions?zip=1",
    "unlock_at": "",
    "updated_at": "2019-10-17T01:39:57Z",
    "use_rubric_for_grading": false,
    "workflow_state": "published"
  },
  // ...
]
```

Get all assignments for a course.

### Endpoint

`GET /api/v1/courses/:courseID/assignments`

### Scopes

- `assignments`

### Description

This endpoint lets you get all assignments for a course.

Mostly a mirror of [this](https://canvas.instructure.com/doc/api/assignments.html#method.assignments_api.index) Canvas endpoint.

## Get Outcome Alignments

> Get outcome alignments for course ID `1` and student ID `1`

```shell
curl \
  -X GET \
  -H "Authorization: ilovecanvascbl" \
  "<%= api_base_url %>/api/v1/courses/1/outcome_alignments?\
student_id=1"
```

```javascript
const kitchenSinkRequest = await axios({
	method: "GET",
  url: "<%= api_base_url %>/api/v1/courses/1/outcome_alignments",
  params: {
    student_id: 1
  }
	headers: {
		"Authorization": "Bearer ilovecanvascbl"
	}
});
```

> Response: Outcome alignments for course ID `1` and student ID `1`

```json
[
  {
    "learning_outcome_id": 1,
    "title": "Outcome A",
    "assignment_id": 1,
    "submission_types": "on_paper",
    "url": "https://canvas.instructure.com/courses/1/assignments/1"
  },
  // ...
]
```

Gets Outcome Alignments for a course.

### Endpoint

`GET /api/v1/courses/:courseID/outcome_alignments`

### Scopes

- `alignments`

### Query String

| Param | Example Value | Description |
| ----- | ------------- | ----------- |
| `student_id` | `1` | **Required.** Canvas ID of the user you want alignments for. |

### Description

This endpoint gets outcome alignments for a course on Canvas.

Mostly a mirror of [this](https://canvas.instructure.com/doc/api/outcomes.html#method.outcomes_api.outcome_alignments) Canvas endpoint.

# Outcomes

These endpoints are about [Canvas Outcomes](https://canvas.instructure.com/doc/api/outcomes.html).

## Get an Outcome

> Get outcome ID `1`

```shell
curl \
  -X GET \
  -H "Authorization: ilovecanvascbl" \
  "<%= api_base_url %>/api/v1/outcomes/1"
```

```javascript
const kitchenSinkRequest = await axios({
	method: "GET",
  url: "<%= api_base_url %>/api/v1/outcomes/1",
	headers: {
		"Authorization": "Bearer ilovecanvascbl"
	}
});
```

> Response: Outcome ID `1`

```json
{
  "assessed": true,
  "calculation_int": 65,
  "calculation_method": "decaying_average",
  "can_edit": false,
  "context_id": 1,
  "context_type": "Course",
  "display_name": "Outcome A",
  "has_updateable_rubrics": false,
  "id": 1,
  "mastery_points": 2.5,
  "points_possible": 4,
  "ratings": [
    {
      "points": 4
    },
    {
      "points": 3
    },
    {
      "points": 2
    },
    {
      "points": 1
    }
  ],
  "title": "Full Title for Outcome A",
  "url": "/api/v1/outcomes/1",
  "vendor_guid": null
}
```


### Endpoint

`GET /api/v1/outcomes/:outcomeID`

### Scopes

- `outcomes`

### Description

Lets you get information about a single Outcome on Canvas.

Mostly a mirror of [this](https://canvas.instructure.com/doc/api/outcomes.html#method.outcomes_api.outcome_alignments) Canvas endpoint.
