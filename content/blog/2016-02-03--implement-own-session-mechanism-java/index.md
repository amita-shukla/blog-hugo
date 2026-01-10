---
title: How I implemented my own Session Mechanism in my project Mail Aggregator
tags:
- JAVA
- FRONTEND
- JAVASCRIPT
- JQUERY
- PROJECT
author: Amita Shukla
date: '2016-02-03'
slug: implement-own-session-mechanism-java
type: post
draft: false
showTableOfContents: true
---
While working on my project [Mail Aggregator](https://github.com/amita-shukla/mail-aggregator/tree/master/src), I went on to implement my own session mechanism, which I share in this post. 
 


### What is a Session?

[Http](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol) is a stateless protocol, i.e. it does not remember you the instant you move on to another page.

But this poses a problem. Some information needs to be present throughout some or all the pages of a website. For example, the user information. You usually see a message similar \"Welcome! Your name\" on the top of every page of the website in which you are logged in.

 


### Why was Session needed in Mail Aggregator?

The Mail Aggregator also uses session to maintain user information across the application. The client-server communication in this project occurs through web services, which do not maintain sessions , unlike those on which I previously worked, .NET, PHP, J2EE...

 


Writing my own implementation offered simplicity and flexibility. Personally, learning to build my session mechanism gave me an insight on how a session works which are otherwise beautifully packaged in popular web frameworks.

 


### An Outline

1. When a user logs in, verify if the credentials are correct.
2. If verified, create a token, such that it is unique for every user.
3. Save this token in the database with primary key as the token, along with user_id. We can have other details like timestamp (login time).
4. Send this token back to the client side where it can be saved as cookie.
5. Whenever any other web service is invoked, this token is sent back to server with other request data.
6. The token is received on the server side and its presence is checked in the database.
7. If an entry does not exist in the database, make the session invalid and send an error message to the client.
8. If an entry exists, extract the corresponding user_id, and carry forward the request.
9. On logging out, delete the token on the client side and the database entry on the server side.

Lets dive into the details. 
 


#### 1. User Log In

The details of the user are taken from the login form and packed as [JSON](http://www.json.org/) object and communicated to the server side by `LoginWebService`. The `LoginWebSerice` the calls the `LoginController`. 
Dig more: [LoginWebService.java](http://mail-aggregator/src/webservices/LoginWebService.java), [LoginController.java](http://mail-aggregator/src/controller/LoginController.java) 
 


#### 2. Create a unique token for every user

For creating a unique token, I assume that no two users attempt to login at the same time instant. This assumption holds true until the interface receives a lot of hits.

The token is chosen as: 
```java
int token = (int) (System.currentTimeMillis() % 1000000000);
``` 


The code above returns a 9 digit number. 
 


#### 3. Save the token in database

We can write a function that inserts this token in the database, such as given below. Let the table name be `token`.

```java
public boolean insertToken(int user_id, int token) throws SQLException {
	ps = con.prepareStatement("insert into token(user_id, token) values (?,?)");
	ps.setInt(1, user_id);
	ps.setInt(2, token);
	
	if (ps.executeUpdate() == 1) {
		return true;
	}

	return false;
}
```

#### 4. Send token back to client side

For this project, I need to send a lot of information back for every request. But, as we know, we can only return a single object in java. Hence I wrap all the information in an object `serverResponse`.

The `serverResponse` object contains two fields, an object of `Object` type and an object of `Status` type.

 


The `status` object contains information if the request made was successful or not.

 


An object of Object type allows me to send any information irrespective of its type.

 


For example, here I send the token (int type), whereas I send an arrayList of emails in another request.

So here, I set the object as token:

```java
ServerResponse serverResponse = new ServerResponse();
//a funtion that validates email and password
Status status = lv.validate(email, password); 

// === some code ===

serverResponse.setStatus(status);
serverResponse.setObject(token);

// === some more code ===

return serverResponse;
``` 

This token is wrapped as JSON object and extracted on the client side using AJAX. The access token is saved in the user's browser: 
```js
localStorage.setItem("accessToken", data.obj);
``` 


 
Dig in more: [Object type in java](https://docs.oracle.com/javase/7/docs/api/java/lang/Object.html), [Status.java](https://github.com/amita-shukla/mail-aggregator/blob/master/src/Utils/Status.java), [ServerResponse.java](https://github.com/amita-shukla/mail-aggregator/blob/master/src/Utils/ServerResponse.java)

 


#### 5. Send token with other request data on each subsequent request

The token is attached with the data for each request that is made after the login as follows:

```java
invokeService(){
  // == some code ==
  data: JSON.stringify(
      "accessToken" : localStorage.getItem("accessToken");
      // == other data ==
  );
  
  // == some more code ==
}
``` 


 


For example, you can check function `invokeAddAccount()` in this [file](https://github.com/amita-shukla/mail-aggregator/blob/master/WebContent/UI/js/login.js).

 


#### 6. Verify the token entry in the database

The following function makes an SQL query to check if the token exists in the table.

```java
public ResultSet selectUserIdFromToken(int accessToken) throws SQLException {
		ResultSet rs = null;
		ps = con.prepareStatement("select user_id from token where token=?");
		ps.setInt(1, accessToken);
		rs = ps.executeQuery();
		return rs;
}
``` 

#### 7. If no entry exists, declare the session invalid.

This function is called in a `Validator` class. If no entry exists, i.e. `selectUserIdFromToken.first()` returns false, an error message is displayed.

```java
public Status validate(int accessToken) throws SQLException {
		Status status = new Status();
		DB_Queries d = DB_Queries.getInstance();
		// ResultSet rs = null;

		if (!(d.selectUserFromToken(accessToken)).first()) {
			status.setErrMessage("User Logged Out");
			status.setResponseStatus(ResponseStatus.FAILURE);

		} else {
			status.setResponseStatus(ResponseStatus.SUCCESS);
		}

		return status;
}
``` 


#### 8. Extract user information if an entry exists

Given a token if it exists, we can extract the corresponding `user_id` from the `token` table. Hence we can obtain all the user information, as a `user` table exists with all the user information with `user_id` as the primary key. 
 
```java
DB_Queries d = DB_Queries.getInstance();

rs1 = d.selectUserFromToken(token);

int user_id = 0;
if (rs1.next()) {
	user_id = rs1.getInt(1);
}

//given the user id,
//extract other information
ResultSet rs = d.selectEmail(user_id);
// == more code == 
```

#### 9. On logging out, delete the token

Once the user clicks on the logout button, the entry of token stored in the browser using the following javascript code.

```js
function logout() {
	if (localStorage.getItem("accessToken") != null) {
		invokeLogout(localStorage.getItem("accessToken"));
		localStorage.removeItem("accessToken");
	}

	// == more code ==
}
``` 


On the server side, we need to delete the token entry. This is a precautionary measure, if suppose the token is not deleted even on logout. Also, once user has logged out, the entry with the token becomes useless. So it should be deleted for reducing memory overhead.

```java
public boolean deleteToken(int accessToken) throws SQLException {
		ps = con.prepareStatement("delete from token where token=?");
		ps.setInt(1, accessToken);
		if (ps.executeUpdate() == 1)
			return true;
		else
			return false;
}
```


To explore more, you can check out [OAuth 2](http://oauth.net/2/), popular for its use by Google APIs for authentication and authorization.
