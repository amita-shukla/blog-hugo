---
title: Understanding Types, Subtypes and Type Variance
tags:
- PROGRAMMING
- SCALA
author: Amita Shukla
date: '2021-04-28'
slug: understanding-type-subtypes-variance
type: post
draft: false
showTableOfContents: true
---
Most of us when we just start with programming, get confused with concepts of types, subtypes, inheritance, etc. But just as with the process of learning any language this all starts to come naturally to us, we grow up to casually use subtyping wherever we want in a program. In fact, it becomes almost unimaginable to code without these.  

Subtyping is nothing but writing one type in terms of another. Only when I started exploring other languages I realized that there are deeper theories to it, and maybe I do not understand subtypes to the extent I thought I did. I am writing this post in order to pass on this programming existential crisis to my fellow readers (but also attempting to develop an understanding along the way). We shall take subtyping a level further and understand how the assignment and substitution behaviour of our types affects our code behaviour (and subsequently ours).

Let's begin with an example. Let's say we have a class `Animal`. It can `speak` and `eat`.

```scala
class Animal(val name: String){
  def speak = "animal speaking"
  def eat = "animal eats"
  override def toString = "animal: " + name
}
```

While `Animal` has general properties, it can also be of two types: `Cat` and `Dog`. `Cat` and `Dog` `speak`, `eat` in their own way. Also, a dog has its own special function as well, `dogonly`. Similarly, a cat is special in its own way, say `catonly`.

```scala
class Cat(override val name: String) extends Animal(name) {
  override def speak = "meow"
  override def eat = "fish"
  def catonly : String = "cat only"
}

class Dog(override val name: String) extends Animal(name) {
  override def speak = "woof"
  override def eat = "bone"
  def dogonly : String = "dog only"
}
```

(_I do not have experience with pets, so pardon me if I did not implement Dog's and Cat's functions correctly..._)

With the above examples in mind, let's go over some concepts formally.
  
## Type
A type or a data type represents the type of data that tells the compiler/interpreter as to how the programmer intends to use that data. So, a type can be `Integer`, `String`, `Boolean`. We can create our own types as well, such as `Animal`, `Cat` and `Dog` as above. A type, the way it is defined, indicates what values it can take and what operations can be done on it.

## Subtyping 
Subtyping talks about the relationship between different types. We have a **subtype** and we have a **supertype**.

We can say that a type `B` is a subtype of `A` if:
- we can substitute `B` subtype in place of `A` supertype. 
- we can perform all the operations on `B` that can be performed on `A`. 

This is often written as `A :> B`, meaning that an instance of type `B` can be safely used wherever type `A` is expected. 

Let's be very clear on this as this will be the basis of our article: 
> If `Animal :> Cat`, then we can use `Cat` wherever we expect an `Animal`. 

So, if we have a list that expects objects of `Animal` type:

```scala
val animal1 = new Animal("animal1")
val animal2 = new Animal("animal2")
val animals : List[Animal] = List(animal1, animal2)
```

Then I can add a `Cat` type and a `Dog` type object to it as well:

```scala
val cat1 = new Cat("cat1")
val dog1 = new Dog("dog1")
val allTypesOfAnimals : List[Animal] = cat1 :: dog1 :: animals // this works as expected
```

But what about the reverse case? Does this relation hold true when the directions are reversed? 
Let's try passing an object of type `A` where `B` is expected when `A :> B`:

```scala
val cats : List[Cat] = List(cat1, cat2)
val brokenCats : List[Cat] = animal1 :: cats // error
```

Using the above example, it becomes clear that while we can add a `Cat` to a `List[Animal]`, we cannot add an `Animal` to a `List[Cat]`. The intuition behind this is that a subtype is special in some sense, and a supertype cannot replace it. Here, if we were to successfully pass `Animal` to a `List[Cat]`, it would break in case we call `catonly()` on `List[Cat]`. 

Working in OOP based languages makes this sound kinda obvious as we think about the same concept it in terms of Inheritance: an object of subclass cannot be passed where an object of superclass is required.

### Subtyping v/s Inheritance
At this point you may ask me, "Amita, why are you confusing us with subtyping and inheritance? Aren't we talking about inheritance here?" Well, actually, yes and no. I found this article <a href="https://www.cmi.ac.in/~madhavan/courses/pl2009/lecturenotes/lecture-notes/node28.html#:~:text=In%20the%20object%2Doriented%20framework,refers%20to%20compatibility%20of%20interfaces.&text=Inheritance%20refers%20to%20reuse%20of%20implementations." target="_blank">here</a> that can help:

