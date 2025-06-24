---
author: Albert
date created: 2025-06-24
date modified: 2025-06-24
title: A-Test-Overview
---

# A-Test-Overview

```dataviewjs
// begin: change rootPath to fit your env
const rootPath = '"A-Test"'
// end

const firstPath = dv.pagePaths(`${rootPath}`)

const secondPath = firstPath
  .map(el => el.match(/\/(.+?)\//))
  .map(match => match && match[1])
  .filter(path => !!path)

const uniquePath = [... new Set(secondPath)].sort()

const iconArray = ["🍺", "🚀", "🌿", "🦁", "🏅"]
uniquePath.forEach((el, index) => {
  const targetPath = `"${rootPath.slice(1, -1)}/${el}"`
  const subPages = dv.pages(targetPath)
                    .map(el => iconArray[index % 5] + "  " +  el.file.link)
  const pageSize = subPages.length
  dv.paragraph(`** ${el} **  *total: ${pageSize}*`)
  dv.span(subPages)
})
//dv.span(uniquePath)
```


