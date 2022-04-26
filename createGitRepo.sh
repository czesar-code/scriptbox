# create a new repository on the command line (last updated 22/04/26)

echo "# scriptbox" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/githubnorm/scriptbox.git
git push -u origin main