> Subtyping refers to compatibility of interfaces. A type `B` is a subtype of `A` if every function that can be invoked on an object of type `A` can also be invoked on an object of type `B`.

> Inheritance refers to reuse of implementations. A type `B` inherits from another type `A` if some functions for `B` are written in terms of functions of `A`.

In OOP, inheritance and subtyping usually go hand in hand, the syntax being the same makes it more confusing. For example, in our case, `Cat` and `Dog` are subtypes of `Animal`: any operations done on `Animal` can be done on `Cat` and `Dog` as well. Also, `Cat` and `Dog` inherit from `Animal`: we have redefined (overridden) the function in `Animal` in `Dog` and `Cat`.

Inheritance helps you reuse the implementations  of methods/instance variables inside the super class, on the other hand, Subtyping deals with the safe behaviour of this class (a type) on the whole when it is passed to another data structure or function (formally called Variance, which we talk about later).

> Subclassing doesn't guarantee Subtyping.

When we talk about subtyping here, we don't discuss reusing implementations, but actually delve into the behaviours of types in different conditions.

## Variance -  Subtyping for complex types
Now that we have established how subtypes and supertypes are used and how they behave, let's take it a bit further. What about complex types? 

### Complex Types
Complex types are types that are composed of other types. e.g. `List`s, `Map`s, `Option`s, `Function`s etc... A `List` alone has no meaning. They are to be used as a list of some type, say `List[Integer]`, `List[Animal]` etc. Similarly, a `function` has a type signature, say, `func (a : Integer, b : String) : Boolean`. Here a function `func` has the type signature as `(Integer -> String) -> Boolean`.

Variance defined formally is 
> Variance is the correlation of subtyping relationships of complex types and the subtyping relationships of their component types.

### Subtyping with Lists: An instance of Covariance
We are going to continue with our example above to understand this concept step by step. Let's take a complex type, a `List`. If we have types `A` and `B` such that `A:>B`, how do we relate `List[A]` to a `List[B]`?

Reiterating on what we established above, if `A:>B`, we can pass `B` wherever we expect `A`. 

Subtyping on complex types gives rise to 2 cases: 

#### Case 1: pass `List[B]` where we expect `List[A]`

I have a function that expects a `List[Animal]` and does something with it:

```scala
def expectingListOfSupertype(animals : List[Animal]): Unit ={
  println(animals.map(_.toString))
}
```
Can I pass `cats: List[Cat]` in place of `animals: List[Animal]`?

```scala
expectingListOfSupertype(cats) // yes, I can!
```

#### Case 2: pass `List[A]` where we expect `List[B]`
This is the converse case to case 1.

```scala
def expectingListOfSubtype(cats: List[Cat]): Unit = {
  println(cats.map(_.catonly))
}

expectingListOfSubtype(animals) //type mismatch compile time error
```

No, I can't. This makes sense because if we could pass `List[Animal]` to the function where `List[Cat]` is expected, it could fail on calling the specific function `catonly` on an animal instance. 

Hence, in case of Lists, we can substitute `List[B]` in place of `List[B]` when `A:>B` but not the opposite.

This proves a direct relationship: 
> if `A:>B`, then `List[A]:>List[B]`

The above phenomenon is called **Covariance**.

### Subtyping with Functions: An instance of Contravariance
Let's take another example of a complex type `Function`. If we have types `A` and `B` such that `A:>B`, how do we relate `Function[A]` to a `Function[B]`?

Reiterating our subtyping relation of component types `A` and `B`, if `A:>B`, we can pass `B` wherever we expect `A`. Can this relation hold true for complex type Functions as well?

Let's define a function with supertype, and another function that calls this function.

```scala
val superTypeFunction : Animal => String = animal => s"${animal.name} is here"

def functionThatExpectsSupertypeFunction(fun: Animal => String) = {
    // calls fun somewhere
}
```
Similarly, we define a function with subtype, and another function that calls this function

```scala
val subTypeFunction : Cat => String = cat => s"${cat.name} cat is here and has special ${cat.catonly} behaviour"

def functionThatExpectsSubtypeFunction(fun: Cat => String) = {
    // calls fun somewhere
}
```
How are the functions going to behave in the following cases?
#### Case1: pass f[B] where we expect f[A] 
Lets try passing the subtype function to `functionThatExpectsSupertypeFunction`:

```scala
functionThatExpectsSupertypeFunction(subTypeFunction) // type mismatch!
```

The above scenario in case of functions doesn't compile. But why?

Let's consider the below implementation of `functionThatExpectsSupertypeFunction`:

```scala
def functionThatExpectsSupertypeFunction(fun: Animal => String) = {
  val fish = new Animal("nemo")
  println(fun(fish))
}
```
If the compiler could allow passing subtype function to the above, it would break coz internally it would call `fun: Cat => String` which can then try to call `catonly` on an `Animal`. Ouch!

