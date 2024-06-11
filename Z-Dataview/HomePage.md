---
author: Albert
date: 2024-05-06
date created: 2023-05-09
title: HomePage
---

# HomePage

## 标签

 ```dataviewjs
dv.paragraph(
  dv.pages("").file.etags.distinct()
  .sort(t => dv.pages(t).length , 'desc')
  .map(
  	t => {
		return `[${t}](${t})`+"("+dv.pages(t).length+")"
	}
  ).array().join(" ")
)
```

```dataviewjs
let nofold = '!"misc/templates"'
let allFile = dv.pages(nofold).file
let totalMd = "共创建*** "+allFile.length+" ***篇文档"
let totalTag = allFile.etags.distinct().length+" 个标签"
let totalTask = allFile.tasks.length+" 个待办。 <br><br>"
dv.paragraph(
	totalMd+"、"+totalTag+"、"+totalTask
)
```

## 日志

```dataviewjs

const today = new Date;
const nowYears = today.getFullYear();
const startTime = new Date('2022-12-08');
const endTime = today;

const allFiles = dv.pages();
const fileDates = allFiles.filter(el => el["date"] != undefined)
                          .filter(el => el["date"] > '2022-12-08')
                          .map(el => el["date"].slice(0, 10));

const weekName = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];

while (endTime - startTime >= 0) {
  const year = endTime.getFullYear();
  const month = endTime.getMonth() + 1 < 10 ? (`0${endTime.getMonth() + 1}`) : (endTime.getMonth() + 1);
  const day = endTime.getDate().toString().length == 1 ? '0' + endTime.getDate() : endTime.getDate();
  const weekDay = weekName[endTime.getDay()];
  
  endTime.setDate(endTime.getDate() - 1);
  const currentDate = `${year}-${month}-${day}`;
  
  if (weekDay === "星期日") {
      dv.span("**-------------------------------------------**")
  }
  if (!fileDates.includes(currentDate)) {
    continue;
  }
  
  const currentDayFiles =  dv.pages("")
                        	.filter(p => p["date"] >= "1900-01-01")
                          .filter(p => p["date"].slice(0, 10) == currentDate)
                          .filter(p => p.file.size > 138)
                          .sort(p => p["date"], 'desc');
                          
  const currentDayCounts = currentDayFiles.length
  const iconArray = ["🍺", "🚀", "🌿", "🦁", "🏅"]

  dv.paragraph(`*${currentDate}* ${weekDay} counts: ${currentDayCounts}`);
  dv.span(
     currentDayFiles.map(el => `${iconArray[currentDate.slice(-1) % 5]} ${el.file.link}`)
  )
}
 
```

## 待完成的问题

```dataviewjs
let today = new Date;
let nowYears = today.getFullYear();
let startTime = new Date('2022-12-08');
let endTime = today;

const allFiles = dv.pages();
const fileDates = allFiles.filter(el => el["date"] != undefined)
                          .filter(el => el["date"] == el["date created"])
                          .filter(el => el.file.size < 158)
                          .map(el => el["date"].slice(0, 10));
                          
while (endTime - startTime >= 0) {
  let year = endTime.getFullYear();
  let month = endTime.getMonth() + 1 < 10 ? (`0${endTime.getMonth() + 1}`) : (endTime.getMonth() + 1);
  let day = endTime.getDate().toString().length == 1 ? '0' + endTime.getDate() : endTime.getDate();
  endTime.setDate(endTime.getDate() - 1);
  let currentDate = `${year}-${month}-${day}`;
  
  if (!fileDates.includes(currentDate)) {
    continue;
  }
  
  let currentDayFiles =  dv.pages("")
                        	.filter(p => p["date"] >= "1900-01-01")
                          .filter(p => p["date"].slice(0, 10) == currentDate)
                          .sort(p => p["date"], 'desc');

  const iconArray = ["🍺", "🚀", "🌿", "🦁", "🏅"]
  dv.paragraph('*' + currentDate + '*');
  dv.span(
     currentDayFiles.map(el => `${iconArray[currentDate.slice(-1) % 5]} ${el.file.link}`)
  )
 
}
```
