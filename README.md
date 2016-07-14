docker-lfs
====================

CentOS6 + logfaces v4.2.4 inside.

You could run it with your own configs, just mount your conf folder to `/conf`. 
Your files would be linked as logFaces configs.

E.g.: put your `lfs.xml` and `lfs.lic` to `/mnt/data/lfs/conf/` and map `/mnt/data/lfs/conf/` to `/conf`.

By default logfaces uses embedded Derby as its own database.
If you want to use Mongo as database, please run container with MONGO_URL environment variable.
See example.

### Environment variables
* `MONGO_URL` like mongo.example.com:27017

### Example
```
docker run -d -t -p 8050:8050 -p 55200:55200 -p 1468:1468 -p 55201:55201 -p 514:514/udp \ 
-e "MONGO_URL=mongo.example.com:27017" -v /mnt/data/lfs/conf:/conf \
--name lfs-prod varsy/lfs
```
