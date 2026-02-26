-- html-image.lua
function Image(img)
  -- Apply inline style for HTML output: wider images and nice spacing
  img.attributes.style = "width: 90%; margin: 1em auto; display: block;"
  return img
end
