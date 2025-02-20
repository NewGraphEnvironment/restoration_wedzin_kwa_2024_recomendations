To build:


```
shinylive::export(
  appdir = ".", 
  destdir = "docs"
)

#for serving on gitpages
fs::file_create("docs/.nojekyll")
```

To view locally:

    servr::httd("docs")
    
    
seems this doesn't want to work anymore

    httpuv::runStaticServer("docs")

to update the bib file - export entire library to xciter since we are calling that in `app.R` to keep things simple for now

```
path_bib <- system.file("extdata", "NewGraphEnvironment.bib", package = "xciter")
```
