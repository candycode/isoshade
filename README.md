Simple examples of how to render 3D surfaces and volumes defined with
implicit functions through GLSL.

Functions(w/ optional gradients), materials and the actual rendering algorithm
are split into different files loaded at run-time. If a gradient in symbolic form
is not available an approximate gradient is computed using finite differences.

Originally developed with versions of OpenGL < 3.x and tested on NVIDIA only.

Some FRAPS-captured animations:

[Blobs](http://www.youtube.com/watch?v=S8sFeA0l--8&feature=plcp)

[Hypertorus](http://www.youtube.com/watch?v=s9b9YUnWefc&feature=plcp)

[Barth sextic](http://www.youtube.com/watch?v=UBRP9pQyWRk&feature=plcp)

[Barth decic](http://www.youtube.com/watch?v=818AKL0f7dk&feature=plcp)

<iframe width="560" height="315" src="http://www.youtube.com/embed/S8sFeA0l--8" frameborder="0" allowfullscreen></iframe>

