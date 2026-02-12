  cd app
  npm install
  pm2 stop all
  pm2 delete all
  pm2 start app.js