# zabbix-REST

A native Zabbix plugin (Loadable Module) to make REST calls and parse responses.


### Why?

Zabbix integrated Web monitoring focuses on checking that a web endpoint is _working_, but is unable to parse the response content.

This plugin enables making an HTTP request and _extract a value_ from the response, if the response is formatted as JSON, XML or HTML.


### Usage
This plugin currently provides 2 Zabbix Item keys :


* `rest.request[]` : makes an HTTP request and returns the parsed response value. 
* `rest.status[]` : makes an HTTP request and returns the HTTP response status code.


##### rest.request[`verb`=GET, `URL`, _`responsePath`=/, `format`=json|xml|html, `requestHeaders`=null, `requestBody`=null_ ]


* `verb`: Can be `GET`, `POST`, `PUT`, `PATCH`, `DELETE`. If left empty, defaults to `GET`. 

* `URL`: Complete URL of the HTTP endpoint to query.

* `responsePath` (optional): "Path" to the parsed response value to extract and return. Xpath syntax is supported for XML and HTML. For JSON, a very limited syntax is available, see examples below. If left empty, defaults to `/` ("all").

* `format` (optional): by default the response format is detected automatically, using the response `Content-Type` header. This option allows to set the content type of the request body if the `requestBody` option is used, as well as "forcing" the format of the response. The following values are supported: `json`, `xml`, `html`.

* `requestHeaders` (optional): Request headers, as a JSON array of key-value pairs. Example: `[{"Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR..."}]`.

* `requestBody` (optional): Request body. Must be quoted and inner quotes escaped if it contains spaces. 


### Path syntax

* For XML and HTML: compatible with Xpath. See for example https://www.w3schools.com/xml/xpath_syntax.asp


* For JSON:

Access a document property: `/propertyName` 

Or for nested documents: `/propertyName/subPropertyName`

Access Array item: `/arrayPropertyName[index]`

Note: for consistency with Xpath, arrays start at index 1.


### Examples

`rest.request[GET,https://jsonplaceholder.typicode.com/posts]` : retrieves a list of posts and returns the raw JSON result:
```
[
{
"body": "occaecati a doloribus\niste saepe consectetur placeat eum voluptate dolorem et\nqui quo quia voluptas\nrerum ut id enim velit est perferendis",
"userId": 8,
"title": "et iusto veniam et illum aut fuga",
"id": 71
},
{
"body": "quam occaecati qui deleniti consectetur\nconsequatur aut facere quas exercitationem aliquam hic voluptas\nneque id sunt ut aut accusamus\nsunt consectetur expedita inventore velit",
"userId": 8,
"title": "sint hic doloribus consequatur eos non id",
"id": 72
},
...
]
```


`rest.request[GET,https://jsonplaceholder.typicode.com/posts/1,/userId]` : retrieves the post with id `1` and returns its `userId` field.



### Limitations

Some important limitations are to be considered ; most of them are due to some features of the Swift Foundation library being only partially supported under Linux, as of Swift 3.1

 - HTTPS requests will fail if the server has an invalid SSL certificate.
 - Requests that returns a redirect response (3xx status code) will fail.


### Installation

[TBD]


### Build from source

[TBD]

### Questions and issues
Feel free to open a Github issue!


