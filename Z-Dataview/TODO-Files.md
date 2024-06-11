---
author: Albert
date created: 2023-11-09 19:14
date: 2023-11-09 19:14
title: TODO-Files
---

# TODO-Files

```dataviewjs
const today = new Date;
const nowYears = today.getFullYear();
const startTime = new Date('2022-12-08');
const endTime = today;

const allFiles = dv.pages();
const fileDates = allFiles.filter(el => el["date"] != undefined)
                          .filter(el => el["date"] > '2022-12-01')
                          .map(el => el["date"].slice(0, 10));

const weekName = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];

while (endTime - startTime >= 0) {
  const year = endTime.getFullYear();
  const month = endTime.getMonth() + 1 < 10 ? (`0${endTime.getMonth() + 1}`) : (endTime.getMonth() + 1);
  const day = endTime.getDate().toString().length == 1 ? '0' + endTime.getDate() : endTime.getDate();
  const weekDay = weekName[endTime.getDay()];
  
  endTime.setDate(endTime.getDate() - 1);
  const currentDate = `${year}-${month}-${day}`;
  
  if (!fileDates.includes(currentDate)) {
    continue;
  }
  
  const currentDayFiles =  dv.pages("")
                        	.filter(p => p["date"] >= "1900-01-01")
                          .filter(p => p["date"].slice(0, 10) == currentDate)
                          .filter(p => p.file.name.toLowerCase().includes("todo"))
                          .sort(p => p["date"], 'desc');
                          
  const currentDayCounts = currentDayFiles.length
  const iconArray = ["🍺", "🚀", "🌿", "🦁", "🏅"]

  if (currentDayCounts > 0) {
    dv.paragraph(`*${currentDate}* ${weekDay} counts: ${currentDayCounts}`);
  }

  if (weekDay === "星期日") {
      dv.span("**-------------------------------------------**")
  }
 
  dv.span(
     currentDayFiles.map(el => `${iconArray[currentDate.slice(-1) % 5]} ${el.file.link}`)
  )
}
 
```
