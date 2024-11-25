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

to update the bib file (poor hack currently) - export entire library to new_graphiti repo and run

```
httr::GET(
  url = "https://raw.githubusercontent.com/NewGraphEnvironment/new_graphiti/main/assets/NewGraphEnvironment.bib",
  httr::write_disk("references.bib", overwrite = TRUE)
)
```

We should use the functions in this [post](https://www.newgraphenvironment.com/new_graphiti/posts/2024-05-27-references-bib-succinct/) in the future to clean the bib
so that we only store a few citations locally vs a monster file...
