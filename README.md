# folder_thumbnailer
Shell script for bulk generating custom folder thumbnails based on a base folder icon.

For all images in /source script:
- changes all filenames to lowercase
- converts all jpeg/jpg to png
- scales images down to max 1000x1000px
- superimposes all the images over the base.png folder image
- saves the final image to /merged

Example workflow with modified Kora folder icon:

![Workflow example](https://raw.githubusercontent.com/j-jasz/folder_thumbnailer/9758938856b3b725908db22a293668e0ee68e6e7/workflow.png)

Directory structure:

root<br>
&nbsp;├─ folder_thumb.sh<br>
&nbsp;└─ images<br>
&nbsp;&nbsp;&nbsp;&nbsp;├─ base.png<br>
&nbsp;&nbsp;&nbsp;&nbsp;├─ source<br>
&nbsp;&nbsp;&nbsp;&nbsp;├─ temp<br>
&nbsp;&nbsp;&nbsp;&nbsp;└─ merged