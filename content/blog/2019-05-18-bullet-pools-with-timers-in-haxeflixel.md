+++
title = "Bullet Pools with Timers in HaxeFlixel"
+++

# Bullet Pools with Timers in HaxeFlixel

One of the more useful features of the flixel library is the inclusion of the [FlxTypedGroup](http://api.haxeflixel.com/flixel/group/FlxTypedGroup.html) class, which makes it easier to organize, update, and render multiple instances of an FlxBasic object. A few getter methods provide useful information such as the length of the group, or an array of every member in an instantiated group.

A practical application of FlxTypedGroup can be found in the ['Asteroids' demo](https://github.com/HaxeFlixel/flixel-demos/tree/master/Arcade/FlxTeroids/source) available via the HaxeFlixel repository. FlxTypedGroup's `recycle` method allows us to resuse bullet objects without having to destroy, recreate, and reallocate memory each time. Instead, bullets can be respawned from the queue after the pool has been "expended."

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
	for (i in 0...poolSize) {
		bullet = new Bullet();
		bullets.add(bullet);
	}
}
...
```

Within our Player class, we can then just reference the main PlayState's `bullets` pool to recycle `bullet` objects. 

```haxe
if (FlxG.keys.justPressed.Z) {
	var bullet:Bullet = PlayState.bullets.recycle();
	// YOUR BULLET VELOCITY CODE GOES HERE
}
```

After this, we just add our standard logic that handles bullet velocity, acceleration, or how, when, and where your Sprite class may spawn bullet objects. As seen in the example below, only 3 bullets may be on the screen at one time, with the earliest spawned bullet being replaced.

{{ img(src="/img/blog/haxeflixel-bullet-timers/1.gif", alt="asteroids animation") }}

Building on the example of the original Asteroids arcade game, we can give each bullet a limited lifetime, meaning if the bullet does not collide with another asteroid or enemy sprite, it should cease to exist after a certain period of time. Otherwise, it would continue travelling endlessly.

I was able to do this using HaxeFlixel's [FlxTimer](http://api.haxeflixel.com/flixel/util/FlxTimer.html) class, however, you may also use the standard [Timer](http://api.haxe.org/haxe/Timer.html) class included in the Haxe Toolkit.

Within my `Bullet.hx` class, I declare `timer` and initialize it as an FlxTimer object in the class constructor. 

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
		...
	}
}
```

Instead of creating a new FlxTimer object each time a bullet is recycled, the existing one is simply reset when needed.

Now back in the `Player.hx` class, we simply set and start the FlxTimer object for each bullet as they fire. The `start` method of an FlxTimer object [takes three arguments](http://api.haxeflixel.com/flixel/util/FlxTimer.html#start): 

```haxe
start(Time:Float = 1, ?OnComplete:FlxTimer‑>Void, Loops:Int = 1):FlxTimer
```

>**Time:Float** How many seconds it takes for the timer to go off. If 0 then timer will fire OnComplete callback only once at the first call of update method (which means that Loops argument will be ignored).

>**OnComplete:FlxTimer->Void** Optional, triggered whenever the time runs out, once for each loop. Callback should be formed "onTimer(Timer:FlxTimer);"

>**Loops:Int** How many times the timer should go off. 0 means "looping forever".

In the example below, I pass `2.0` for `Time`, an anonymous function for `OnComplete` that switches the bullets `exists` flag to `false`, and `1` for `Loops` so that the function only triggers once.

```haxe
if (FlxG.keys.justPressed.Z) {
	var bullet:Bullet = PlayState.bullets.recycle();
	bullet.timer.start(
		2.0,
		function (Timer:FlxTimer) {
			bullet.exists = false;
		},
		1
	);
}
```

So now, not only do you limit the amount of bullets that can be on the screen at once, but you can limit the duration for said bullets! It's a very neat and useful mechanic for balancing your game that can be applied to any pool of FlxBasic objects you may need, whether it be enemies, ammunition, or environmental objects.

{{ img(src="/img/blog/haxeflixel-bullet-timers/2.gif", alt="asteroids animation") }}
