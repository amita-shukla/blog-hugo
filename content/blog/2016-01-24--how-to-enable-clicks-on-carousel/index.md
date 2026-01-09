---
title: How to enable clicks on Carousel
tags:
- FRONTEND
- CSS
- JAVASCRIPT
- JQUERY
author: Amita Shukla
date: '2016-01-24'
slug: how-to-enable-clicks-on-carousel
type: post
draft: false
---
Yesterday as I was editing my [Portfolio](http://amita-shukla.github.io/) which has the carousel functionality, I encountered a peculiar functionality. None of the left clicks on the link worked. However, the links opened on pressing the right click and clicking \"open in new tab\". 
 
After a little search, I got the answer at the the life saver [Stack Overflow](http://stackoverflow.com/a/23812607/3858467). It explains that the Carousel API prevents the default functionality of any click using `e.preventDefault()`. Hence, none of the clicks are going to work. 
 
Now this was a problem as Carousel is an important element for my website and I could not afford to get rid of the links as well. 
 
So I tried the following approach: 
 
In my file [script.js](https://github.com/amita-shukla/amita-shukla.github.io/blob/master/js/script.js), I wrote: 
 
```js
 $(document).ready(function(e) {
 $('.regular-link').click(function(e){
 e.stopPropagation();
 });
 //more code here
 }
```
 
The `e.stopPropagation()` prevents an event to bubble up to its parent, i.e, this event is not caught by the parent element `data-slide=\"1\"`. 
Now whenever I needed a link to work, I added class `regular-link` in the `<a>` tag and whoa! it works now!