#### Case2: pass f[A] where we expect f[B]
Now let's try passing supertype function to `functionThatExpectsSubtypeFunction`:

```scala
functionThatExpectsSubtypeFunction(superTypeFunction) // compiles!
```

On the other hand, we can pass a function of supertype where subtype is expected.

The intuition can be understood by thinking as to how this works in an example implementation. Suppose I implement `functionThatExpectsSubtypeFunction` like this:

```scala
def functionThatExpectsSubtypeFunction(fun: Cat => String) = {
  val cat = new Cat("kitty")
  println(fun(cat))
}
```
In the above scenario, even if we pass an `Animal => String` function to  `fun` parameter, it always supplies the subtype is supplied to it. And by definition of subtyping, `Cat` can be used wherever `Animal` is expected. Hence this works!

You can rightly observe, that `Function`s have the opposite subtyping behaviour as compared to `List`s. 

> if `A:>B`, then `Function[B]:>Function[A]`

This is called **Contravariance**.

### Subtyping with Arrays: An instance of Invariance
Let's talk about another data structure: `Arrays`. These are mutable data structures, so for an `Array[Animal]` we can write `Array[Cat]` anytime. At the same time while reading we can expect `Array[i]` can be an instance of `Animal`, `Cat` or `Dog`...

Thus, we can say that it can neither be safe for arrays to be Covariant or Contravariant. Confused? Wikipedia explains it better:

> If we wish to avoid type errors, then only the third choice is safe. Clearly, not every `Animal[]` can be treated as if it were a `Cat[]`, since a client reading from the array will expect a `Cat`, but an `Animal[]` may contain e.g. a `Dog`. So the contravariant rule is not safe.

> Conversely, a `Cat[]` cannot be treated as an `Animal[]`. It should always be possible to put a `Dog` into an `Animal[]`. With covariant arrays this cannot be guaranteed to be safe, since the backing store might actually be an array of cats. So the covariant rule is also not safe—the array constructor should be invariant.

```scala
val animalarray: Array[Animal] = Array(animal1, animal2)
val catarray: Array[Cat] = Array(cat1)

def expectingArrayOfSupertype(animals: Array[Animal])= {
  // some read/write operations
}
def expectingArrayOfSubtype(cats: Array[Cat]) = {
  // some read/write operations
}

expectingArrayOfSupertype(catarray) // type mismatch!!
expectingArrayOfSubtype(animalarray) // type mismatch!!

```
Both our cases fail for Arrays, they being **Invariant**.

#### Special case of Variance of Arrays in Java
For Java / C# developers, it is worth noting that Arrays are covariant. The reason is in detail <a href="https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)#Covariant_arrays_in_Java_and_C#" target="_blank">here</a>. Hint: it's because Generics was included much later in the language than Arrays...

## Rule of Thumb

Well, at this point it can be too much to digest. But there can be a simple rule of thumb to it:
- Read-only data types/sources can be covariant, e.g. immutable `List`s
- write-only data types/sinks can be contravariant, e.g. functions
- Mutable data types which act as both sources and sinks should be invariant. e.g. `Array`s

Contravariance is quite unintuitive in nature, as it is difficult to imagine a type with just write-only capabilities. In case of functions(the case where we're only talking about it *accepting* a type *once*), we can think that it took a subtype, but did not return it, hence making it 'write-only'. Usually, a complex type that accepts a simple type and simply consumes it, can be treated as contravariant.

## Try this code
This whole post makes more sense on running the code snippets. Checkout <a href="https://gist.github.com/amita-shukla/32f14cf325aa89296b10297862fc198f" target="_blank">this</a> gist which contains the entire code. I would recommend running them one by one and observe the magic of types yourself!

## Further Reading
- This <a href="https://en.wikipedia.org/wiki/Covariance_and_contravariance_(computer_science)" target="_blank">Wikipedia article</a> is my starting point, and the `Animal` example is inspired from here.
- <a href="https://en.wikipedia.org/wiki/Liskov_substitution_principle" target="_blank">Liskov's Substitution Principle</a>
- <a href="https://www.cs.princeton.edu/courses/archive/fall98/cs441/mainus/node12.html" target="_blank">SubTypes v/s Subclasses</a>
- <a href="https://www.cmi.ac.in/~madhavan/courses/pl2009/lecturenotes/lecture-notes/node28.html" target="_blank">Subtyping vs Inheritance</a>
- <a href="https://docs.scala-lang.org/tour/variances.html" target="_blank">Scala Docs: Variance</a>
