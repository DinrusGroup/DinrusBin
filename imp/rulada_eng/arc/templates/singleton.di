module arc.templates.singleton;


template SingletonMix() {
  static typeof(this) singletonInstance;

  this() {
    assert (singletonInstance is null);
    singletonInstance = this;
  }

  static typeof(this) getInstance() {
    if (typeof(this).singletonInstance is null) {
      new typeof(this);
      assert (typeof(this).singletonInstance !is null);
      static if (is(typeof(typeof(this).singletonInstance.initialize))) {
        typeof(this).singletonInstance.initialize();
      }
    }
    return typeof(this).singletonInstance;
  }

}
version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
