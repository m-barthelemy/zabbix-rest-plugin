# zabbix-REST

A Zabbix plugin (Loadable Module) to make REST calls and parse responses.


### Why?

Zabbix integrated Web monitoring focuses on checking that a web endpoint is _working_, but is unable to parse the response content.

This plugin enables making an HTTP request and _extract a value_ from the response, if the response is formatted as JSON, XML or HTML


### Usage
This plugin currently provides 2 keys :


* `rest.request[verb, URL, responsePath, format, requestBody]` : makes an HTTP request and returns the parsed response value. 
* `rest.status[verb,URL,responsePath, format, requestBody]` : makes an HTTP request and returns the HTTP response status code.

#### `rest.request[verb=GET, URL, responsePath=/]`



#### `rest.request[verb=GET, URL, responsePath=/, format=auto|json|xml|html, requestBody=null]`

* `verb`: if left empty, defaults to `GET`. Can be `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.

* `URL`: Complete URL of the HTTP endpoint to query.
* `responsePath`: Path to the parsed response value to extract and return.


### Examples



### Installation


### Build from source

