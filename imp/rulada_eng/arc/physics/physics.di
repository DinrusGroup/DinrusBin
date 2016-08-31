module arc.physics.physics; 

import arc.physics.colliders.boxcircle; 

// sole purpose is to workaround the static this() bug with open()

void open()
{
	// will register physics system if it has not been registered
	arc.physics.colliders.boxcircle.register(); 
	arc.physics.colliders.box.register();
	arc.physics.colliders.circle.register();
}
version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
