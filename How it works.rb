We start with instance of router and some controllers created
(like we normally do in rails that extend Phase6::ControllerBase)

1. Get request comes in to server:

  GET /cats HTTP/1.1
  Host: en.wikipedia.org

2. Before we get to the router, it gets turned into
  get Regexp.new("^/cats$"), Cats2Controller, :index

3.
