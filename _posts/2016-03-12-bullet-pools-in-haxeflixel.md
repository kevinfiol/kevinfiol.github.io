---
layout: post
title: Bullet Pools with HaxeFlixel
---

One of the more useful features of the flixel library is the inclusion of the `FlxTypedGroup` class, which makes it easier to organize, update, and render multiple instances of an `FlxBasic` object. A few getter methods provide useful information such as the length of the group, or an array of every member in an instantiated group.

A practical application of `FlxTypedGroup` can be found in the ['Asteroids' demo](https://github.com/HaxeFlixel/flixel-demos/tree/master/Arcade/FlxTeroids/source) available via the HaxeFlixel repository. Through use of `FlxTypedGroup`'s `recycle` method, we can reuse bullet objects without having to destroy and recreate them, reallocating memory each time. Instead, bullets can be respawned from the queue after the pool has been "expended."

>Note: In the demo example available in the HaxeFlixel repository, the properties of each bullet are initialized on the fly within `PlayState.hx`. For my example, I have created a separate `Bullet` class for the sake of convenience.

In the current PlayState, we can create and initialize a pool called `bullets` which we will populate with bullet objects from which we can spawn bullets as we please. In this case, I will create a pool with a maximum size of 3.

```haxe
class PlayState extends FlxState
{
	public static var bullets:FlxTypedGroup<Bullet>;
	override public function create():Void
	{
		var poolSize:Int = 3;
		var bullet:Bullet;
		bullets = new FlxTypedGroup<Bullet>(poolSize);
	}
}
```
From here, we can write a simple loop to create new bullet objects and simply add them to the existing group.

```haxe
...
override public function create():Void
{
	var poolSize:Int = 3;
	var bullet:Bullet;
	bullets = new FlxTypedGroup<Bullet>(poolSize);
	for(i in 0...poolSize){
		bullet = new Bullet();
		bullets.add(bullet);
	}
}
...
```

Now, from within your Player class (or wherever you wish to trigger the bullet spawning), simply reference your main FlxState's `bullets` pool to recycle `bullet` objects. 
Note: in this example, I have omitted the logic which handles bullet velocity:

```haxe
if(FlxG.keys.justPressed.Z){
	var bullet:Bullet = PlayState.bullets.recycle();
}
```

After this, you can just add your standard logic that handles bullet velocity, acceleration, or how, when, and where your Sprite class may spawn bullet objects. As seen in the example below, only 3 bullets may be on the screen at one time, with the earliest spawned bullet being replaced.

<div class="img-container">
	<video autoplay="autoplay" loop="loop" src="{{ site.url }}/assets/webm/1.webm"></video>
</div>

Building on the example of the original Asteroids arcade game, we can give each bullet a limited lifetime, meaning if the bullet does not collide with another asteroid or enemy sprite, it should cease to exist after a certain period of time. Otherwise, it would continue travelling endlessly.

I will be using HaxeFlixel's `FlxTimer` class, however, you may also use `Timer` class included in the Haxe Toolkit.

Within my `Bullet.hx` class, I declare and initialize a new `FlxTimer` object in the class constructor. 

```haxe
class Bullet extends FlxSprite
{
	public var timer:FlxTimer;
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		timer = new FlxTimer();
		//YOUR OBJECT PROPERTIES GO HERE
	}
	override public function update(elapsed:Float):Void
	{
		FlxSpriteUtil.screenWrap(this);
		super.update(elapsed);
	}
}
```

Instead of creating a new `FlxTimer` object each time a bullet is recycled, the existing one is simply reset when needed.

Now back in the `Player.hx` class, we simply set and start the `FlxTimer` object for each bullet as they fire. The `start` method of an `FlxTimer` object takes three arguments: 

1. The first argument, a Float, `2.0` signifies the amount of time in seconds it will take until the timer is complete. 
2. The second argument signifies a function which will be triggered upon the timer's completion; in this example, I pass an anonymous function that sets the current bullet's `exists` flag to `false`.
3. The third argument signifies how many times the timer will loop. In this case, I only want it to trigger once, so I pass a Int, `1`.

```haxe
if(FlxG.keys.justPressed.Z){
	var bullet:Bullet = PlayState.bullets.recycle();
	bullet.timer.start(
		2.0, 
		function(Timer:FlxTimer){
			bullet.exists = false;
		},
		1
	);
}
```

So now, not only do you limit the amount of bullets that can be on the screen at once, but you can limit the duration for said bullets! It's a very neat and useful mechanic that can be applied to any pool of FlxBasic objects you may need, whether it be enemies, ammunition, etc.

<div class="img-container">
	<video autoplay="autoplay" loop="loop" src="{{ site.url }}/assets/webm/2.webm"></video>
</div>