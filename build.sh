docker build --squash -t joshbav/tractor:latest .
echo
echo
echo
echo Pushing newly built image to dockerhub
echo
docker push joshbav/tractor:latest
echo
echo
echo Uploading all files to github.com/joshbav/tractor
echo
# ALl files to automatically be added
git add *
git config user.name “joshbav” 
git commit -m "scripted commit $(date +%a-%b-%Y-%I-%M-%S)"
git push -u origin master

