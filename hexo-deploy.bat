git add .
git commit -m "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"
git push
hexo clean && hexo deploy