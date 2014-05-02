class routeflow::mongodb ()
{
#  $mongo_databases=hiera_array("routeflow::mongo::databases")
#  mongodb::database {"$mongo_databases": ensure=>absent}

##FIXME(aglarendil): rewrite some RF code and this stuff to use separate db and drop it at once
  exec{'drop-mongo-collections':
       command =>  "mongo db --eval \"db.getCollection('rftable').drop(); 
        db.getCollection('rfconfig').drop(); 
        db.getCollection('rfstats').drop(); 
        db.getCollection('rfclient<->rfserver').drop(); 
        db.getCollection('rfserver<->rfproxy').drop(); \""
      }

}
