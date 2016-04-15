## Ruby On Rails Face Detection Tutorial

### [View Demo here](https://rails-face-detect-demo.herokuapp.com)
This is tutorial using the API from [Gem "Face"](https://github.com/rociiu/face) - made by [SkyBiometry](https://skybiometry.com/Documentation).

Register for an account at [SkyBiometry](https://skybiometry.com).

Go down to the "Applications" section, and create a new application.  Note the "API key" and "API Secret"


Now, create a new Rails project:

<tt>rails new face-detect</tt>

and go into that directory

<tt>cd face-detect</tt>


Add to your Gem file:
<tt>gem "face"</tt>

and run 
<tt>bundle install</tt>

You could start the server now
<tt>rails s</tt>

... just be sure to open a new Terminal window to put additional commands in.



Make a new controller/view called "face" with a single action called "index"

<tt>rails g controller face index</tt>

Update the routes.rb:
```Ruby
# /routes.rb 
Rails.application.routes.draw do

  get '/face' => 'face#index'

  root 'face#index'
  
end
```


Create initializers/face.rb and have it reference those variables:

```Ruby
# /initializers/face.rb 
FACE_API_KEY='my-key-here-in-single-quotes'
FACE_SECRET_KEY='my-key-here-in-single-quotes'
```



NOTE, Potential Upgrade: Put this in an ".env" file and exclude that from the code pushed to GitHub

http://stevesohcot.com/tech-lessons-learned/2016/01/04/rails-setting-up-environmental-variables-so-passwords-arent-in-github/


Copy the code:


```Ruby
# /controllers/appliation_controller.rb
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def face_detect(image_source)

      # Return ONLY true/false
      # Potential upgrade: return also the "confidence"

      client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)

      original_output = client.faces_detect(urls: [image_source] , attributes: 'all')

      begin

        face_detection  = original_output['photos'].first['tags'].first['attributes']['face']
        detected        = face_detection['value']
        #confidence     = face_detection['confidence']

      rescue Exception => error

        detected    = false
        #confidence  = 999

      end

      # return ONLY true/false
      detected

  end

end
```


```Ruby
# /controllers/face_controller.rb
class FaceController < ApplicationController
  
  def index

    if params[:image_url]
      @image_source = params[:image_url]
      @face_detected = face_detect(@image_source)
    end

  end

end

```

```Ruby
# /views/face/index.html.erb
<h1>Ruby On Rails Face Detection Demo</h1>

<h3><a href="https://github.com/stevesohcot/rails-face-detect.git">View code source on GitHub</a></h3>

<%= form_tag("/face", method: "get") do %>
  <%= label_tag(:image_url, "Image URL") %>
  <%= text_field_tag(:image_url, @image_source, size: 100) %>
  <%= submit_tag("Detect") %>
<% end %>

<p>Sample pictures (click to pre-populate textbox above)</p>
<ul>
  <li><a hef="#" onClick="document.getElementById('image_url').value = 'http://www.edrants.com/wp-content/uploads/2013/03/googleglassimage.jpg';">person wearing google glass</a></li>
  <li><a hef="#" onClick="document.getElementById('image_url').value = 'http://www.atlantatrails.com/images/high-shoals-falls-waterfall/4-high-shoals-falls-trail-blue-hole-waterfall.jpg';">waterfall</a></li>
</ul>


<% if @image_source %>

  <hr />

  <br />Face detected: <%=@face_detected%>
  <br />Image URL: <%=@image_source%>
  <br /><%=image_tag(@image_source)%>

<% end %>
```



To run it: go to the index (or /face) and put in the URL of an image

In the demo, you can click on one of the two bullet-points to pre-populate a URL. 
Notes:
-  I was unable to have images on the same web server (even in the "public" folder)
-  When deploying to Heroku, make sure you remove the reference to SQLLite (or else you'll get an error)

### [View Demo here](https://rails-face-detect-demo.herokuapp.com)