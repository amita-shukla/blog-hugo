---
title: How I resized the post image of blog posts
tags:
- CSS
- PROGRAMMING
- TECHNOLOGY
cover: blog_css.png
author: Amita Shukla
date: '2016-06-12'
slug: change-auto-resize-blogger
type: post
draft: false
---
Maintaining a blog is a real problem. And when using a custom template, it gets really difficult to even make a single change, as it may reflect somewhere else, if any careless action is made.

 


Out of the one change, a major (though it seemed trivial) problem that I faced was to change the default size of the pictures in the posts. Previously, the default behaviour of this blog post was to resize the picture on the home page to the post area.

This led to extremely large and blurred pictures.

 


And when it comes to the look of your page. What does wonders is:

### CSS !!

![image](blog_css.png)

 
First I needed to find out the class that surrounds this image. 
 
After search (using ctrl + f ) in the 'template' section, we can find classes like `post-image`, `img` . 
These classes are most likely to affect the image in the blog. 
 
I found out the code as : 
 

```css
 .post-image img{
 max-width:100%;
 height:auto;
 }
```
I changed the attributes here, as: 
 

```css
 .post-image img{
 max-width:50%;
 height:auto;
 }
```
 


This is because I realized that this is the setting for images in individual posts, where the images were displayed normally. 
And voila! it worked. 
But this caused another problem, all the images were shifted to the left! 
 
To fix this, I decided to make it up by coding CSS to bring images to the center area of the surrounding `div`. This is done by : 
 

```css
 .post-image img{
 display:block;
 margin-left:auto;
 margin-right:auto;
 max-width:50%;
 height:auto;
 }
```
Lets review what these properties do. 
 


#### display

The display property controls how an element is displayed in accordance with the parent element. The display property can be of two types: block and inline.

 


Block means that the element will acquire a complete block, that is, will take up the whole area in which it is extended, from left to right. e.g. div

Inline means, that the element will be lined up with the surrounding text. e.g. span.

 


Here the img is block that means it takes up the whole space.

 


#### margin

The margin specifies the space around the elements, outside the border. It can be margin-top, margin-bottom, margin-left, margin-right.

To bring the image to the center, I defined the left and right margin to auto. The auto property lets the margin to be calculated by the browser. Using this, we align the image element in the center horizontally.

 


As I could not find this fix anywhere else, I added it on [Stack Overflow](http://stackoverflow.com/a/37643409/3858467).

