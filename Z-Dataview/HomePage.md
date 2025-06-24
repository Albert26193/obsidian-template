---
author: Albert
date created: 2023-05-09
date modified: 2025-06-24
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
const getDateFromFileName = (fileName) => {
  if (typeof fileName !== "string" || fileName.length < 8) {
    return new Date();
  }
  const fullDateString = fileName.slice(-8);
  const yearString = fullDateString.slice(0, 4);
  const monthString = fullDateString.slice(4, 6);
  const dayString = fullDateString.slice(-2);
  const date = new Date(`${yearString}-${monthString}-${dayString}`);
  if (isNaN(date)) {
    return new Date();
  }
  return date;
};

const formatDate = (date) => {
  const weekName = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
  const year = date.getFullYear();
  const month = date.getMonth() + 1 < 10 ? `0${date.getMonth() + 1}` : date.getMonth() + 1;
  const day = date.getDate().toString().length === 1 ? `0${date.getDate()}` : date.getDate();
  const currentWeekName = weekName[date.getDay()];
  return `${year}-${month}-${day}    ${currentWeekName}`;
};

const weekName = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
const iconArray = ["🍺", "🚀", "🌿", "🦁", "🏅"];
const minDateString = '2022-12-08'; // 定义最小日期字符串

// 1. 一次性获取所有页面，并进行初步过滤和排序
const allRelevantPages = dv.pages("")
  .filter(p => {
    // 检查 p.frontmatter.date 是否存在，是字符串，且日期部分大于等于最小日期
    return p.file.frontmatter && p.file.frontmatter["date modified"] && typeof p.file.frontmatter["date modified"] === 'string' && p.file.frontmatter["date modified"].slice(0, 10) >= minDateString;
  })
  // 添加你的其他过滤条件，例如文件名、标签、字数等
  // 请注意：文件名、标签和字数是 p.file 的属性
  .filter(p => p.file.size > 18) // 过滤文件大小 > 18
  // 如果需要过滤文件名或标签，可以在这里添加
  // .filter(p => p.file.name.toLowerCase().includes("todo") || (p.file.tags && p.file.tags.includes("#todo")))
  // .filter(p => p.file.wordCount === undefined || p.file.wordCount < 150)
  .sort(p => p.file.frontmatter["date modified"], 'desc'); 

// 2. 创建一个 Map，将日期字符串映射到该日期的页面列表
const pagesByDate = new Map();
allRelevantPages.forEach(p => {
  const dateString = p.file.frontmatter["date modified"].slice(0, 10);
  if (!pagesByDate.has(dateString)) {
    pagesByDate.set(dateString, []);
  }
  pagesByDate.get(dateString).push(p);
});

// 3. 保持从当前日期回溯的循环逻辑
const today = new Date();
const startTime = new Date('1899-12-01');
const endTime = new Date(today); // 创建 today 的副本

let thisWeekHasContent = false; // 变量保留

while (endTime - startTime >= 0) {
  const year = endTime.getFullYear();
  const month = endTime.getMonth() + 1 < 10 ? (`0${endTime.getMonth() + 1}`) : (endTime.getMonth() + 1);
  const day = endTime.getDate().toString().length == 1 ? '0' + endTime.getDate() : endTime.getDate();
  const weekDay = weekName[endTime.getDay()];

  const currentDate = `${year}-${month}-${day}`;

  // 4. 从预处理的 Map 中获取当前日期的页面列表
  const currentDayFiles = pagesByDate.get(currentDate) || []; // 如果 Map 中没有该日期，则返回空数组

  const currentDayCounts = currentDayFiles.length;

  // 5. 只在有内容时渲染该日期
  if (currentDayCounts > 0) {
      thisWeekHasContent = true; // 设置变量

      dv.paragraph(`*${currentDate}* ${weekDay} counts: ${currentDayCounts}`);
      dv.span(
         currentDayFiles.map(el => `${iconArray[new Date(currentDate).getDate() % 5]} ${el.file.link}`)
      );
  }

  // 递减日期
  endTime.setDate(endTime.getDate() - 1);
}
```
