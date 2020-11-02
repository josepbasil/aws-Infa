//simple Express.js RESTful API
'use strict';
//initialize
const
port = 8080,
express = require('express'),
version = 1.2,
app = express();
//version/ GET request
app.get('/version/', (req, res) =>
          res.json(
           { message: `My app version is ${version}`}
            )
            );
//start server
            app.listen(port, () =>
            console.log(`Server started on port ${port}`));
