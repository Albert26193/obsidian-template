---
author: Albert
date created: 2024-06-11
date modified: 2025-06-24
title: Todo
---

# Todo

- 该文件可以过滤出全局的 todo item

```dataviewjs
const allFiles = dv.pages().map(el => el.file.frontmatter);
const fileDates = allFiles.filter(el => el["date modified"] != undefined)
                          .filter(el => el["date modified"] > '2022-12-12')
                          .map(el => el["date modified"].slice(0, 10));

const excludeDirs = [
  "Z-Template",
  //"Z-Dairy",
  "Z-Excalidraw",
  // "CS-算法",
];

const excludeNames = [
  "题单",
];

const filterCurrentDayFiles = (currentDate) => {
  const currentDayFiles = dv.pages("")
    .filter(f => !excludeDirs.some(dir => f.file.path.includes(dir)))
    .filter(f => !excludeNames.some(name => f.file.path.includes(name)))
    .filter(p => p.file.frontmatter["date modified"] >= "1900-01-01")
    .filter(p => p.file.frontmatter["date modified"].slice(0, 10) == currentDate)
    .filter(p => p.file.size > 120)
    .filter(p => p.file.tasks.some(task => !task.completed))
    .filter(p => p.file.tasks.text.length <= 30)
    .sort(p => p.file.frontmatter["date modified"], 'desc');

  return currentDayFiles;
};


const handleCurrentDayFiles = (currentDate, currentDayFiles) => {
  dv.paragraph('**' + currentDate + '**');
  const incompleteTasks = dv.taskList(currentDayFiles.file.tasks.filter(t => !t.completed));
  dv.paragraph('===========================');
  return incompleteTasks;
};

const today = new Date();
const startTime = new Date('2023-01-01');

const processDate = (endDate) => {
  const endTime = new Date(endDate);
  const dates = Array.from({ length: (endTime - startTime) / (1000 * 60 * 60 * 24) }, (_, i) => {
    const date = new Date(endTime.getTime() - (i * 1000 * 60 * 60 * 24));
    return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
  });

  const incompleteTasks = dates
    .filter(currentDate => fileDates.includes(currentDate))
    .map(currentDate => {
      const currentDayFiles = filterCurrentDayFiles(currentDate);
      if (currentDayFiles.length > 0) {
        return handleCurrentDayFiles(currentDate, currentDayFiles);
      } else {
        return [];
      }
    })
    .flat();
};

dv.paragraph('===========================');
processDate(today);
```
